-- fix_brand_names_2026_09.sql
-- Purpose: make the first word of every product name the brand, per owner rule.
-- 1. Prefix "Ebco " onto all hinge products (they previously had no brand).
-- 2. Fix a "Rocckstar" -> "Rockstar" typo on one 0.8mm Sunmica sheet.
--
-- Both statements are idempotent (safe to re-run):
--   * hinges guarded by NOT ILIKE 'Ebco%'
--   * typo fix is a replace() that finds nothing on a second run.
--
-- Run this in the Supabase SQL editor.

-- 1. Ebco hinges: brand-prefix (28 products under Ebco -> Hinges)
UPDATE public.products
SET name = 'Ebco ' || name
WHERE category_id = '0919da28-3205-471b-aa7d-608cf4efe701'
  AND is_active = true
  AND name NOT ILIKE 'Ebco%';

-- 2. Typo: "Rocckstar" -> "Rockstar" (one 0.8mm Sunmica sheet)
UPDATE public.products
SET name = replace(name, 'Rocckstar', 'Rockstar')
WHERE name ILIKE '%Rocckstar%';

-- Verify (optional): after running, these should each return 0 rows.
-- SELECT id, name FROM public.products
--   WHERE category_id = '0919da28-3205-471b-aa7d-608cf4efe701'
--     AND is_active = true AND name NOT ILIKE 'Ebco%';
-- SELECT id, name FROM public.products WHERE name ILIKE '%Rocckstar%';