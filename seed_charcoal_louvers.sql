DO $$
DECLARE
    v_panels_id UUID;
    v_charcoal_id UUID;
    v_desc TEXT;
    v_specs JSONB;
BEGIN
    -- 1. Create Main Category (if it doesn't exist)
    SELECT id INTO v_panels_id FROM categories WHERE name = 'Panels' LIMIT 1;
    IF v_panels_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Panels', 'panels') RETURNING id INTO v_panels_id;
    END IF;

    -- 2. Create Subcategory
    SELECT id INTO v_charcoal_id FROM categories WHERE name = 'Charcoal Louvers' LIMIT 1;
    IF v_charcoal_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Charcoal Louvers', 'charcoal-louvers', v_panels_id) RETURNING id INTO v_charcoal_id;
    END IF;

    -- 3. Define Description and Specs
    v_desc := 'IRIS Signature Decorative Panels

Transform your interiors with IRIS Signature — a premium range of decorative wall panels designed to bring elegance, texture, and modern aesthetics to any space. Crafted from eco-friendly materials and enhanced with charcoal technology, these panels ensure both beauty and safety.

With a wide selection of finishes including wood, marble, stone, and metallic textures, IRIS Signature panels offer endless design possibilities for modern interiors.

✨ Key Highlights
- Premium designer finishes (wood, marble, stone & more)
- Eco-friendly & safe material
- Charcoal-infused for healthier interiors
- Easy installation with shiplap system
- Water, termite & borer resistant
- Seamless and modern appearance';

    v_specs := '{
        "Thickness": "6mm",
        "Height": "2400mm (8ft)",
        "Type": "Decorative PVC Panels",
        "Installation": "Shiplap interlocking system",
        "Best For": "Living room feature walls, Bedrooms, Offices & reception areas, Retail interiors, Commercial spaces"
    }'::jsonb;

    -- 4. Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('IRIS Signature GL-2101', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2101.png', ARRAY['/images/products/louvers/charcoal/gl-2101.png', '/images/products/louvers/charcoal/gl-2101-room.png'], v_specs),
    ('IRIS Signature GL-2102', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2102.png', ARRAY['/images/products/louvers/charcoal/gl-2102.png'], v_specs),
    ('IRIS Signature GL-2103', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2103.png', ARRAY['/images/products/louvers/charcoal/gl-2103.png'], v_specs),
    ('IRIS Signature GL-2104', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2104.png', ARRAY['/images/products/louvers/charcoal/gl-2104.png'], v_specs),
    ('IRIS Signature GL-2105', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2105.png', ARRAY['/images/products/louvers/charcoal/gl-2105.png'], v_specs),
    ('IRIS Signature GL-2106', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2106.png', ARRAY['/images/products/louvers/charcoal/gl-2106.png', '/images/products/louvers/charcoal/gl-2106-2.png'], v_specs),
    ('IRIS Signature GL-2107', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2107.png', ARRAY['/images/products/louvers/charcoal/gl-2107.png'], v_specs),
    ('IRIS Signature GL-2108', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2108.png', ARRAY['/images/products/louvers/charcoal/gl-2108.png'], v_specs),
    ('IRIS Signature GL-2109', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2109.png', ARRAY['/images/products/louvers/charcoal/gl-2109.png'], v_specs),
    ('IRIS Signature GL-2110', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2110.png', ARRAY['/images/products/louvers/charcoal/gl-2110.png'], v_specs),
    ('IRIS Signature GL-2111', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2111.png', ARRAY['/images/products/louvers/charcoal/gl-2111.png'], v_specs),
    ('IRIS Signature GL-2112', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2112.png', ARRAY['/images/products/louvers/charcoal/gl-2112.png'], v_specs),
    ('IRIS Signature GL-2114', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2114.png', ARRAY['/images/products/louvers/charcoal/gl-2114.png'], v_specs),
    ('IRIS Signature GL-2115', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2115.png', ARRAY['/images/products/louvers/charcoal/gl-2115.png'], v_specs),
    ('IRIS Signature GL-2116', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2116.png', ARRAY['/images/products/louvers/charcoal/gl-2116.png'], v_specs),
    ('IRIS Signature GL-2117', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2117.png', ARRAY['/images/products/louvers/charcoal/gl-2117.png'], v_specs),
    ('IRIS Signature GL-2118', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2118.png', ARRAY['/images/products/louvers/charcoal/gl-2118.png'], v_specs),
    ('IRIS Signature GL-2119', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2119.png', ARRAY['/images/products/louvers/charcoal/gl-2119.png'], v_specs),
    ('IRIS Signature GL-2120', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2120.png', ARRAY['/images/products/louvers/charcoal/gl-2120.png'], v_specs),
    ('IRIS Signature GL-2121', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2121.png', ARRAY['/images/products/louvers/charcoal/gl-2121.png'], v_specs),
    ('IRIS Signature GL-2122', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2122.png', ARRAY['/images/products/louvers/charcoal/gl-2122.png'], v_specs),
    ('IRIS Signature GL-2123', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2123.png', ARRAY['/images/products/louvers/charcoal/gl-2123.png'], v_specs),
    ('IRIS Signature GL-2124', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2124.png', ARRAY['/images/products/louvers/charcoal/gl-2124.png'], v_specs),
    ('IRIS Signature GL-2125', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2125.png', ARRAY['/images/products/louvers/charcoal/gl-2125.png'], v_specs),
    ('IRIS Signature GL-2126', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2126.png', ARRAY['/images/products/louvers/charcoal/gl-2126.png'], v_specs),
    ('IRIS Signature GL-2127', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2127.png', ARRAY['/images/products/louvers/charcoal/gl-2127.png'], v_specs),
    ('IRIS Signature GL-2301', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2301.png', ARRAY['/images/products/louvers/charcoal/gl-2301.png'], v_specs),
    ('IRIS Signature GL-2302', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2302.png', ARRAY['/images/products/louvers/charcoal/gl-2302.png', '/images/products/louvers/charcoal/gl-2302-room.png'], v_specs),
    ('IRIS Signature GL-2303', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2303.png', ARRAY['/images/products/louvers/charcoal/gl-2303.png'], v_specs),
    ('IRIS Signature GL-2304', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2304.png', ARRAY['/images/products/louvers/charcoal/gl-2304.png'], v_specs),
    ('IRIS Signature GL-2305', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2305.png', ARRAY['/images/products/louvers/charcoal/gl-2305.png'], v_specs),
    ('IRIS Signature GL-2306', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2306.png', ARRAY['/images/products/louvers/charcoal/gl-2306.png'], v_specs),
    ('IRIS Signature GL-2307', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-2307.png', ARRAY['/images/products/louvers/charcoal/gl-2307.png'], v_specs),
    ('IRIS Signature GL-9402', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9402.png', ARRAY['/images/products/louvers/charcoal/gl-9402.png'], v_specs),
    ('IRIS Signature GL-9403', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9403.png', ARRAY['/images/products/louvers/charcoal/gl-9403.png'], v_specs),
    ('IRIS Signature GL-9404', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9404.png', ARRAY['/images/products/louvers/charcoal/gl-9404.png'], v_specs),
    ('IRIS Signature GL-9405', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9405.png', ARRAY['/images/products/louvers/charcoal/gl-9405.png'], v_specs),
    ('IRIS Signature GL-9406', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9406.png', ARRAY['/images/products/louvers/charcoal/gl-9406.png'], v_specs),
    ('IRIS Signature GL-9407', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9407.png', ARRAY['/images/products/louvers/charcoal/gl-9407.png', '/images/products/louvers/charcoal/gl-9407-room.png'], v_specs),
    ('IRIS Signature GL-9408', v_desc, 1800, v_charcoal_id, 100, true, '/images/products/louvers/charcoal/gl-9408.png', ARRAY['/images/products/louvers/charcoal/gl-9408.png'], v_specs);

END $$;