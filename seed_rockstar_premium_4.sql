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

    -- Ensure Subcategory 'Rockstar Premium Sunmica' exists
    SELECT id INTO v_category_id FROM categories WHERE name = 'Rockstar Premium Sunmica' LIMIT 1;
    IF v_category_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Rockstar Premium Sunmica', 'rockstar-premium-sunmica', v_parent_id) RETURNING id INTO v_category_id;
    END IF;

    -- Define Description and Specs
    v_desc := 'Rockstar Premium Sunmica (Decorative Laminates)

Elevate your interiors with Rockstar Premium Sunmica — a high-quality range of decorative laminate sheets designed to deliver style, durability, and versatility across modern spaces.

Crafted with advanced surface technology, these laminates feature rich textures, digital patterns, and elegant finishes that replicate wood, stone, abstract art, and contemporary designs. Whether you''re designing wardrobes, furniture, wall panels, or modular interiors, Rockstar Sunmica offers a perfect balance of aesthetics and performance.

Built to withstand everyday wear, these laminates are scratch-resistant, easy to maintain, and long-lasting, making them ideal for both residential and commercial applications.

✨ KEY FEATURES
• Premium decorative laminate sheets (Sunmica)
• High-definition prints & realistic textures
• Scratch-resistant & durable surface
• Heat & moisture resistant
• Easy to clean and maintain
• Wide variety of modern & classic designs
• Ideal for furniture, walls, and interior applications';

    v_specs := '{
        "Product Type": "Decorative Laminate Sheet (Sunmica)",
        "Available Sizes": "8 ft x 4 ft (Standard)",
        "Finish Options": "Matte Finish, Gloss Finish, Textured Finish",
        "Thickness": "Typically 0.8mm – 1mm (can vary by design)",
        "Material": "High-pressure decorative laminate (HPL)",
        "Application Areas": "Wardrobes, Modular kitchens, Furniture surfaces, Wall panels, Office interiors"
    }'::jsonb;

    -- Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('1023 - SF | DOVE GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1023-sf-dove-grey.png', ARRAY['/images/products/rockstar_premium/1023-sf-dove-grey.png'], v_specs),
    ('1011 - SF | BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1011-sf-beige.png', ARRAY['/images/products/rockstar_premium/1011-sf-beige.png'], v_specs),
    ('1002 - SF | OFF WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1002-sf-off-white.png', ARRAY['/images/products/rockstar_premium/1002-sf-off-white.png'], v_specs),
    ('1007 - SF | LIGHT GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1007-sf-light-grey.png', ARRAY['/images/products/rockstar_premium/1007-sf-light-grey.png'], v_specs),
    ('1022 - SF | LITE BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1022-sf-lite-beige.png', ARRAY['/images/products/rockstar_premium/1022-sf-lite-beige.png'], v_specs),
    ('1009 - SF | BLACK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1009-sf-black.png', ARRAY['/images/products/rockstar_premium/1009-sf-black.png'], v_specs),
    ('1019 - SF | WINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1019-sf-wine.png', ARRAY['/images/products/rockstar_premium/1019-sf-wine.png'], v_specs),
    ('1008 - SF | RED', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1008-sf-red.png', ARRAY['/images/products/rockstar_premium/1008-sf-red.png'], v_specs),
    ('1026 - SF | BLUE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1026-sf-blue.png', ARRAY['/images/products/rockstar_premium/1026-sf-blue.png'], v_specs),
    ('1012 - SF | PINK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1012-sf-pink.png', ARRAY['/images/products/rockstar_premium/1012-sf-pink.png'], v_specs),
    ('1013 - SF | COFFEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1013-sf-coffee.png', ARRAY['/images/products/rockstar_premium/1013-sf-coffee.png'], v_specs),
    ('1010 - SF | YELLOW', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1010-sf-yellow.png', ARRAY['/images/products/rockstar_premium/1010-sf-yellow.png'], v_specs),
    ('1021 - SF | ORANGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1021-sf-orange.png', ARRAY['/images/products/rockstar_premium/1021-sf-orange.png'], v_specs),
    ('1003 - SF | GREEN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1003-sf-green.png', ARRAY['/images/products/rockstar_premium/1003-sf-green.png'], v_specs);
END $$;