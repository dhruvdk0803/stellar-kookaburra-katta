-- Consolidate duplicate Apollo option groups caused by mixed single-size and
-- equal-end size spellings. Keep one option per physical size and retain the
-- lowest current catalog price when duplicate source rows describe that size.
CREATE TEMP TABLE apollo_duplicate_family_sources ON COMMIT DROP AS
WITH source_products AS (
  SELECT p.id, p.name, p.price, p.image_url, p.images, p.variants, p.specs,
         p.category_id,
         CASE
           WHEN p.name ILIKE 'Apollo CPVC Female Adaptor With Hexaganol Brass Inserts%'
             THEN 'Apollo CPVC Female Adaptor With Hexaganol Brass Inserts'
           WHEN p.name ILIKE 'Apollo CPVC Male Adaptor With Hexaganol Brass Inserts%'
             THEN 'Apollo CPVC Male Adaptor With Hexaganol Brass Inserts'
           WHEN p.name ILIKE 'Apollo CPVC Reducing Bush%'
             THEN 'Apollo CPVC Reducing Bush'
           WHEN p.name ILIKE 'Apollo CPVC-X Female Adaptor With Hexaganol Brass Inserts%'
             THEN 'Apollo CPVC-X Female Adaptor With Hexaganol Brass Inserts'
         END AS family_name,
         CASE
           WHEN p.name ILIKE 'Apollo CPVC Female Adaptor With Hexaganol Brass Inserts%'
             THEN '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR WITH HEXAGANOL BRASS INSERTS.jpg'
           WHEN p.name ILIKE 'Apollo CPVC Male Adaptor With Hexaganol Brass Inserts%'
             THEN '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR WITH HEXAGANOL BRASS INSERTS.webp'
           WHEN p.name ILIKE 'Apollo CPVC Reducing Bush%'
             THEN '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'
           WHEN p.name ILIKE 'Apollo CPVC-X Female Adaptor With Hexaganol Brass Inserts%'
             THEN '/images/apollo/apollo-female-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting.jpg'
         END AS family_image
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  WHERE p.is_active = true
    AND (c.slug LIKE 'apollo-%' OR c.parent_id IN (SELECT id FROM public.categories WHERE slug = 'apollo'))
    AND (
      p.name ILIKE 'Apollo CPVC Female Adaptor With Hexaganol Brass Inserts%'
      OR p.name ILIKE 'Apollo CPVC Male Adaptor With Hexaganol Brass Inserts%'
      OR p.name ILIKE 'Apollo CPVC Reducing Bush%'
      OR p.name ILIKE 'Apollo CPVC-X Female Adaptor With Hexaganol Brass Inserts%'
    )
), raw_options AS (
  SELECT
    s.id AS source_id,
    s.category_id,
    s.family_name,
    s.price AS source_price,
    s.family_image,
    coalesce(
      nullif(trim(v->>'label'), ''),
      nullif(trim(s.specs->>'Size (inch)'), ''),
      nullif(trim((regexp_match(
        replace(replace(replace(replace(replace(replace(replace(
          regexp_replace(s.name, '([0-9])([½¼¾⅛⅜⅝⅞])', '\1-\2', 'g'),
          '½', '1/2'), '¼', '1/4'), '¾', '3/4'), '⅛', '1/8'), '⅜', '3/8'), '⅝', '5/8'), '⅞', '7/8'),
        '([0-9]+([-./][0-9]+)*[[:space:]]*["″”]([[:space:]]*[x×][[:space:]]*[0-9]+([-./][0-9]+)*[[:space:]]*["″”])?)'
      ))[1]), ''),
      nullif(trim(s.specs->>'Size (mm)'), '')
    ) AS raw_label,
    coalesce(nullif(v->>'price', '')::numeric, s.price) AS option_price
  FROM source_products s
  LEFT JOIN LATERAL jsonb_array_elements(
    CASE WHEN jsonb_typeof(s.variants) = 'array' THEN s.variants ELSE '[]'::jsonb END
  ) v ON true
), canonical_options AS (
  SELECT
    source_id, category_id, family_name, family_image, option_price, source_price,
    trim(regexp_replace(
      regexp_replace(
        replace(replace(replace(replace(replace(replace(replace(
          regexp_replace(raw_label, '([0-9])([½¼¾⅛⅜⅝⅞])', '\1-\2', 'g'),
          '½', '1/2'), '¼', '1/4'), '¾', '3/4'), '⅛', '1/8'), '⅜', '3/8'), '⅝', '5/8'), '⅞', '7/8'),
        '[[:space:]]*\([0-9][^)]*(mm|cm)\)', '', 'gi'
      ),
      '[[:space:]]*[x×][[:space:]]*', ' × ', 'g'
    )) AS label
  FROM raw_options
  WHERE raw_label IS NOT NULL
), simplified_options AS (
  SELECT
    source_id, category_id, family_name, family_image, option_price, source_price,
    trim(regexp_replace(label,
      '^([0-9]+([-./][0-9]+)*)[[:space:]]*["″”][[:space:]]*×[[:space:]]*\1[[:space:]]*["″”]$',
      '\1"', 'i'
    )) AS label
  FROM canonical_options
), unique_options AS (
  SELECT DISTINCT ON (category_id, family_name, lower(label))
    source_id, category_id, family_name, family_image, option_price, source_price, label
  FROM simplified_options
  ORDER BY category_id, family_name, lower(label), option_price ASC, source_id ASC
), family_masters AS (
  SELECT DISTINCT ON (category_id, family_name)
    category_id, family_name, id AS master_id,
    min(price) OVER (PARTITION BY category_id, family_name) AS base_price
  FROM source_products
  ORDER BY category_id, family_name, price ASC, id ASC
)
SELECT o.source_id, o.category_id, o.family_name, o.family_image,
       o.label, o.option_price,
       m.master_id, m.base_price,
       row_number() OVER (
         PARTITION BY o.category_id, o.family_name
         ORDER BY o.option_price, lower(o.label)
       ) AS default_position
FROM unique_options o
JOIN family_masters m USING (category_id, family_name);

INSERT INTO public.apollo_product_snapshot_20260923 (
  product_id, name, price, image_url, images, variants, is_active,
  category_id, stock, specs
)
SELECT p.id, p.name, p.price, p.image_url, p.images, p.variants, p.is_active,
       p.category_id, p.stock, p.specs
FROM public.products p
WHERE p.id IN (SELECT DISTINCT source_id FROM apollo_duplicate_family_sources)
ON CONFLICT (product_id) DO NOTHING;

WITH option_lists AS (
  SELECT category_id, family_name, master_id, min(base_price) AS base_price,
         min(family_image) AS family_image,
         jsonb_agg(jsonb_build_object(
           'label', label,
           'price', option_price,
           'image', family_image,
           'is_default', default_position = 1,
           'type', 'size'
         ) ORDER BY label) AS variants
  FROM apollo_duplicate_family_sources
  GROUP BY category_id, family_name, master_id
)
UPDATE public.products p
SET name = options.family_name,
    price = options.base_price,
    image_url = options.family_image,
    images = ARRAY[options.family_image],
    variants = options.variants,
    is_active = true
FROM option_lists options
WHERE p.id = options.master_id;

UPDATE public.products p
SET is_active = false
WHERE p.id IN (SELECT DISTINCT source_id FROM apollo_duplicate_family_sources)
  AND p.id NOT IN (SELECT DISTINCT master_id FROM apollo_duplicate_family_sources);
