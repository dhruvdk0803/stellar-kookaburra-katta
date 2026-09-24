-- Add the remaining active SDR-11 pipe diameters to the existing 3-meter
-- selectable-size product. Preserve each original record for rollback.
DO $$
DECLARE
  v_root_id UUID;
  v_root_variants JSONB;
  v_root_price NUMERIC;
  v_new_count INTEGER;
  v_labels TEXT[];
  v_merged_variants JSONB;
  v_min_price NUMERIC;
BEGIN
  CREATE TABLE IF NOT EXISTS public.apollo_variant_snapshot_20260924_sdr11 (
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
  ALTER TABLE public.apollo_variant_snapshot_20260924_sdr11 ENABLE ROW LEVEL SECURITY;
  REVOKE ALL ON TABLE public.apollo_variant_snapshot_20260924_sdr11 FROM PUBLIC, anon, authenticated;

  CREATE TEMP TABLE cpvc_sdr11_size_sources ON COMMIT DROP AS
  SELECT p.id, p.name, p.price, p.image_url, p.images, p.variants,
         p.is_active, p.category_id, p.stock, p.specs,
         trim(p.specs->>'Size (inch)') AS label
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  WHERE p.is_active = true
    AND c.slug = 'apollo-cpvc-fittings-pipes'
    AND (
      p.name ILIKE 'Apollo CPVC Pipe SDR-11, 1% (25mm)%'
      OR p.name ILIKE 'Apollo CPVC Pipe SDR-11, 2% (50mm)%'
    );

  -- Keep the category and activity guard applied to both exact-size matches.
  DELETE FROM cpvc_sdr11_size_sources s
  USING public.products p, public.categories c
  WHERE s.id = p.id AND c.id = p.category_id
    AND (p.is_active = false OR c.slug <> 'apollo-cpvc-fittings-pipes');

  SELECT count(*), array_agg(label ORDER BY label)
  INTO v_new_count, v_labels
  FROM cpvc_sdr11_size_sources;
  IF v_new_count <> 2 OR v_labels IS DISTINCT FROM ARRAY['1"', '2"']::TEXT[]
    OR EXISTS (SELECT 1 FROM cpvc_sdr11_size_sources WHERE label IS NULL OR coalesce(variants, '[]'::jsonb) <> '[]'::jsonb)
  THEN
    RAISE EXCEPTION 'Expected two standalone SDR-11 pipe rows with the 1-inch and 2-inch sizes; found % rows with labels %.', v_new_count, v_labels;
  END IF;

  SELECT p.id, p.variants, p.price
  INTO v_root_id, v_root_variants, v_root_price
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  WHERE p.is_active = true
    AND c.slug = 'apollo-cpvc-fittings-pipes'
    AND p.name ILIKE 'Apollo CPVC Pipe SDR-11%'
    AND jsonb_typeof(p.variants) = 'array'
    AND jsonb_array_length(p.variants) = 4
    AND NOT EXISTS (
      SELECT 1 FROM jsonb_array_elements(p.variants) v
      WHERE trim(v->>'label') IN ('1"', '2"')
    );
  IF v_root_id IS NULL THEN
    RAISE EXCEPTION 'Could not find the expected existing four-size SDR-11 pipe product.';
  END IF;

  INSERT INTO public.apollo_variant_snapshot_20260924_sdr11 (
    product_id, name, price, image_url, images, variants, is_active,
    category_id, stock, specs
  )
  SELECT p.id, p.name, p.price, p.image_url, p.images, p.variants,
         p.is_active, p.category_id, p.stock, p.specs
  FROM public.products p
  WHERE p.id = v_root_id OR p.id IN (SELECT id FROM cpvc_sdr11_size_sources)
  ON CONFLICT (product_id) DO NOTHING;

  SELECT jsonb_agg(option ORDER BY CASE label
    WHEN '1/2"' THEN 1
    WHEN '3/4"' THEN 2
    WHEN '1"' THEN 3
    WHEN '1-1/4"' THEN 4
    WHEN '1-1/2"' THEN 5
    WHEN '2"' THEN 6
    ELSE 99
  END)
  INTO v_merged_variants
  FROM (
    SELECT v AS option, v->>'label' AS label
    FROM jsonb_array_elements(v_root_variants) v
    UNION ALL
    SELECT jsonb_build_object(
      'label', s.label,
      'price', s.price,
      'image', coalesce(s.image_url, s.images[1]),
      'is_default', false,
      'type', 'size'
    ) AS option, s.label
    FROM cpvc_sdr11_size_sources s
  ) options;

  SELECT min(price) INTO v_min_price FROM cpvc_sdr11_size_sources;
  UPDATE public.products p
  SET name = 'Apollo CPVC Pipe SDR-11 (3 Meter)',
      price = least(v_root_price, v_min_price),
      variants = v_merged_variants,
      specs = coalesce(p.specs, '{}'::jsonb) - 'Size (mm)' - 'Size (inch)' - 'Standard Packaging'
  WHERE p.id = v_root_id;

  UPDATE public.products p
  SET is_active = false
  WHERE p.id IN (SELECT id FROM cpvc_sdr11_size_sources);
END $$;
