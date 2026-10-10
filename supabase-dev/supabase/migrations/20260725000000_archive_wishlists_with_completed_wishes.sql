ALTER TABLE public.wishlists
  ADD COLUMN IF NOT EXISTS deleted_at timestamp with time zone;

CREATE OR REPLACE FUNCTION public.delete_or_archive_wishlist(
  p_wishlist_id bigint
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  has_completed_wishes boolean;
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM public.wishlists
    WHERE id = p_wishlist_id
      AND id_owner = auth.uid()
      AND deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'Wishlist not found or not owned by current user';
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM public.user_completed_wishs completed
    LEFT JOIN public.wishs wish ON wish.id = completed.wish_id
    WHERE completed.from_wishlist_id = p_wishlist_id
      OR wish.wishlist_id = p_wishlist_id
  ) INTO has_completed_wishes;

  IF NOT has_completed_wishes THEN
    DELETE FROM public.wishlists WHERE id = p_wishlist_id;
    RETURN;
  END IF;

  DELETE FROM public.wishs AS wish
  WHERE wish.wishlist_id = p_wishlist_id
    AND NOT EXISTS (
      SELECT 1
      FROM public.user_completed_wishs completed
      WHERE completed.wish_id = wish.id
    );

  UPDATE public.wishlists
  SET deleted_at = now()
  WHERE id = p_wishlist_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.restore_completed_wish(
  p_wish_id bigint,
  p_target_wishlist_id bigint
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  completed_quantity bigint;
BEGIN
  SELECT quantity
  INTO completed_quantity
  FROM public.user_completed_wishs
  WHERE user_id = auth.uid()
    AND wish_id = p_wish_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Completed wish not found for current user';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.wishlists
    WHERE id = p_target_wishlist_id
      AND id_owner = auth.uid()
      AND deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'Target wishlist not found or not owned by current user';
  END IF;

  UPDATE public.wishs AS wish
  SET wishlist_id = p_target_wishlist_id,
      quantity = completed_quantity,
      updated_by = auth.uid()
  FROM public.wishlists AS source_wishlist
  WHERE wish.id = p_wish_id
    AND source_wishlist.id = wish.wishlist_id
    AND source_wishlist.id_owner = auth.uid()
    AND source_wishlist.deleted_at IS NOT NULL;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wish is not in an archived wishlist owned by current user';
  END IF;

  DELETE FROM public.user_completed_wishs
  WHERE user_id = auth.uid()
    AND wish_id = p_wish_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.delete_or_archive_wishlist(bigint) TO authenticated;
GRANT EXECUTE ON FUNCTION public.restore_completed_wish(bigint, bigint) TO authenticated;
