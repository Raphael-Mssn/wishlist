-- Migration: add quantity and updated_at to user_completed_wishs
-- Date: 2026-05-17

-- 1. Add columns (idempotent with IF NOT EXISTS)
ALTER TABLE public.user_completed_wishs
  ADD COLUMN IF NOT EXISTS quantity bigint NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS updated_at timestamp with time zone DEFAULT now() NOT NULL;

-- 2. Function for auto-updating updated_at on row update
CREATE OR REPLACE FUNCTION public.update_user_completed_wishs_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- 3. Trigger (drop first to allow re-running)
DROP TRIGGER IF EXISTS set_user_completed_wishs_updated_at ON public.user_completed_wishs;

CREATE TRIGGER set_user_completed_wishs_updated_at
  BEFORE UPDATE ON public.user_completed_wishs
  FOR EACH ROW
  EXECUTE FUNCTION public.update_user_completed_wishs_updated_at();
