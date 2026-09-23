-- Delete a brand's catalog data without removing shared taxonomy or order history.
-- Categories are global (not brand-owned), so only brand-exclusive leaf categories
-- directly used by the brand's products are safe to remove.
ALTER TABLE public.order_items
  ADD COLUMN IF NOT EXISTS product_name_snapshot TEXT,
  ADD COLUMN IF NOT EXISTS product_image_snapshot TEXT;

UPDATE public.order_items AS item
SET product_name_snapshot = COALESCE(item.product_name_snapshot, product.name),
    product_image_snapshot = COALESCE(item.product_image_snapshot, product.images[1], product.image_url)
FROM public.products AS product
WHERE item.product_id = product.id
  AND (item.product_name_snapshot IS NULL OR item.product_image_snapshot IS NULL);

CREATE OR REPLACE FUNCTION public.snapshot_order_item_product()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.product_id IS NOT NULL THEN
    SELECT product.name, COALESCE(product.images[1], product.image_url)
    INTO NEW.product_name_snapshot, NEW.product_image_snapshot
    FROM public.products AS product
    WHERE product.id = NEW.product_id;
  END IF;
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.snapshot_order_item_product() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS order_items_snapshot_product ON public.order_items;
CREATE TRIGGER order_items_snapshot_product
  BEFORE INSERT OR UPDATE OF product_id ON public.order_items
  FOR EACH ROW EXECUTE FUNCTION public.snapshot_order_item_product();

CREATE OR REPLACE FUNCTION public.delete_brand_catalog(target_brand_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  deleted_product_count INTEGER := 0;
  deleted_category_count INTEGER := 0;
BEGIN
  IF auth.uid() IS NULL OR NOT public.is_admin() THEN
    RAISE EXCEPTION 'Only administrators can delete a brand catalog.' USING ERRCODE = '42501';
  END IF;

  -- Lock the row so another request cannot add products to this brand midway
  -- through the delete operation.
  PERFORM 1
  FROM public.brands
  WHERE id = target_brand_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Brand not found.' USING ERRCODE = 'P0002';
  END IF;

  -- Preserve names/images for old orders even when product_id is set to NULL.
  UPDATE public.order_items AS item
  SET product_name_snapshot = COALESCE(item.product_name_snapshot, product.name),
      product_image_snapshot = COALESCE(item.product_image_snapshot, product.images[1], product.image_url)
  FROM public.products AS product
  WHERE item.product_id = product.id
    AND product.brand_id = target_brand_id;

  WITH brand_categories AS (
    SELECT DISTINCT category_id
    FROM public.products
    WHERE brand_id = target_brand_id
      AND category_id IS NOT NULL
  )
  DELETE FROM public.categories AS category
  USING brand_categories AS candidate
  WHERE category.id = candidate.category_id
    -- Do not remove a parent category; taxonomy is shared across brands.
    AND NOT EXISTS (
      SELECT 1
      FROM public.categories AS child
      WHERE child.parent_id = category.id
    )
    -- Keep a category if any other brand (or unassigned product) uses it.
    AND NOT EXISTS (
      SELECT 1
      FROM public.products AS other_product
      WHERE other_product.category_id = category.id
        AND other_product.brand_id IS DISTINCT FROM target_brand_id
    );

  GET DIAGNOSTICS deleted_category_count = ROW_COUNT;

  DELETE FROM public.products
  WHERE brand_id = target_brand_id;

  GET DIAGNOSTICS deleted_product_count = ROW_COUNT;

  DELETE FROM public.brands
  WHERE id = target_brand_id;

  RETURN jsonb_build_object(
    'deleted_products', deleted_product_count,
    'deleted_categories', deleted_category_count
  );
END;
$$;

REVOKE ALL ON FUNCTION public.delete_brand_catalog(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.delete_brand_catalog(UUID) TO authenticated;
