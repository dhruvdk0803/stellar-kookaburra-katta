-- Two CPVC NRV products showed the wrong photo:
--   * "Apollo CPVC Non Return Valve (NRV)" used the CPVC *pipe* photo on the
--     product and every size variant.
--   * "Apollo NRV (non Returnable Valve) SDR CPVC Fitting" hot-linked its only
--     photo from makankidukan.com, which can vanish at any time.
-- Both now use the Apollo CPVC NRV photo shipped in public/images/apollo/cpvc.
-- Re-run safe: only rows still carrying the old images are touched.

UPDATE public.products
SET image_url = '/images/apollo/cpvc/apollo cpvc NRV (NON RETURNABLE VALVE).webp',
    images = ARRAY['/images/apollo/cpvc/apollo cpvc NRV (NON RETURNABLE VALVE).webp'],
    variants = CASE
      WHEN jsonb_typeof(variants) = 'array' THEN (
        SELECT jsonb_agg(
          CASE WHEN v->>'image' = '/images/apollo/cpvc/apollo cpvc pipe.webp'
            THEN jsonb_set(v, '{image}', to_jsonb('/images/apollo/cpvc/apollo cpvc NRV (NON RETURNABLE VALVE).webp'::text))
            ELSE v END
          ORDER BY ord)
        FROM jsonb_array_elements(variants) WITH ORDINALITY AS e(v, ord)
      )
      ELSE variants
    END
WHERE id = '164e71aa-e4cd-4b37-8699-a71e7f95241a'
  AND images = ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'];

UPDATE public.products
SET image_url = '/images/apollo/cpvc/apollo cpvc NRV (NON RETURNABLE VALVE).webp',
    images = ARRAY['/images/apollo/cpvc/apollo cpvc NRV (NON RETURNABLE VALVE).webp']
WHERE id = '9307690b-677e-4d46-93f7-b3de36ccee93'
  AND images = ARRAY['https://www.makankidukan.com/uploads/products/1748338707_0.jpg'];
