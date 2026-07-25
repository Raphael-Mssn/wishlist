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
