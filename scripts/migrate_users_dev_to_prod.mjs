import { createClient } from "@supabase/supabase-js";
import "dotenv/config";

const {
  SUPABASE_DEV_URL,
  SUPABASE_DEV_SERVICE_ROLE_KEY,
  SUPABASE_PROD_URL,
  SUPABASE_PROD_SERVICE_ROLE_KEY,
} = process.env;

// 🧩 --- VALIDATION DE BASE ---
if (
  !SUPABASE_DEV_URL ||
  !SUPABASE_DEV_SERVICE_ROLE_KEY ||
  !SUPABASE_PROD_URL ||
  !SUPABASE_PROD_SERVICE_ROLE_KEY
) {
  console.error("❌ Missing environment variables in .env");
  process.exit(1);
}

// 🚨 --- VÉRIFIE QUE DEV ≠ PROD ---
if (SUPABASE_DEV_URL === SUPABASE_PROD_URL) {
  console.error(
    "❌ DEV and PROD URLs are identical! Aborting migration to avoid overwriting production."
  );
  process.exit(1);
}

const getRefFromUrl = (url) => {
  const match = url.match(/https:\/\/([^.]+)\.supabase\.co/);
  return match ? match[1] : null;
};

const devRef = getRefFromUrl(SUPABASE_DEV_URL);
const prodRef = getRefFromUrl(SUPABASE_PROD_URL);

if (devRef && prodRef && devRef === prodRef) {
  console.error(
    `❌ The two projects appear to have the same reference (${devRef}). Aborting.`
  );
  process.exit(1);
}

console.log(
  "✅ Safety check passed: dev and prod point to different projects."
);
console.log(`   • DEV → ${SUPABASE_DEV_URL}`);
console.log(`   • PROD → ${SUPABASE_PROD_URL}`);

// --- INITIALISE LES CLIENTS SUPABASE ---
const dev = createClient(SUPABASE_DEV_URL, SUPABASE_DEV_SERVICE_ROLE_KEY);
const prod = createClient(SUPABASE_PROD_URL, SUPABASE_PROD_SERVICE_ROLE_KEY);

async function main() {
  console.log("\n🔍 Fetching users from DEV...");

  let users = [];
  let page = 1;
  const pageSize = 1000;

  while (true) {
    const { data, error } = await dev.auth.admin.listUsers({
      page,
      perPage: pageSize,
    });
    if (error) throw error;
    if (!data.users.length) break;
    users = [...users, ...data.users];
    page++;
  }

  console.log(`✅ Found ${users.length} users in DEV.`);

  console.log("\n🚀 Migrating users to PROD...");
  let success = 0,
    skipped = 0,
    failed = 0;

  for (const user of users) {
    const { email, user_metadata } = user;

    const { data: existing } = await prod.auth.admin.listUsers({
      perPage: 1000,
    });
    const alreadyExists = existing?.users?.some((u) => u.email === email);

    if (alreadyExists) {
      console.log(`⚠️ Skipping ${email} (already exists in prod)`);
      skipped++;
      continue;
    }

    const { error: createError } = await prod.auth.admin.createUser({
      email,
      email_confirm: true,
      user_metadata,
    });

    if (createError) {
      console.error(`❌ Failed to create ${email}: ${createError.message}`);
      failed++;
    } else {
      console.log(`✅ Created ${email}`);
      success++;
    }
  }

  console.log("\n🎉 Migration complete!");
  console.log(`✅ ${success} created`);
  console.log(`⚠️ ${skipped} skipped`);
  console.log(`❌ ${failed} failed`);
}

main().catch((err) => {
  console.error("💥 Fatal error:", err);
  process.exit(1);
});
