-- Keep the remaining same-family CPVC male adaptors selectable as size options.
-- When two live records describe the same size, keep the lower currently
-- published price and retain every original row for rollback.
DO $$
DECLARE
  v_source_count INTEGER;
  v_option_count INTEGER;
  v_master_id UUID;
  v_variants JSONB;
  v_master_image TEXT;
  v_master_images TEXT[];
  v_base_price NUMERIC;
BEGIN
  CREATE TABLE IF NOT EXISTS public.apollo_variant_snapshot_20260924 (
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
  ALTER TABLE public.apollo_variant_snapshot_20260924 ENABLE ROW LEVEL SECURITY;
  REVOKE ALL ON TABLE public.apollo_variant_snapshot_20260924 FROM PUBLIC, anon, authenticated;

  CREATE TEMP TABLE cpvc_male_adaptor_variant_sources ON COMMIT DROP AS
  SELECT
    p.id,
    p.name,
    p.price,
    p.image_url,
    p.images,
    p.variants,
    p.is_active,
    p.category_id,
    p.stock,
    p.specs,
    ((regexp_match(p.name, '(1-1/4|1-1/2|1/2|3/4|2|1)"'))[1] || '"') AS label
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  WHERE p.is_active = true
    AND c.slug = 'apollo-cpvc-fittings-pipes'
    AND p.name ILIKE 'Apollo CPVC Male Adaptor Brass Threaded %'
    AND coalesce(p.variants, '[]'::jsonb) = '[]'::jsonb;

  SELECT count(*) INTO v_source_count FROM cpvc_male_adaptor_variant_sources;
  SELECT count(DISTINCT label) INTO v_option_count FROM cpvc_male_adaptor_variant_sources;
  IF v_source_count <> 7 OR v_option_count <> 6 OR EXISTS (
    SELECT 1 FROM cpvc_male_adaptor_variant_sources WHERE label IS NULL
  ) THEN
    RAISE EXCEPTION 'Expected seven standalone source rows representing six CPVC male adaptor sizes; found % rows and % sizes.', v_source_count, v_option_count;
  END IF;

  CREATE TEMP TABLE cpvc_male_adaptor_variant_options ON COMMIT DROP AS
  SELECT DISTINCT ON (label)
    id, name, price, image_url, images, category_id, stock, specs, label
  FROM cpvc_male_adaptor_variant_sources
  ORDER BY label, price ASC, id;

  SELECT id, price, image_url, images
    INTO v_master_id, v_base_price, v_master_image, v_master_images
  FROM cpvc_male_adaptor_variant_options
  ORDER BY price ASC, id ASC
  LIMIT 1;

  INSERT INTO public.apollo_variant_snapshot_20260924 (
    product_id, name, price, image_url, images, variants, is_active,
    category_id, stock, specs
  )
  SELECT id, name, price, image_url, images, variants, is_active,
         category_id, stock, specs
  FROM cpvc_male_adaptor_variant_sources
  ON CONFLICT (product_id) DO NOTHING;

  SELECT jsonb_agg(
    jsonb_build_object(
      'label', label,
      'price', price,
      'image', coalesce(image_url, images[1]),
      'is_default', id = v_master_id,
      'type', 'size'
    )
    ORDER BY CASE label
      WHEN '1/2"' THEN 1
      WHEN '3/4"' THEN 2
      WHEN '1"' THEN 3
      WHEN '1-1/4"' THEN 4
      WHEN '1-1/2"' THEN 5
      WHEN '2"' THEN 6
      ELSE 99
    END
  ) INTO v_variants
  FROM cpvc_male_adaptor_variant_options;

  UPDATE public.products p
  SET name = 'Apollo CPVC Male Adaptor Brass Threaded',
      price = v_base_price,
      image_url = coalesce(v_master_image, p.image_url),
      images = coalesce(v_master_images, CASE WHEN v_master_image IS NULL THEN p.images ELSE ARRAY[v_master_image] END),
      variants = v_variants,
      is_active = true
  WHERE p.id = v_master_id;

  UPDATE public.products p
  SET is_active = false
  WHERE p.id IN (SELECT id FROM cpvc_male_adaptor_variant_sources)
    AND p.id <> v_master_id;
END $$;
