-- Structured brands, category merchandising metadata, and bounded homepage feeds.
CREATE TABLE IF NOT EXISTS public.brands (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  logo_url TEXT,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read active brands" ON public.brands;
CREATE POLICY "Public read active brands" ON public.brands
  FOR SELECT USING (is_active = true OR public.is_admin());
DROP POLICY IF EXISTS "Admin all brands" ON public.brands;
CREATE POLICY "Admin all brands" ON public.brands
  TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());

ALTER TABLE public.categories
  ADD COLUMN IF NOT EXISTS image_url TEXT,
  ADD COLUMN IF NOT EXISTS display_order INTEGER NOT NULL DEFAULT 0;

ALTER TABLE public.products
  ADD COLUMN IF NOT EXISTS brand_id UUID REFERENCES public.brands(id) ON DELETE RESTRICT;

INSERT INTO public.brands (name, slug, logo_url, display_order) VALUES
  ('Ebco', 'ebco', '/images/brands/ebco.svg', 10),
  ('Apollo', 'apollo', '/images/brands/apollo.svg', 20),
  ('Astral', 'astral', '/images/brands/astral.svg', 30),
  ('Jivanjor', 'jivanjor', '/images/brands/jivanjor.svg', 40),
  ('Rockstar', 'rockstar', '/images/brands/rockstar.svg', 50),
  ('Gloirio', 'gloirio', '/images/brands/gloirio.svg', 60),
  ('Rang', 'rang', '/images/brands/rang.svg', 70),
  ('Thermoluxe', 'thermoluxe', '/images/brands/thermoluxe.svg', 80),
  ('IRIS', 'iris', '/images/brands/iris.svg', 90)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  logo_url = EXCLUDED.logo_url,
  display_order = EXCLUDED.display_order;

-- The live catalog audit identifies Thermoluxe and IRIS as Gloirio product
-- ranges, not manufacturers. Keep their records reserved but do not expose
-- them as independent homepage brands.
UPDATE public.brands SET is_active = false WHERE slug IN ('thermoluxe', 'iris');

-- Determine a real catalog brand from existing category ancestry and catalog
-- identifiers. More-specific product-name rules deliberately run first.
WITH RECURSIVE category_paths AS (
  SELECT id, parent_id, name, name::TEXT AS path
  FROM public.categories
  UNION ALL
  SELECT cp.id, c.parent_id, c.name, c.name || ' / ' || cp.path
  FROM category_paths cp
  JOIN public.categories c ON c.id = cp.parent_id
), product_paths AS (
  SELECT p.id, p.name, p.description, lower(cp.path) AS path
  FROM public.products p
  LEFT JOIN category_paths cp ON cp.id = p.category_id
  WHERE cp.parent_id IS NULL
), assignments AS (
  SELECT id,
    CASE
      WHEN name ~* '^Ebco\s+' OR path LIKE '%ebco%' THEN 'ebco'
      WHEN name ~* '^(Apollo|APL Apollo)\s+' OR path LIKE '%apollo%' OR description ILIKE '%APL Apollo%' THEN 'apollo'
      WHEN name ~* '^Astral\s+' OR path LIKE '%astral%' THEN 'astral'
      WHEN name ~* '^Jivanjor\s+' OR path LIKE '%jivanjor%' THEN 'jivanjor'
      WHEN name ~* '^Rockstar\s+' OR path LIKE '%rockstar%' OR description ILIKE 'Rockstar%' THEN 'rockstar'
      WHEN name ~* '^Gloirio\s+' OR name ~* '^(Thermoluxe|GL-[0-9]+\s*\|\s*Thermoluxe|IRIS\s+)' OR path LIKE '%thermoluxe%' THEN 'gloirio'
      WHEN name ~* '^(RL|RM|RC|RG)\s*[-0-9]' OR path LIKE '%pastel louvers%' THEN 'rang'
      ELSE NULL
    END AS brand_slug
  FROM product_paths
)
UPDATE public.products p
SET brand_id = b.id
FROM assignments a
JOIN public.brands b ON b.slug = a.brand_slug
WHERE p.id = a.id AND p.brand_id IS NULL;

-- Fail safely: a product with an unknown brand must be reviewed instead of
-- being silently assigned to an incorrect manufacturer.
DO $$
DECLARE
  unresolved INTEGER;
  unresolved_sample TEXT;
