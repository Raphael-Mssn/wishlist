-- Pin search_path on public functions and fully qualify the objects they use.
-- Restrict EXECUTE on SECURITY DEFINER functions to the roles that need them.

CREATE OR REPLACE FUNCTION "public"."delete_user_account"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET search_path = ''
    AS $$
BEGIN
  -- Supprimer l'utilisateur de auth.users
  -- Cela déclenchera automatiquement la suppression en cascade
  -- de toutes les données associées si les contraintes FK sont bien configurées
  DELETE FROM auth.users
  WHERE id = auth.uid();
END;
$$;


CREATE OR REPLACE FUNCTION "public"."is_friend_or_friend_of_friend"("_user_id" "uuid", "_friend_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET search_path = ''
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.friendships
    WHERE (requester_id = _user_id AND receiver_id = _friend_id) OR
          (requester_id = _friend_id AND receiver_id = _user_id) OR
          (requester_id = _user_id AND receiver_id IN (
              SELECT CASE
                WHEN requester_id = _user_id THEN receiver_id
                ELSE requester_id
              END
              FROM public.friendships
              WHERE requester_id = _user_id OR receiver_id = _user_id
          )) OR
          (receiver_id = _user_id AND requester_id IN (
              SELECT CASE
                WHEN requester_id = _user_id THEN receiver_id
                ELSE requester_id
              END
              FROM public.friendships
              WHERE requester_id = _user_id OR receiver_id = _user_id
          ))
  );
END;
$$;


CREATE OR REPLACE FUNCTION "public"."update_user_metadata"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET search_path = ''
    AS $$
BEGIN
  -- Mettre à jour les metadata et display_name dans auth.users
  UPDATE auth.users
  SET
    raw_user_meta_data = jsonb_set(
      jsonb_set(
        COALESCE(raw_user_meta_data, '{}'),
        '{pseudo}',
        to_jsonb(NEW.pseudo)
      ),
      '{display_name}',
      to_jsonb(NEW.pseudo)
    )
  WHERE id = NEW.id;

  RETURN NEW;
END;
$$;


-- delete_user_account: only signed-in users delete their own account.
REVOKE EXECUTE ON FUNCTION "public"."delete_user_account"() FROM PUBLIC, "anon";

-- is_friend_or_friend_of_friend: only used by the friendships SELECT policy,
-- which targets the authenticated role.
REVOKE EXECUTE ON FUNCTION "public"."is_friend_or_friend_of_friend"("_user_id" "uuid", "_friend_id" "uuid") FROM PUBLIC, "anon";

-- update_user_metadata: trigger function, never called directly. Privileges
-- are checked when the trigger is created, not when it fires.
REVOKE EXECUTE ON FUNCTION "public"."update_user_metadata"() FROM PUBLIC, "anon", "authenticated";


-- Verification:
-- SELECT p.proname, p.prosecdef, p.proconfig
--   FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
--  WHERE n.nspname = 'public'
--    AND p.proname IN ('delete_user_account', 'is_friend_or_friend_of_friend',
--                      'update_user_metadata');
--   -> proconfig = {search_path=""} for the three functions
--
-- SELECT routine_name, grantee FROM information_schema.routine_privileges
--  WHERE routine_schema = 'public'
--    AND routine_name IN ('delete_user_account', 'is_friend_or_friend_of_friend',
--                         'update_user_metadata')
--  ORDER BY 1, 2;
--   -> no anon / PUBLIC grantee; update_user_metadata only for postgres and service_role
