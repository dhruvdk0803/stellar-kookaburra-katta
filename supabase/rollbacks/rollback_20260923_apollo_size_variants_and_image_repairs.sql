-- Restore Apollo product catalog fields captured before the 2026-09-23
-- variant/image migration. Keep the snapshot table for audit and safe retries.
DO $$
BEGIN
  IF to_regclass('public.apollo_product_snapshot_20260923') IS NULL THEN
    RAISE EXCEPTION 'Apollo rollback snapshot is missing; refusing to restore';
  END IF;
END $$;

UPDATE public.products p
SET name = b.name,
    price = b.price,
    image_url = b.image_url,
    images = b.images,
    variants = b.variants,
    is_active = b.is_active,
    category_id = b.category_id,
    stock = b.stock,
    specs = b.specs
FROM public.apollo_product_snapshot_20260923 b
WHERE p.id = b.product_id;
