-- 1. Add the missing 'specs' column to the products table if it doesn't exist
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS specs JSONB DEFAULT '{}'::jsonb;

-- 2. Run the insertion script
DO $$
DECLARE
    v_parent_id UUID;
    v_category_id UUID;
    v_desc TEXT;
    v_specs JSONB;
BEGIN
    -- Ensure Parent Category 'Sunmica' exists
    SELECT id INTO v_parent_id FROM categories WHERE name = 'Sunmica' LIMIT 1;
    IF v_parent_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Sunmica', 'sunmica') RETURNING id INTO v_parent_id;
    END IF;

    -- Ensure Subcategory 'Doorskin – Rockstar' exists
    SELECT id INTO v_category_id FROM categories WHERE name = 'Doorskin – Rockstar' LIMIT 1;
    IF v_category_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Doorskin – Rockstar', 'doorskin-rockstar', v_parent_id) RETURNING id INTO v_category_id;
    END IF;

    -- Define Description and Specs
    v_desc := 'Rockstar Digital & Premium Door Skins

Elevate your interiors with Rockstar Door Laminates — a perfect fusion of craftsmanship, durability, and modern aesthetics. Designed to transform ordinary doors into statement pieces, these door skins feature high-definition digital prints, rich wood textures, and premium finishes that complement both contemporary and classic spaces.

Whether you’re designing a luxury home, office, or commercial space, Rockstar door skins bring unmatched elegance, strength, and long-lasting performance.

Crafted with precision and inspired by nature, art, and architecture, each design delivers a unique visual identity while ensuring reliability for everyday use.

