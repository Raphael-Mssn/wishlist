CREATE OR REPLACE FUNCTION public.nb_wishs_by_user(user_id uuid)
RETURNS bigint
LANGUAGE plpgsql
AS $$
DECLARE
  wish_count bigint;
BEGIN
  SELECT COUNT(*)
  INTO wish_count
  FROM public.wishlists
  JOIN public.wishs ON wishlists.id = wishs.wishlist_id
  WHERE wishlists.id_owner = user_id
    AND wishlists.deleted_at IS NULL;

  RETURN wish_count;
END;
$$;
