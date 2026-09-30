-- Follow-up for Apollo size labels that use Unicode fraction glyphs and
-- catalog image mismatches identified during the preview review.
CREATE TEMP TABLE apollo_followup_image_plan ON COMMIT DROP AS
SELECT p.id,
  CASE
    WHEN p.name ILIKE 'Apollo CPVC Female Adaptor With Hexaganol Brass Inserts%'
      THEN '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR WITH HEXAGANOL BRASS INSERTS.jpg'
    WHEN p.name ILIKE 'Apollo CPVC Male Adaptor With Hexaganol Brass Inserts%'
      THEN '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR WITH HEXAGANOL BRASS INSERTS.webp'
    WHEN p.name ILIKE 'Apollo CPVC-X Female Tee Brass Threaded%'
      THEN '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'
    WHEN p.name ILIKE 'Apollo uPVC SCH 80 Female Adaptor with Hexaganol Brass Inserts%'
      THEN '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'
    WHEN p.name ILIKE 'Apollo CPVC Tank Connector-Pipe-Fitment%'
      THEN '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR-PIPE-FITMENT.jpg'
  END AS image_url
FROM public.products p
JOIN public.categories c ON c.id = p.category_id
WHERE p.is_active = true
  AND p.name ILIKE 'Apollo%'
  AND (c.slug LIKE 'apollo-%' OR c.parent_id IN (SELECT id FROM public.categories WHERE slug = 'apollo'))
  AND (
    p.name ILIKE 'Apollo CPVC Female Adaptor With Hexaganol Brass Inserts%'
    OR p.name ILIKE 'Apollo CPVC Male Adaptor With Hexaganol Brass Inserts%'
    OR p.name ILIKE 'Apollo CPVC-X Female Tee Brass Threaded%'
    OR p.name ILIKE 'Apollo uPVC SCH 80 Female Adaptor with Hexaganol Brass Inserts%'
    OR p.name ILIKE 'Apollo CPVC Tank Connector-Pipe-Fitment%'
  );

-- Normalize Unicode fractions for dimension matching while retaining the
-- product's other terms (material, pressure class, fitting type, etc.).
CREATE TEMP TABLE apollo_followup_variant_rows ON COMMIT DROP AS
WITH candidates AS (
  SELECT
    p.id, p.name, p.price, p.category_id, p.image_url, p.is_active,
    p.variants, p.specs,
    replace(replace(replace(replace(replace(replace(replace(
      regexp_replace(p.name, '([0-9])([½¼¾⅛⅜⅝⅞])', '\1-\2', 'g'),
      '½', '1/2'), '¼', '1/4'), '¾', '3/4'), '⅛', '1/8'),
      '⅜', '3/8'), '⅝', '5/8'), '⅞', '7/8') AS normalized_name
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  WHERE p.is_active = true
    AND p.name ILIKE 'Apollo %'
    AND (c.slug LIKE 'apollo-%' OR c.parent_id IN (SELECT id FROM public.categories WHERE slug = 'apollo'))
    AND coalesce(p.variants, '[]'::jsonb) IN ('[]'::jsonb, 'null'::jsonb)
), normalized AS (
  SELECT
    *,
    lower(trim(regexp_replace(
      regexp_replace(
        regexp_replace(
          regexp_replace(normalized_name, '[[:space:]]*\([0-9][^)]*(mm|cm)\)', '', 'gi'),
          '[0-9]+([-./][0-9]+)*[[:space:]]*["″”]([[:space:]]*[x×][[:space:]]*[0-9]+([-./][0-9]+)*[[:space:]]*["″”])?', '', 'gi'
        ),
        '[[:space:]]*[-–—][[:space:]]*[0-9]+([.][0-9]+)?[[:space:]]*mtr', '', 'gi'
      ),
      '[[:space:]]+', ' ', 'g'
    ))) AS family_key,
    trim(regexp_replace(
      regexp_replace(
        regexp_replace(normalized_name, '[[:space:]]*\([0-9][^)]*(mm|cm)\)', '', 'gi'),
        '[0-9]+([-./][0-9]+)*[[:space:]]*["″”]([[:space:]]*[x×][[:space:]]*[0-9]+([-./][0-9]+)*[[:space:]]*["″”])?', '', 'gi'
      ),
      '[[:space:]]*[-–—][[:space:]]*[0-9]+([.][0-9]+)?[[:space:]]*mtr', '', 'gi'
    )) AS base_name,
    CASE
      WHEN coalesce(specs->>'Size (mm)', '') ~* '[x×]'
        OR normalized_name ~* '[0-9]+([-./][0-9]+)*[[:space:]]*["″”][[:space:]]*[x×][[:space:]]*[0-9]'
        THEN 2 ELSE 1
    END AS dimension_count,
    coalesce(
      nullif(trim(specs->>'Size (inch)'), ''),
      nullif(trim((regexp_match(normalized_name, '([0-9]+([-./][0-9]+)*[[:space:]]*["″”].*)$'))[1]), ''),
      nullif(trim((regexp_match(normalized_name, '(\([0-9]+[^)]*(mm|cm)\).*)$'))[1]), ''),
      nullif(trim(specs->>'Size (mm)'), '')
    ) AS variant_label
  FROM candidates
), eligible_families AS (
  SELECT category_id, family_key, dimension_count
  FROM normalized
  WHERE variant_label IS NOT NULL
  GROUP BY category_id, family_key, dimension_count
  HAVING count(*) > 1 AND count(*) = count(DISTINCT variant_label)
)
SELECT n.id, n.name, n.price, n.category_id, n.image_url, n.base_name,
       n.family_key, n.dimension_count, n.variant_label,
       first_value(n.id) OVER (
         PARTITION BY n.category_id, n.family_key, n.dimension_count
         ORDER BY n.price ASC, n.id ASC
       ) AS master_id
