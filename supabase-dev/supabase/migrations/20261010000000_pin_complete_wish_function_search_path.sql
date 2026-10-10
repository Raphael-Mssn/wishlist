-- Pin search_path on the public functions added or redefined by the
-- complete-wish feature, left out of 20261005170000_pin_function_search_path.
-- Both bodies already work with an empty search_path: nb_wishs_by_user fully
-- qualifies its tables, and now() resolves through pg_catalog.

ALTER FUNCTION "public"."nb_wishs_by_user"("user_id" "uuid")
    SET search_path = '';

ALTER FUNCTION "public"."update_user_completed_wishs_updated_at"()
    SET search_path = '';


-- Verification:
-- SELECT p.proname, p.proconfig
--   FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
--  WHERE n.nspname = 'public'
--    AND p.proname IN ('nb_wishs_by_user',
--                      'update_user_completed_wishs_updated_at');
--   -> proconfig = {search_path=""} for both functions
