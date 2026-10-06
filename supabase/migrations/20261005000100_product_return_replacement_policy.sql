-- Per-product Return Policy and Replacement Policy (2026-10-05).
--
-- Every product can now carry its own return and replacement wording, edited in
-- Admin and shown in the "Returns & Replacement" section of the product page.
--
--   return_policy       plain text; NULL = show the store-wide return wording
--   replacement_policy  plain text; NULL = show a short note pointing to the
--                       Returns page
--
-- Both are optional and plain text only (no HTML). The site renders them as text
-- with line breaks kept, so no sanitising is needed. Existing products get NULL
-- and look exactly as they do today (store-wide wording, in the new section).
--
-- A length check (4000 characters, the same limit as the Admin form) rejects
-- oversized values even if they are sent straight to the API instead of through
-- Admin. It is added NOT VALID like the other catalog checks: it applies to every
-- new insert and edit, and there is nothing older to check because the columns
-- are new.
--
-- Nothing else needs to change: the homepage views list their columns explicitly
-- and the product triggers only watch name, brand and image columns. The existing
-- row-level policies already cover the new columns (public read of active
-- products, admin-only writes).
--
-- Safe to run more than once, and safe to run before or after the website update
-- that goes with it: the product page and Admin cope with the columns being
-- missing. Run it BEFORE using the new fields in Admin, because Admin cannot save
-- policy text until the columns exist.

BEGIN;

ALTER TABLE public.products
  ADD COLUMN IF NOT EXISTS return_policy TEXT,
  ADD COLUMN IF NOT EXISTS replacement_policy TEXT;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.products'::regclass AND conname = 'products_return_policy_length'
  ) THEN
    ALTER TABLE public.products ADD CONSTRAINT products_return_policy_length
      CHECK (return_policy IS NULL OR char_length(return_policy) <= 4000) NOT VALID;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.products'::regclass AND conname = 'products_replacement_policy_length'
  ) THEN
    ALTER TABLE public.products ADD CONSTRAINT products_replacement_policy_length
      CHECK (replacement_policy IS NULL OR char_length(replacement_policy) <= 4000) NOT VALID;
  END IF;
END $$;

COMMENT ON COLUMN public.products.return_policy IS
  'Optional plain-text return policy for this product (max 4000 chars). NULL = store-wide wording is shown.';
COMMENT ON COLUMN public.products.replacement_policy IS
  'Optional plain-text replacement policy for this product (max 4000 chars). NULL = a note pointing to the Returns page is shown.';

COMMIT;

-- Make the API pick up the new columns immediately.
NOTIFY pgrst, 'reload schema';
