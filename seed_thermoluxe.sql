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

    -- Ensure Subcategory 'Thermoluxe Premium Laminates' exists
    SELECT id INTO v_category_id FROM categories WHERE name = 'Thermoluxe Premium Laminates' LIMIT 1;
    IF v_category_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Thermoluxe Premium Laminates', 'thermoluxe-premium-laminates', v_parent_id) RETURNING id INTO v_category_id;
    END IF;

    -- Define Description and Specs
    v_desc := 'Thermoluxe Premium Laminates (Sunmica Collection)

Experience the next level of surface design with Thermoluxe — a luxury laminate collection crafted to redefine modern interiors. Designed using advanced German technology, Thermoluxe laminates combine elegant aesthetics with high-performance surfaces, delivering a premium look with unmatched functionality.

This exclusive range features soft velvet-touch finishes, anti-fingerprint technology, and superior durability, making it ideal for contemporary homes and high-end commercial spaces. Every design is curated to bring a refined, minimal, and sophisticated feel to interiors.

Step beyond ordinary laminates and embrace a collection that blends luxury, innovation, and timeless style.

✨ KEY FEATURES
• Anti-fingerprint surface (no marks, always clean look)
• Stain-resistant technology
• Scratch-resistant durability
• Light-fastness (no color fading over time)
• Anti-bacterial surface
• Easy to clean & maintain
• Sustainable & eco-conscious build
• Premium velvet / soft-touch finish';

    v_specs := '{
        "Product Type": "Premium Decorative Laminate (Sunmica)",
        "Technology": "German Surface Technology",
        "Finish Type": "Super Matte (Velvet Touch) / Glossy Series",
        "Size": "2440 mm x 1220 mm (8 ft x 4 ft approx)",
        "Thickness": "1.3 mm",
        "Surface Feel": "Ultra-smooth soft-touch (velvet feel)",
        "Application Areas": "Modular kitchens, Wardrobes & closets, Furniture surfaces, Wall paneling, Office interiors, Luxury residential spaces"
    }'::jsonb;

    -- Insert Products (Setting a premium price of 2500 for 1.3mm thickness)
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('GL-1103 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1103.png', ARRAY['/images/products/thermoluxe/gl-1103.png'], v_specs),
    ('GL-1105 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1105.png', ARRAY['/images/products/thermoluxe/gl-1105.png'], v_specs),
    ('GL-1116 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1116.png', ARRAY['/images/products/thermoluxe/gl-1116.png'], v_specs),
    ('GL-1113 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1113.png', ARRAY['/images/products/thermoluxe/gl-1113.png'], v_specs),
    ('GL-1114 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1114.png', ARRAY['/images/products/thermoluxe/gl-1114.png'], v_specs),
    ('GL-1108 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1108.png', ARRAY['/images/products/thermoluxe/gl-1108.png'], v_specs),
    ('GL-1112 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1112.png', ARRAY['/images/products/thermoluxe/gl-1112.png'], v_specs),
    ('GL-1104 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1104.png', ARRAY['/images/products/thermoluxe/gl-1104.png'], v_specs),
    ('GL-1110 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1110.png', ARRAY['/images/products/thermoluxe/gl-1110.png'], v_specs),
    ('GL-1109 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1109.png', ARRAY['/images/products/thermoluxe/gl-1109.png'], v_specs),
    ('GL-1106 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1106.png', ARRAY['/images/products/thermoluxe/gl-1106.png'], v_specs),
    ('GL-1102 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1102.png', ARRAY['/images/products/thermoluxe/gl-1102.png'], v_specs),
    ('GL-1101 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1101.png', ARRAY['/images/products/thermoluxe/gl-1101.png'], v_specs),
    ('GL-1119 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1119.png', ARRAY['/images/products/thermoluxe/gl-1119.png'], v_specs),
    
    -- GL-1115 includes the wardrobe mockup as the second image in the array!
    ('GL-1115 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1115.png', ARRAY['/images/products/thermoluxe/gl-1115.png', '/images/products/thermoluxe/gl-1115-mockup.png'], v_specs),
    
    ('GL-1107 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1107.png', ARRAY['/images/products/thermoluxe/gl-1107.png'], v_specs),
    ('GL-1117 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1117.png', ARRAY['/images/products/thermoluxe/gl-1117.png'], v_specs),
    ('GL-1304 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1304.png', ARRAY['/images/products/thermoluxe/gl-1304.png'], v_specs),
    ('GL-1302 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1302.png', ARRAY['/images/products/thermoluxe/gl-1302.png'], v_specs),
    ('GL-1303 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1303.png', ARRAY['/images/products/thermoluxe/gl-1303.png'], v_specs),
    ('GL-1301 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1301.png', ARRAY['/images/products/thermoluxe/gl-1301.png'], v_specs),
    ('GL-1353 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1353.png', ARRAY['/images/products/thermoluxe/gl-1353.png'], v_specs),
    ('GL-1156 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1156.png', ARRAY['/images/products/thermoluxe/gl-1156.png'], v_specs),
    ('GL-1157 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1157.png', ARRAY['/images/products/thermoluxe/gl-1157.png'], v_specs),
    ('GL-1352 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1352.png', ARRAY['/images/products/thermoluxe/gl-1352.png'], v_specs),
    ('GL-1155 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1155.png', ARRAY['/images/products/thermoluxe/gl-1155.png'], v_specs),
    ('GL-1165 | Thermoluxe Premium', v_desc, 2500, v_category_id, 100, true, '/images/products/thermoluxe/gl-1165.png', ARRAY['/images/products/thermoluxe/gl-1165.png'], v_specs);
END $$;