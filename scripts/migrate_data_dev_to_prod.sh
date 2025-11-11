#!/bin/bash
set -euo pipefail

# === 🧩 Load environment variables ===
if [ ! -f .env ]; then
  echo "❌ Error: .env file not found at project root."
  exit 1
fi

# Load .env variables
set -o allexport
source .env
set +o allexport

if [[ -z "${DEV_DB_URL:-}" || -z "${PROD_DB_URL:-}" ]]; then
  echo "❌ DEV_DB_URL or PROD_DB_URL not defined in .env"
  exit 1
fi

FORCE=${1:-""}

echo "🔍 Checking if production database (public schema only) is empty..."
TABLE_COUNT=$(psql "$PROD_DB_URL" -Atc "
  SELECT COUNT(*) 
  FROM pg_stat_user_tables 
  WHERE schemaname = 'public' AND n_live_tup > 0;
")

if [ "$TABLE_COUNT" -gt 0 ]; then
  echo "⚠️  Production database already contains $TABLE_COUNT non-empty tables."
  if [ "$FORCE" != "--force" ]; then
    echo "❌ Aborting to avoid overwriting existing data."
    echo "👉 Use './scripts/migrate_data_dev_to_prod.sh --force' to override."
    exit 1
  else
    echo "⚠️  --force flag detected, proceeding anyway..."
  fi
else
  echo "✅ Production database (public schema) is empty. Proceeding..."
fi

echo "🚀 Exporting data from DEV (public schema only)..."
pg_dump \
  --data-only \
  --no-owner \
  --no-privileges \
  --disable-triggers \
  --inserts \
  --schema=public \
  "$DEV_DB_URL" > data_dump.sql

echo "📤 Importing data into PROD with disabled constraints..."
psql "$PROD_DB_URL" <<'SQLBLOCK'
SET session_replication_role = replica;
\i data_dump.sql
SET session_replication_role = DEFAULT;
SQLBLOCK

echo "📊 Rows per table after migration:"
psql "$PROD_DB_URL" -P pager=off -c "
  SELECT relname AS table_name, n_live_tup AS rows_estimated
  FROM pg_stat_user_tables
  WHERE schemaname = 'public'
  ORDER BY relname;
"

echo "🧹 Cleaning up temporary files..."
rm -f data_dump.sql

echo "🎉 Migration complete! All public data from DEV successfully imported into PROD."
