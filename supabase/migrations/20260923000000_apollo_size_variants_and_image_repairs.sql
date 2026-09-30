-- Preserve a complete before-image for every Apollo row this migration will
-- change. The companion rollback script restores these rows by product ID.
CREATE TABLE public.apollo_product_snapshot_20260923 (
  product_id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC NOT NULL,
  image_url TEXT,
  images TEXT[],
  variants JSONB,
  is_active BOOLEAN NOT NULL,
  category_id UUID,
  stock INTEGER,
  specs JSONB,
  saved_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.apollo_product_snapshot_20260923 ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.apollo_product_snapshot_20260923 FROM PUBLIC, anon, authenticated;

ALTER TABLE public.order_items
  ADD COLUMN IF NOT EXISTS variant_label TEXT;

-- Plan only these image corrections. The path check requires an actual male
-- adaptor image, avoiding already-correct female images whose filenames also
-- contain the word "male" as part of "female".
CREATE TEMP TABLE apollo_image_repair_plan ON COMMIT DROP AS
SELECT
  p.id,
  CASE
    WHEN p.name ILIKE 'Apollo SWR Pipe Clamp %'
      THEN '/images/apollo/apollo-pipe-clamp-swr-fitting-self-fit-upvc-pipe-fittings.webp'
    WHEN p.name ILIKE 'Apollo SWR Self-Fit Cleaning Pipe (With Door)%'
      THEN '/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg'
    WHEN p.name ILIKE 'Apollo SWR Ringfit Cleaning Pipe (With Door)%'
      THEN '/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-with-ring-upvc-pipe-fittings.jpg'
    WHEN p.name ILIKE 'Apollo SWR Self-Fit Nahani Trap (Without Jali)%'
      THEN '/images/apollo/apollo-nahani-trap-without-jali-swr-fitting-self-fit-upvc-pipe-fittings.jpg'
    WHEN p.name ILIKE 'Apollo SWR Nahani Trap W/s (One Pc)%'
      THEN '/images/apollo/apollo-nahani-trap-ws-one-pc-swr-fitting-self-fit-upvc-pipe-fittings.jpg'
    WHEN p.name ILIKE 'Apollo SWR Ringfit Double Tee %'
      THEN '/images/apollo/apollo-double-tee-swr-fitting-with-ring-upvc-pipe-fittings.png'
    WHEN p.name ILIKE '%uPVC%Female Adaptor Brass Threaded%'
      THEN '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'
    WHEN p.name ILIKE '%uPVC%Female Elbow Brass Threaded%'
      THEN '/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg'
    WHEN p.name ILIKE '%uPVC%Female Tee Brass Threaded%'
      THEN '/images/apollo/upvc/apollo upvc female tee brass threaded.jpg'
    WHEN p.name ILIKE '%uPVC%Female Threaded Adaptor%PN6%'
      THEN '/images/apollo/apollo-female-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'
    WHEN p.name ILIKE '%uPVC%Female Threaded Adaptor%PN10%'
      THEN '/images/apollo/apollo-female-threaded-adptor-pn10-upvc-pipe-fittings.jpg'
    WHEN p.name ILIKE '%Female Adaptor With%Brass Inserts%'
      THEN '/images/apollo/apollo-female-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting.jpg'
    WHEN p.name ILIKE '%Reducing Female Elbow Brass Threaded%'
      THEN '/images/apollo/apollo-reducing-female-elbow-brass-threaded-sdr-cpvc-fitting.webp'
    WHEN p.name ILIKE '%Female Elbow Brass Threaded%'
      THEN '/images/apollo/apollo-female-elbow-brass-threaded-sdr-cpvc-fitting.webp'
    WHEN p.name ILIKE '%Female Adaptor Brass Threaded%'
      THEN '/images/apollo/apollo-female-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'
    ELSE '/images/apollo/apollo-female-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'
  END AS image_url
FROM public.products p
JOIN public.categories c ON c.id = p.category_id
WHERE p.is_active = true
  AND p.name ILIKE 'Apollo%'
  AND (
    c.slug LIKE 'apollo-%'
    OR c.parent_id IN (SELECT id FROM public.categories WHERE slug = 'apollo')
  )
  AND (
    (
      p.name ILIKE 'Apollo SWR Pipe Clamp %'
      AND p.image_url ILIKE '%single-tee%'
    )
    OR (
      p.name ILIKE 'Apollo SWR Self-Fit Cleaning Pipe (With Door)%'
      AND p.image_url ILIKE '%single-tee%'
    )
    OR (
      p.name ILIKE 'Apollo SWR Ringfit Cleaning Pipe (With Door)%'
      AND p.image_url ILIKE '%coupler%'
    )
    OR (
      p.name ILIKE 'Apollo SWR Self-Fit Nahani Trap (Without Jali)%'
      AND p.image_url ILIKE '%single-tee%'
    )
    OR (
      p.name ILIKE 'Apollo SWR Nahani Trap W/s (One Pc)%'
      AND p.image_url ILIKE '%single-tee%'
    )
    OR (
      p.name ILIKE 'Apollo SWR Ringfit Double Tee %'
      AND p.image_url ILIKE '%single-tee%'
    )
    OR (
      p.name ILIKE '%Female%'
      AND p.image_url ILIKE '%/apollo-male-adaptor%'
    )
  );

-- Match only size/length changes. Product terms (including pressure or
-- schedule, material, connection style, and fitting type) remain in the base
-- name. Dimension count keeps reducing fittings separate from equal fittings.
CREATE TEMP TABLE apollo_size_variant_rows ON COMMIT DROP AS
WITH candidates AS (
  SELECT
    p.id,
    p.name,
    p.price,
    p.category_id,
    p.image_url,
    p.is_active,
    p.variants,
    p.specs,
    trim(regexp_replace(
      regexp_replace(
        regexp_replace(
          p.name,
          '[[:space:]]*\([0-9][^)]*(mm|cm)\)', '', 'gi'
        ),
        '[0-9]+([-./][0-9]+)*[[:space:]]*["″”]([[:space:]]*[x×][[:space:]]*[0-9]+([-./][0-9]+)*[[:space:]]*["″”])?',
        '', 'gi'
      ),
      '[[:space:]]*[-–—][[:space:]]*[0-9]+([.][0-9]+)?[[:space:]]*mtr',
      '', 'gi'
    )) AS base_name,
    CASE
      WHEN coalesce(p.specs->>'Size (mm)', '') ~* '[x×]'
        OR p.name ~* '[0-9]+([-./][0-9]+)*[[:space:]]*["″”][[:space:]]*[x×][[:space:]]*[0-9]'
        THEN 2
      ELSE 1
    END AS dimension_count,
    coalesce(
      nullif(trim(p.specs->>'Size (inch)'), ''),
      nullif(trim((regexp_match(
        p.name,
        '([0-9]+([-./][0-9]+)*[[:space:]]*["″”].*)$'
      ))[1]), ''),
      nullif(trim((regexp_match(
        p.name,
        '(\([0-9]+[^)]*(mm|cm)\).*)$'
      ))[1]), ''),
      nullif(trim(p.specs->>'Size (mm)'), '')
    ) AS variant_label
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  WHERE p.is_active = true
    AND p.name ILIKE 'Apollo %'
    AND (
      c.slug LIKE 'apollo-%'
      OR c.parent_id IN (SELECT id FROM public.categories WHERE slug = 'apollo')
    )
    AND coalesce(p.variants, '[]'::jsonb) IN ('[]'::jsonb, 'null'::jsonb)
), normalized AS (
  SELECT
    *,
    lower(trim(regexp_replace(base_name, '[[:space:]]+', ' ', 'g'))) AS family_key
  FROM candidates
  WHERE variant_label IS NOT NULL
), eligible_families AS (
  SELECT category_id, family_key, dimension_count
  FROM normalized
  GROUP BY category_id, family_key, dimension_count
  HAVING count(*) > 1
    AND count(*) = count(DISTINCT variant_label)
)
SELECT
  n.id,
  n.name,
  n.price,
  n.category_id,
  n.image_url,
  n.base_name,
  n.family_key,
  n.dimension_count,
  n.variant_label,
  first_value(n.id) OVER (
    PARTITION BY n.category_id, n.family_key, n.dimension_count
    ORDER BY n.price ASC, n.id ASC
  ) AS master_id
FROM normalized n
JOIN eligible_families f USING (category_id, family_key, dimension_count);

-- Save exactly the rows selected by the two plans before changing any product.
INSERT INTO public.apollo_product_snapshot_20260923 (
  product_id, name, price, image_url, images, variants, is_active,
  category_id, stock, specs
)
SELECT
  p.id, p.name, p.price, p.image_url, p.images, p.variants, p.is_active,
  p.category_id, p.stock, p.specs
FROM public.products p
WHERE p.id IN (SELECT id FROM apollo_image_repair_plan)
   OR p.id IN (SELECT id FROM apollo_size_variant_rows)
ON CONFLICT (product_id) DO NOTHING;

UPDATE public.products p
SET image_url = plan.image_url,
    images = ARRAY[plan.image_url]
FROM apollo_image_repair_plan plan
WHERE p.id = plan.id;

-- Use the corrected photo on the corresponding selectable option as well.
UPDATE apollo_size_variant_rows r
SET image_url = p.image_url
FROM public.products p
WHERE p.id = r.id;

WITH option_lists AS (
  SELECT
    r.master_id,
    min(r.base_name) AS base_name,
    min(r.price) AS base_price,
    (array_agg(r.image_url ORDER BY (r.id = r.master_id) DESC, r.variant_label))[1] AS base_image,
    jsonb_agg(
      jsonb_build_object(
        'label', r.variant_label,
        'price', r.price,
        'image', r.image_url,
        'is_default', r.id = r.master_id,
        'type', 'size'
      ) ORDER BY r.variant_label
    ) AS variants
  FROM apollo_size_variant_rows r
  GROUP BY r.master_id
)
UPDATE public.products p
SET name = options.base_name,
    price = options.base_price,
    image_url = options.base_image,
    images = CASE
      WHEN options.base_image IS NULL THEN p.images
      ELSE ARRAY[options.base_image]
    END,
    variants = options.variants
FROM option_lists options
WHERE p.id = options.master_id;

-- Keep the old product IDs and before-images available for order history and
-- rollback, but remove duplicate cards from active storefront queries.
UPDATE public.products p
SET is_active = false
FROM apollo_size_variant_rows r
WHERE p.id = r.id
  AND r.id <> r.master_id;
