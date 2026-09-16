-- Read-only production verification for the structured catalog migration.
-- Every query should return zero rows except the final summary reports.

-- Missing or inactive brand assignments.
SELECT p.id, p.name
FROM public.products p
LEFT JOIN public.brands b ON b.id = p.brand_id
WHERE p.brand_id IS NULL OR b.id IS NULL OR b.is_active = false;

-- Names that do not begin with their assigned brand exactly once.
SELECT p.id, p.name, b.name AS brand
FROM public.products p
JOIN public.brands b ON b.id = p.brand_id
WHERE lower(left(p.name, length(b.name) + 1)) <> lower(b.name || ' ')
   OR lower(left(substr(p.name, length(b.name) + 2), length(b.name) + 1)) = lower(b.name || ' ');

-- Homepage cards must never lead to empty results.
SELECT * FROM public.homepage_category_cards WHERE product_count <= 0;
SELECT * FROM public.homepage_brand_cards WHERE product_count <= 0;

-- Review the final customer-facing brand inventory and coverage.
SELECT b.name, count(p.id) AS products
FROM public.brands b
LEFT JOIN public.products p ON p.brand_id = b.id AND p.is_active = true
GROUP BY b.id, b.name, b.display_order
ORDER BY b.display_order, b.name;

SELECT root_name, count(*) AS homepage_products
FROM public.homepage_product_shelves
GROUP BY root_id, root_name
ORDER BY root_name;
