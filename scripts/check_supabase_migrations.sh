#!/usr/bin/env bash
# Validate Supabase migrations on a throwaway Postgres container:
#   1. supabase-dev and supabase-prod hold the same migrations
#   2. every migration applies, in order, on an empty database
#   3. migrations added since BASE_REF can be applied a second time
#
# Usage: scripts/check_supabase_migrations.sh [BASE_REF]
# Requires Docker. See docs/supabase-migrations.md.
set -euo pipefail

BASE_REF="${1:-}"
IMAGE="${SUPABASE_POSTGRES_IMAGE:-public.ecr.aws/supabase/postgres:17.6.1.043}"
CONTAINER="check-supabase-migrations-$$"
DEV_DIR="supabase-dev/supabase/migrations"
PROD_DIR="supabase-prod/supabase/migrations"

cd "$(git rev-parse --show-toplevel)"

echo "==> Comparing $DEV_DIR and $PROD_DIR"
if ! diff -r "$DEV_DIR" "$PROD_DIR"; then
  echo "::error::Migrations differ between supabase-dev and supabase-prod"
  exit 1
fi

ERR_FILE="$(mktemp)"
cleanup() {
  docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
  rm -f "$ERR_FILE"
}
trap cleanup EXIT

echo "==> Starting $IMAGE"
docker run -d --name "$CONTAINER" -e POSTGRES_PASSWORD=postgres "$IMAGE" >/dev/null

psql_exec() {
  docker exec -i -e PGPASSWORD=postgres "$CONTAINER" \
    psql -h 127.0.0.1 -U postgres -d postgres -v ON_ERROR_STOP=1 -q "$@"
}

# The init scripts run on a socket-only server; wait for the TCP listener.
for _ in $(seq 1 60); do
  if psql_exec -tAc 'select 1' >/dev/null 2>&1; then
    break
  fi
  sleep 2
done
psql_exec -tAc 'select 1' >/dev/null

apply() {
  local file="$1"
  echo "    $(basename "$file")"
  if ! psql_exec -f - <"$file" >/dev/null 2>"$ERR_FILE"; then
    cat "$ERR_FILE"
    echo "::error file=$file::Migration failed"
    exit 1
  fi
}

echo "==> Applying all migrations"
for file in "$PROD_DIR"/*.sql; do
  apply "$file"
done

if [[ -n "$BASE_REF" ]]; then
  added="$(git diff --name-only --diff-filter=A "$BASE_REF"...HEAD -- "$PROD_DIR" | sort)"
  if [[ -n "$added" ]]; then
    echo "==> Re-applying migrations added since $BASE_REF"
    while IFS= read -r file; do
      apply "$file"
    done <<<"$added"
  fi
fi

echo "==> OK"
