-- CPVC category rename, Furniture Fitting cover image and brand-logo safety net (2026-10-05).
--
-- RUN THIS AFTER 20261001000000_merge_furniture_fitting_and_clean_brands.sql,
-- and after the website update that goes with it is live (the homepage label and
-- the old-link redirects ship with that update; the cover image file is already
-- on the site at /images/categories/furniture-fitting.jpg).
--
-- 1. The CPVC category is renamed "CPVC and UPVC Fittings" (client request).
--    The two rows involved are Apollo's "CPVC Fittings & Pipes" (the one with
--    products, shown on the homepage) and Astral's "CPVC Pipes & Fittings" (no
--    products yet). Slugs are NOT changed, so every existing link keeps working:
--    apollo-cpvc-fittings-pipes, astral-cpvc-pipes-fittings. The separate
--    "uPVC & SWR Pipes" category is not touched.
-- 2. Apollo's CPVC products carry the old category name as plain text in their
--    specification table ("Category: CPVC Fittings & Pipes"); that text is
--    updated to the new name so the product page does not show the old label.
-- 3. The Furniture Fitting category gets its cover photo through the normal
--    category image field (only if no image is set yet - an image you uploaded
--    in Admin is never replaced).
-- 4. Safety net for the three white-on-transparent brand logos (Ebco, Rockstar,
--    Astral) that 20261001000000 already replaces: if one of them still points
--    at the old invisible file it is switched to the dark version shipped with
--    the site; a logo you uploaded yourself is never touched. All other brand
--    logos were checked (they load and are clearly visible on a white card).
--
-- Safe to re-run: every statement only changes rows that still need it, and
-- nothing here depends on whether 20261001000000 has been run. No product,
-- price, photo or order is touched.

BEGIN;

-- 1. Category rename (name only, slugs unchanged).
UPDATE public.categories
SET name = 'CPVC and UPVC Fittings'
WHERE (slug IN ('apollo-cpvc-fittings-pipes', 'astral-cpvc-pipes-fittings')
       OR name IN ('CPVC Fittings & Pipes', 'CPVC Pipes & Fittings'))
  AND name IS DISTINCT FROM 'CPVC and UPVC Fittings';

-- 2. Old category name inside product specs.
UPDATE public.products
SET specs = jsonb_set(specs, '{Category}', to_jsonb('CPVC and UPVC Fittings'::text))
WHERE jsonb_typeof(specs) = 'object'
  AND specs->>'Category' IN ('CPVC Fittings & Pipes', 'CPVC Pipes & Fittings');

-- 3. Furniture Fitting cover image (only where none is set).
UPDATE public.categories
SET image_url = '/images/categories/furniture-fitting.jpg'
WHERE slug = 'furniture-fitting'
  AND (image_url IS NULL OR btrim(image_url) = '');

-- 4. Replace only the known invisible logo files.
UPDATE public.brands
SET logo_url = '/images/brands/ebco-logo.png'
WHERE slug = 'ebco' AND logo_url LIKE '%/brands/eabd247b-3fa0-4937-8a37-c471031179e4.avif';

UPDATE public.brands
SET logo_url = '/images/brands/rockstar-logo.png'
WHERE slug = 'rockstar' AND logo_url LIKE '%/brands/f2b50913-2d73-47ad-9e99-edc12b0fecf8.webp';

UPDATE public.brands
SET logo_url = '/images/brands/astral-logo.png'
WHERE slug = 'astral' AND logo_url LIKE '%/brands/b6540c58-f57b-4c9a-a65a-e2b5f32562be.png';

COMMIT;

-- Result check. Expect:
--   category rows: Apollo > "CPVC and UPVC Fittings" (about 45 products) and
--     Astral > "CPVC and UPVC Fittings" (0 products), both with their original
--     slugs; "Furniture Fitting" showing image=/images/categories/furniture-fitting.jpg
--     (its product count is the whole subtree: 25 before 20261001000000, about 66 after);
--   leftovers: 0 categories and 0 products still using an old CPVC label;
--   brand rows: Ebco, Rockstar and Astral on /images/brands/*-logo.png (once
--     20261001000000 or this script has run); every other brand keeps its own logo.
WITH RECURSIVE subtree AS (
  SELECT id, id AS root_id
  FROM public.categories
  WHERE slug IN ('furniture-fitting', 'apollo-cpvc-fittings-pipes', 'astral-cpvc-pipes-fittings')
  UNION ALL
  SELECT c.id, s.root_id
  FROM public.categories c
  JOIN subtree s ON c.parent_id = s.id
)
SELECT 'category' AS kind,
       coalesce(parent.name || ' > ', '') || c.name || '  [' || c.slug || ']' AS item,
       'image=' || coalesce(c.image_url, 'none') AS detail,
       count(DISTINCT p.id) AS products
FROM public.categories c
LEFT JOIN public.categories parent ON parent.id = c.parent_id
JOIN subtree s ON s.root_id = c.id
LEFT JOIN public.products p ON p.category_id = s.id
GROUP BY parent.name, c.name, c.slug, c.image_url
UNION ALL
SELECT 'leftover old CPVC label', 'categories', '', count(*)
FROM public.categories
WHERE name IN ('CPVC Fittings & Pipes', 'CPVC Pipes & Fittings')
UNION ALL
SELECT 'leftover old CPVC label', 'product specs', '', count(*)
FROM public.products
WHERE jsonb_typeof(specs) = 'object'
  AND specs->>'Category' IN ('CPVC Fittings & Pipes', 'CPVC Pipes & Fittings')
UNION ALL
SELECT 'brand', b.name, coalesce(b.logo_url, 'no logo'), count(p.id)
FROM public.brands b
LEFT JOIN public.products p ON p.brand_id = b.id
GROUP BY b.name, b.logo_url
ORDER BY 1, 2;