✨ KEY SELLING POINTS
• Premium decorative laminated door skins
• High-definition digital and textured designs
• Scratch-resistant & long-lasting finish
• Moisture-resistant surface
• Easy to install on flush doors
• Suitable for residential & commercial use
• Wide range of modern, classic & artistic designs';

    v_specs := '{
        "Product Type": "Decorative Door Skin / Door Laminate",
        "Available Sizes": "7 ft x 3.25 ft, 8 ft x 4 ft",
        "Finish Options": "Matte, High Gloss",
        "Material": "Engineered laminated decorative sheet",
        "Application": "Wooden doors, Flush doors, Interior doors",
        "Thickness": "1mm - 1.5mm"
    }'::jsonb;

    -- Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('Rockstar Door Skin - Design 01', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-01.png', ARRAY['/images/products/rockstar/design-01.png'], v_specs),
    ('Rockstar Door Skin - Design 02', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-02.png', ARRAY['/images/products/rockstar/design-02.png'], v_specs),
    ('Rockstar Door Skin - Design 03', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-03.png', ARRAY['/images/products/rockstar/design-03.png'], v_specs),
    ('Rockstar Door Skin - Design 04', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-04.png', ARRAY['/images/products/rockstar/design-04.png'], v_specs),
    ('Rockstar Door Skin - Design 05', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-05.png', ARRAY['/images/products/rockstar/design-05.png'], v_specs),
    ('Rockstar Door Skin - Design 06', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-06.png', ARRAY['/images/products/rockstar/design-06.png'], v_specs),
    ('Rockstar Door Skin - Design 07', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-07.png', ARRAY['/images/products/rockstar/design-07.png'], v_specs),
    ('Rockstar Door Skin - Design 08', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-08.png', ARRAY['/images/products/rockstar/design-08.png'], v_specs),
    ('Rockstar Door Skin - Design 09', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-09.png', ARRAY['/images/products/rockstar/design-09.png'], v_specs),
    ('Rockstar Door Skin - Design 10', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-10.png', ARRAY['/images/products/rockstar/design-10.png'], v_specs),
    ('Rockstar Door Skin - Design 11', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-11.png', ARRAY['/images/products/rockstar/design-11.png'], v_specs),
    ('Rockstar Door Skin - Design 12', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-12.png', ARRAY['/images/products/rockstar/design-12.png'], v_specs),
    ('Rockstar Door Skin - Design 13', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-13.png', ARRAY['/images/products/rockstar/design-13.png'], v_specs),
    ('Rockstar Door Skin - Design 14', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-14.png', ARRAY['/images/products/rockstar/design-14.png'], v_specs),
    ('Rockstar Door Skin - Design 15', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-15.png', ARRAY['/images/products/rockstar/design-15.png'], v_specs),
    ('Rockstar Door Skin - Design 16', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-16.png', ARRAY['/images/products/rockstar/design-16.png'], v_specs),
    ('Rockstar Door Skin - Design 17', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-17.png', ARRAY['/images/products/rockstar/design-17.png'], v_specs),
    ('Rockstar Door Skin - Design 18', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-18.png', ARRAY['/images/products/rockstar/design-18.png'], v_specs),
    ('Rockstar Door Skin - Design 19', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-19.png', ARRAY['/images/products/rockstar/design-19.png'], v_specs),
    ('Rockstar Door Skin - Design 20', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-20.png', ARRAY['/images/products/rockstar/design-20.png'], v_specs),
    ('Rockstar Door Skin - Design 21', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-21.png', ARRAY['/images/products/rockstar/design-21.png'], v_specs),
    ('Rockstar Door Skin - Design 22', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-22.png', ARRAY['/images/products/rockstar/design-22.png'], v_specs),
    ('Rockstar Door Skin - Design 23', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-23.png', ARRAY['/images/products/rockstar/design-23.png'], v_specs),
    ('Rockstar Door Skin - Design 24', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-24.png', ARRAY['/images/products/rockstar/design-24.png'], v_specs),
    ('Rockstar Door Skin - Design 25', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-25.png', ARRAY['/images/products/rockstar/design-25.png'], v_specs),
    ('Rockstar Door Skin - Design 26', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-26.png', ARRAY['/images/products/rockstar/design-26.png'], v_specs),
    ('Rockstar Door Skin - Design 27', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-27.png', ARRAY['/images/products/rockstar/design-27.png'], v_specs),
    ('Rockstar Door Skin - Design 28', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-28.png', ARRAY['/images/products/rockstar/design-28.png'], v_specs),
    ('Rockstar Door Skin - Design 29', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-29.png', ARRAY['/images/products/rockstar/design-29.png'], v_specs),
    ('Rockstar Door Skin - Design 30', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-30.png', ARRAY['/images/products/rockstar/design-30.png'], v_specs),
    ('Rockstar Door Skin - Design 31', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-31.png', ARRAY['/images/products/rockstar/design-31.png'], v_specs),
    ('Rockstar Door Skin - Design 32', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-32.png', ARRAY['/images/products/rockstar/design-32.png'], v_specs),
    ('Rockstar Door Skin - Design 33', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-33.png', ARRAY['/images/products/rockstar/design-33.png'], v_specs),
    ('Rockstar Door Skin - Design 34', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-34.png', ARRAY['/images/products/rockstar/design-34.png'], v_specs),
    ('Rockstar Door Skin - Design 35', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-35.png', ARRAY['/images/products/rockstar/design-35.png'], v_specs),
    ('Rockstar Door Skin - Design 36', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-36.png', ARRAY['/images/products/rockstar/design-36.png'], v_specs),
    ('Rockstar Door Skin - Design 37', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-37.png', ARRAY['/images/products/rockstar/design-37.png'], v_specs),
    ('Rockstar Door Skin - Design 38', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-38.png', ARRAY['/images/products/rockstar/design-38.png'], v_specs),
    ('Rockstar Door Skin - Design 39', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-39.png', ARRAY['/images/products/rockstar/design-39.png'], v_specs),
    ('Rockstar Door Skin - Design 40', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-40.png', ARRAY['/images/products/rockstar/design-40.png'], v_specs),
    ('Rockstar Door Skin - Design 41', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-41.png', ARRAY['/images/products/rockstar/design-41.png'], v_specs),
    ('Rockstar Door Skin - Design 42', v_desc, 1500, v_category_id, 100, true, '/images/products/rockstar/design-42.png', ARRAY['/images/products/rockstar/design-42.png'], v_specs);
END $$;