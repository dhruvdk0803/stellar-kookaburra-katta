-- Furniture Fitting merge, brand clean-up and Rolling Shutter specs (2026-10-01).
--
-- 1. Ebco Hinges and Ebco Drawer Slides move under the Furniture Fitting
--    category the owner created: hinges join "Furniture Fitting > Hinges"
--    (next to the Dorset hinges) and drawer slides become
--    "Furniture Fitting > Drawer Slides". Only the category changes - brands,
--    prices, photos and order history are untouched.
-- 2. Thermoluxe and IRIS are Gloirio ranges, not brands. Nothing uses them any
--    more, so the two brand rows are removed (a product still tagged with one of
--    them would move to Gloirio first).
-- 3. Ebco, Rockstar and Astral logos were white-on-transparent files, invisible
--    on the white brand cards. They now point to dark versions shipped with the
--    site in public/images/brands/.
-- 4. "Dorset Rolling Shutter" had no specifications; fill in what its own
--    description already states (nothing invented).
--
-- Run it AFTER the website update that goes with it is live (the homepage card,
-- the old-link redirect and the three logo files ship with that update).
--
-- Re-running changes nothing further, except that step 3 would put the three
-- logos back if you had uploaded different ones for those brands since. If the
-- Furniture Fitting or Gloirio row is missing the script stops and changes
-- nothing.

BEGIN;

DO $$
DECLARE
  ff_id UUID;
  ff_hinges_id UUID;
  ebco_hinges_id UUID;
  ebco_slides_id UUID;
BEGIN
  SELECT id INTO ff_id FROM public.categories WHERE slug = 'furniture-fitting' AND parent_id IS NULL;
  IF ff_id IS NULL THEN
    RAISE EXCEPTION 'The "Furniture Fitting" category (slug furniture-fitting) was not found. Nothing was changed.';
  END IF;

  -- Hinges: reuse the one already under Furniture Fitting.
  SELECT id INTO ff_hinges_id FROM public.categories WHERE slug = 'hinges';
  IF ff_hinges_id IS NULL THEN
    INSERT INTO public.categories (name, slug, parent_id) VALUES ('Hinges', 'hinges', ff_id) RETURNING id INTO ff_hinges_id;
  ELSE
    UPDATE public.categories SET parent_id = ff_id WHERE id = ff_hinges_id AND parent_id IS DISTINCT FROM ff_id;
  END IF;

  SELECT id INTO ebco_hinges_id FROM public.categories WHERE slug = 'ebco-hinges';
  IF ebco_hinges_id IS NOT NULL AND ebco_hinges_id <> ff_hinges_id THEN
    UPDATE public.products SET category_id = ff_hinges_id WHERE category_id = ebco_hinges_id;
    -- Remove the old category only once nothing is left in or under it.
    DELETE FROM public.categories c
    WHERE c.id = ebco_hinges_id
      AND NOT EXISTS (SELECT 1 FROM public.products p WHERE p.category_id = c.id)
      AND NOT EXISTS (SELECT 1 FROM public.categories child WHERE child.parent_id = c.id);
  END IF;

  -- Drawer slides keep their category (and slug, so old links still work); it just moves up.
  SELECT id INTO ebco_slides_id FROM public.categories WHERE slug = 'ebco-drawer-slides';
  IF ebco_slides_id IS NOT NULL THEN
    UPDATE public.categories SET parent_id = ff_id WHERE id = ebco_slides_id AND parent_id IS DISTINCT FROM ff_id;
  END IF;
END $$;

DO $$
DECLARE
  gloirio_id UUID;
BEGIN
  SELECT id INTO gloirio_id FROM public.brands WHERE slug = 'gloirio';
  IF gloirio_id IS NULL THEN
    RAISE EXCEPTION 'The Gloirio brand (slug gloirio) was not found. Nothing was changed.';
  END IF;

  -- The product-name trigger swaps the old range prefix for "Gloirio " on any such product.
  UPDATE public.products SET brand_id = gloirio_id
  WHERE brand_id IN (SELECT id FROM public.brands WHERE slug IN ('thermoluxe', 'iris'));

  DELETE FROM public.brands WHERE slug IN ('thermoluxe', 'iris');
END $$;

UPDATE public.brands SET logo_url = '/images/brands/ebco-logo.png' WHERE slug = 'ebco';
UPDATE public.brands SET logo_url = '/images/brands/rockstar-logo.png' WHERE slug = 'rockstar';
UPDATE public.brands SET logo_url = '/images/brands/astral-logo.png' WHERE slug = 'astral';

-- Only fills a product that still has no specs, so anything the owner entered is kept.
UPDATE public.products
SET specs = jsonb_build_object(
      'Brand', 'Dorset',
      'Category', 'Rolling Shutter',
      'Product Type', 'Rolling shutter (vertical roll-up)',
      'Available Sizes', '450x1320mm, 600x1320mm, 900x1320mm',
      'Application Areas', 'Modular kitchens, overhead cabinets, crockery units and storage units',
      'Operation', 'Smooth vertical rolling - the shutter moves upward, so no front-opening space is needed'
    )
WHERE id = '472f5761-6048-4a61-870c-965a226d40e9'
  AND (specs IS NULL OR specs = '{}'::jsonb);

COMMIT;

-- Result check. Expect Furniture Fitting > Hinges 39, Drawer Slides 14, Lift Up 6,
-- Sliding Channel 4; brands without Thermoluxe / IRIS; Ebco, Rockstar and Astral
-- showing the new /images/brands/*-logo.png files.
SELECT 'category' AS kind,
       coalesce(parent.name || ' > ', '') || c.name AS item,
       count(p.id) AS products
FROM public.categories c
LEFT JOIN public.categories parent ON parent.id = c.parent_id
LEFT JOIN public.products p ON p.category_id = c.id
WHERE c.slug = 'furniture-fitting'
   OR c.parent_id = (SELECT id FROM public.categories WHERE slug = 'furniture-fitting')
GROUP BY parent.name, c.name
UNION ALL
SELECT 'brand', b.name || '  [' || coalesce(b.logo_url, 'no logo') || ']', count(p.id)
FROM public.brands b
LEFT JOIN public.products p ON p.brand_id = b.id
GROUP BY b.name, b.logo_url
ORDER BY 1, 2;