FROM normalized n
JOIN eligible_families f USING (category_id, family_key, dimension_count);

-- Preserve original values for follow-up image and variant changes. Existing
-- snapshot entries remain the earliest before-image for rollback.
INSERT INTO public.apollo_product_snapshot_20260923 (
  product_id, name, price, image_url, images, variants, is_active,
  category_id, stock, specs
)
SELECT p.id, p.name, p.price, p.image_url, p.images, p.variants, p.is_active,
       p.category_id, p.stock, p.specs
FROM public.products p
WHERE p.id IN (SELECT id FROM apollo_followup_image_plan)
   OR p.id IN (SELECT id FROM apollo_followup_variant_rows)
ON CONFLICT (product_id) DO NOTHING;

UPDATE public.products p
SET image_url = plan.image_url,
    images = ARRAY[plan.image_url],
    variants = CASE
      WHEN jsonb_typeof(p.variants) = 'array' AND jsonb_array_length(p.variants) > 0 THEN (
        SELECT jsonb_agg(jsonb_set(v, '{image}', to_jsonb(plan.image_url), true) ORDER BY ordinality)
        FROM jsonb_array_elements(p.variants) WITH ORDINALITY AS items(v, ordinality)
      )
      ELSE p.variants
    END
FROM apollo_followup_image_plan plan
WHERE p.id = plan.id;

UPDATE apollo_followup_variant_rows r
SET image_url = p.image_url
FROM public.products p
WHERE p.id = r.id;

WITH option_lists AS (
  SELECT r.master_id,
    min(r.base_name) AS base_name,
    min(r.price) AS base_price,
    (array_agg(r.image_url ORDER BY (r.id = r.master_id) DESC, r.variant_label))[1] AS base_image,
    jsonb_agg(jsonb_build_object(
      'label', r.variant_label,
      'price', r.price,
      'image', r.image_url,
      'is_default', r.id = r.master_id,
      'type', 'size'
    ) ORDER BY r.variant_label) AS variants
  FROM apollo_followup_variant_rows r
  GROUP BY r.master_id
)
UPDATE public.products p
SET name = options.base_name,
    price = options.base_price,
    image_url = options.base_image,
    images = CASE WHEN options.base_image IS NULL THEN p.images ELSE ARRAY[options.base_image] END,
    variants = options.variants
FROM option_lists options
WHERE p.id = options.master_id;

UPDATE public.products p
SET is_active = false
FROM apollo_followup_variant_rows r
WHERE p.id = r.id AND r.id <> r.master_id;
