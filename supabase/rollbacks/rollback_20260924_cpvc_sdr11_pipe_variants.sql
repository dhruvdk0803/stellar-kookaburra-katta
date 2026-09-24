UPDATE public.products p
SET name = s.name,
    price = s.price,
    image_url = s.image_url,
    images = s.images,
    variants = s.variants,
    is_active = s.is_active,
    category_id = s.category_id,
    stock = s.stock,
    specs = s.specs
FROM public.apollo_variant_snapshot_20260924_sdr11 s
WHERE p.id = s.product_id;
