-- Merge the uPVC / SWR category into the CPVC one: a single "CPVC & UPVC Fittings"
-- category (2026-10-07). Run AFTER 20261005000000.
--
-- The client wants CPVC and uPVC/SWR products in one place. The stocked CPVC row
-- (slug apollo-cpvc-fittings-pipes, under Apollo so the Plumbing page keeps working)
-- becomes the single category, the 41 uPVC products move into it, and the empty
-- uPVC row (slug apollo-upvc-pipes-fittings) is removed. Old links to the removed slug
-- are redirected by the website (LEGACY_CATEGORY_ALIASES). Only the category changes;
-- brands, prices, photos and order history are untouched.
--
-- Safe to re-run. If the CPVC row is missing, the script stops and changes nothing.

BEGIN;

DO $$
DECLARE
  cpvc_id UUID;
  upvc_id UUID;
  bad_rows INTEGER;
BEGIN
  SELECT id INTO cpvc_id FROM public.categories WHERE slug = 'apollo-cpvc-fittings-pipes';
  IF cpvc_id IS NULL THEN
    RAISE EXCEPTION 'The CPVC category (slug apollo-cpvc-fittings-pipes) was not found. Nothing was changed.';
  END IF;

  SELECT id INTO upvc_id FROM public.categories WHERE slug = 'apollo-upvc-pipes-fittings';

  -- Every product UPDATE re-checks the price/stock constraints; refuse cleanly if a row would trip them.
  SELECT count(*) INTO bad_rows
  FROM public.products
  WHERE category_id IN (cpvc_id, coalesce(upvc_id, cpvc_id))
    AND (price IS NULL OR price <= 0 OR stock < 0);
  IF bad_rows > 0 THEN
    RAISE EXCEPTION '% product(s) in these categories have a zero/negative price or stock; fix them first. Nothing was changed.', bad_rows;
  END IF;

  IF upvc_id IS NOT NULL AND upvc_id <> cpvc_id THEN
    UPDATE public.products SET category_id = cpvc_id WHERE category_id = upvc_id;
    -- Remove the old category only once nothing is left in or under it.
    DELETE FROM public.categories c
    WHERE c.id = upvc_id
      AND NOT EXISTS (SELECT 1 FROM public.products p WHERE p.category_id = c.id)
      AND NOT EXISTS (SELECT 1 FROM public.categories child WHERE child.parent_id = c.id);
  END IF;

  UPDATE public.categories
  SET name = 'CPVC & UPVC Fittings'
  WHERE slug IN ('apollo-cpvc-fittings-pipes', 'astral-cpvc-pipes-fittings')
    AND name IS DISTINCT FROM 'CPVC & UPVC Fittings';

  -- The product page's "Category" spec stores the category name as text; keep it in step.
  UPDATE public.products
  SET specs = jsonb_set(specs, '{Category}', to_jsonb('CPVC & UPVC Fittings'::text))
  WHERE category_id = cpvc_id
    AND jsonb_typeof(specs) = 'object'
    AND specs ? 'Category'
    AND specs->>'Category' IS DISTINCT FROM 'CPVC & UPVC Fittings';
END $$;

COMMIT;

-- Result check. Expect one row: "CPVC & UPVC Fittings" with 86 products (45 CPVC + 41 uPVC),
-- and no row with slug apollo-upvc-pipes-fittings.
SELECT c.slug, c.name, count(p.id) AS products
FROM public.categories c
LEFT JOIN public.products p ON p.category_id = c.id
WHERE c.slug IN ('apollo-cpvc-fittings-pipes', 'apollo-upvc-pipes-fittings', 'astral-cpvc-pipes-fittings')
GROUP BY c.slug, c.name
ORDER BY c.slug;