BEGIN
  SELECT count(*) INTO unresolved FROM public.products WHERE brand_id IS NULL;
  IF unresolved > 0 THEN
    SELECT string_agg(name, '; ') INTO unresolved_sample
    FROM (SELECT name FROM public.products WHERE brand_id IS NULL ORDER BY name LIMIT 10) sample;
    RAISE EXCEPTION '% products still need a verified brand assignment; migration stopped. Sample: %', unresolved, unresolved_sample;
  END IF;
END $$;

CREATE OR REPLACE FUNCTION public.infer_product_brand_id(
  product_name TEXT,
  product_category_id UUID,
  product_description TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  category_path TEXT;
  inferred_slug TEXT;
  result_id UUID;
BEGIN
  WITH RECURSIVE ancestors AS (
    SELECT id, parent_id, name FROM public.categories WHERE id = product_category_id
    UNION ALL
    SELECT c.id, c.parent_id, c.name FROM public.categories c JOIN ancestors a ON c.id = a.parent_id
  ) SELECT lower(string_agg(name, ' / ')) INTO category_path FROM ancestors;

  inferred_slug := CASE
    WHEN product_name ~* '^Ebco\s+' OR category_path LIKE '%ebco%' THEN 'ebco'
    WHEN product_name ~* '^(Apollo|APL Apollo)\s+' OR category_path LIKE '%apollo%' OR product_description ILIKE '%APL Apollo%' THEN 'apollo'
    WHEN product_name ~* '^Astral\s+' OR category_path LIKE '%astral%' THEN 'astral'
    WHEN product_name ~* '^Jivanjor\s+' OR category_path LIKE '%jivanjor%' THEN 'jivanjor'
    WHEN product_name ~* '^Rockstar\s+' OR category_path LIKE '%rockstar%' OR product_description ILIKE 'Rockstar%' THEN 'rockstar'
    WHEN product_name ~* '^Gloirio\s+' OR product_name ~* '^(Thermoluxe|GL-[0-9]+\s*\|\s*Thermoluxe|IRIS\s+)' OR category_path LIKE '%thermoluxe%' THEN 'gloirio'
    WHEN product_name ~* '^(RL|RM|RC|RG)\s*[-0-9]' OR category_path LIKE '%pastel louvers%' THEN 'rang'
    ELSE NULL
  END;
  SELECT id INTO result_id FROM public.brands WHERE slug = inferred_slug;
  RETURN result_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.enforce_product_brand_prefix()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  chosen_brand TEXT;
  old_brand TEXT;
  base_name TEXT;
BEGIN
  IF NEW.brand_id IS NULL THEN
    NEW.brand_id := public.infer_product_brand_id(NEW.name, NEW.category_id, NEW.description);
  END IF;
  SELECT name INTO chosen_brand FROM public.brands WHERE id = NEW.brand_id;
  IF chosen_brand IS NULL THEN
    RAISE EXCEPTION 'A valid brand is required for every product';
  END IF;

  base_name := btrim(NEW.name);
  IF TG_OP = 'UPDATE' AND OLD.brand_id IS DISTINCT FROM NEW.brand_id THEN
    SELECT name INTO old_brand FROM public.brands WHERE id = OLD.brand_id;
    IF old_brand IS NOT NULL AND lower(left(base_name, length(old_brand) + 1)) = lower(old_brand || ' ') THEN
      base_name := btrim(substr(base_name, length(old_brand) + 1));
    END IF;
  END IF;

  -- Remove repeated copies of the selected brand, then add exactly one.
  WHILE lower(left(base_name, length(chosen_brand) + 1)) = lower(chosen_brand || ' ') LOOP
    base_name := btrim(substr(base_name, length(chosen_brand) + 1));
  END LOOP;
  IF base_name = '' THEN RAISE EXCEPTION 'Product name cannot contain only the brand'; END IF;
  NEW.name := chosen_brand || ' ' || base_name;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS products_enforce_brand_prefix ON public.products;
CREATE TRIGGER products_enforce_brand_prefix
  BEFORE INSERT OR UPDATE OF name, brand_id ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.enforce_product_brand_prefix();

CREATE OR REPLACE FUNCTION public.sync_product_names_after_brand_rename()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF OLD.name IS DISTINCT FROM NEW.name THEN
    UPDATE public.products
    SET name = NEW.name || ' ' ||
      CASE
        WHEN lower(left(name, length(OLD.name) + 1)) = lower(OLD.name || ' ')
          THEN btrim(substr(name, length(OLD.name) + 1))
        ELSE name
      END
    WHERE brand_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS brands_sync_product_names ON public.brands;
CREATE TRIGGER brands_sync_product_names
  AFTER UPDATE OF name ON public.brands
  FOR EACH ROW EXECUTE FUNCTION public.sync_product_names_after_brand_rename();

-- Canonicalize existing names through the same trigger used for future writes.
UPDATE public.products p SET name = p.name;

ALTER TABLE public.products ALTER COLUMN brand_id SET NOT NULL;
CREATE INDEX IF NOT EXISTS products_brand_id_idx ON public.products (brand_id);

-- Category cards include rolled-up counts and one representative image.
CREATE OR REPLACE VIEW public.homepage_category_cards
WITH (security_invoker = true) AS
WITH RECURSIVE tree AS (
  SELECT id, id AS root_id, name AS root_name, slug AS root_slug, display_order AS root_display_order
  FROM public.categories WHERE parent_id IS NULL
  UNION ALL
  SELECT c.id, t.root_id, t.root_name, t.root_slug, t.root_display_order
  FROM public.categories c JOIN tree t ON c.parent_id = t.id
), descendants AS (
  SELECT id AS ancestor_id, id AS descendant_id FROM public.categories
  UNION ALL
  SELECT d.ancestor_id, c.id FROM descendants d
  JOIN public.categories c ON c.parent_id = d.descendant_id
)
SELECT c.id, c.name, c.slug, c.parent_id, c.image_url, c.display_order,
       t.root_id, t.root_name, t.root_slug, t.root_display_order,
       count(DISTINCT p.id)::INTEGER AS product_count,
       COALESCE(c.image_url, min(COALESCE(p.images[1], p.image_url))) AS thumbnail_url
FROM public.categories c
JOIN tree t ON t.id = c.id
JOIN descendants d ON d.ancestor_id = c.id
JOIN public.products p ON p.category_id = d.descendant_id AND p.is_active = true
GROUP BY c.id, c.name, c.slug, c.parent_id, c.image_url, c.display_order,
         t.root_id, t.root_name, t.root_slug, t.root_display_order;

CREATE OR REPLACE VIEW public.homepage_brand_cards
WITH (security_invoker = true) AS
SELECT b.id, b.name, b.slug, b.logo_url, b.display_order,
       count(p.id)::INTEGER AS product_count
FROM public.brands b
JOIN public.products p ON p.brand_id = b.id AND p.is_active = true
WHERE b.is_active = true
GROUP BY b.id, b.name, b.slug, b.logo_url, b.display_order;

CREATE OR REPLACE VIEW public.homepage_product_shelves
WITH (security_invoker = true) AS
WITH RECURSIVE tree AS (
  SELECT id, id AS root_id, name AS root_name, slug AS root_slug, display_order AS root_display_order
  FROM public.categories WHERE parent_id IS NULL
  UNION ALL
  SELECT c.id, t.root_id, t.root_name, t.root_slug, t.root_display_order
  FROM public.categories c JOIN tree t ON c.parent_id = t.id
), ranked AS (
  SELECT p.id, p.name, p.price, p.image_url, p.images, p.stock, p.created_at,
         c.id AS category_id, c.name AS category_name, c.slug AS category_slug,
         b.id AS brand_id, b.name AS brand_name, b.slug AS brand_slug,
         t.root_id, t.root_name, t.root_slug, t.root_display_order,
         row_number() OVER (PARTITION BY t.root_id ORDER BY p.created_at DESC, p.name) AS shelf_rank
  FROM public.products p
  JOIN public.categories c ON c.id = p.category_id
  JOIN tree t ON t.id = c.id
  JOIN public.brands b ON b.id = p.brand_id AND b.is_active = true
  WHERE p.is_active = true
)
SELECT * FROM ranked WHERE shelf_rank <= 8;

GRANT SELECT ON public.homepage_category_cards TO anon, authenticated;
GRANT SELECT ON public.homepage_brand_cards TO anon, authenticated;
GRANT SELECT ON public.homepage_product_shelves TO anon, authenticated;
