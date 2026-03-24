DO $$
DECLARE
    v_panels_id UUID;
    v_mdf_id UUID;
    v_desc TEXT;
    v_specs JSONB;
BEGIN
    -- 1. Create Main Category (if it doesn't exist)
    SELECT id INTO v_panels_id FROM categories WHERE name = 'Panels' LIMIT 1;
    IF v_panels_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Panels', 'panels') RETURNING id INTO v_panels_id;
    END IF;

    -- 2. Create Subcategory
    SELECT id INTO v_mdf_id FROM categories WHERE name = 'MDF Louvers' LIMIT 1;
    IF v_mdf_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('MDF Louvers', 'mdf-louvers', v_panels_id) RETURNING id INTO v_mdf_id;
    END IF;

    -- 3. Define Description and Specs
    v_desc := 'Century Decorative Panels

Transform your interiors with Century Panels — a versatile range of premium decorative sheets designed for walls, furniture, and modern spaces. Featuring rich textures like marble, wood, and abstract finishes, these panels deliver a luxurious look with practical durability.

Perfect for both residential and commercial interiors, Century Panels offer a seamless, elegant finish with easy installation and long-lasting performance.

✨ Key Highlights
- Premium flat panel designs
- Available in marble, wood & textured finishes
- Waterproof & termite resistant
- Smooth, high-quality surface finish
- Easy to install & maintain
- Durable and long-lasting';

    v_specs := '{
        "Type": "PVC / WPC Panels",
        "Form": "Flat Sheets",
        "Finish": "Gloss / Matte / Textured",
        "Application": "Wall & Furniture",
        "Best For": "Full wall panels, TV units, Wardrobes & cabinets, Office interiors"
    }'::jsonb;

    -- 4. Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('RC 1030 FLUTED FUMED OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1030-fluted-fumed-oak.png', ARRAY['/images/products/louvers/mdf/rc-1030-fluted-fumed-oak.png'], v_specs),
    ('RC 2008 FLUTED STATUARIO', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2008-fluted-statuario.png', ARRAY['/images/products/louvers/mdf/rc-2008-fluted-statuario.png'], v_specs),
    ('RC 1019 FLUTED WENGE', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1019-fluted-wenge.png', ARRAY['/images/products/louvers/mdf/rc-1019-fluted-wenge.png'], v_specs),
    ('RC 1028 FUMED OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1028-fumed-oak.png', ARRAY['/images/products/louvers/mdf/rc-1028-fumed-oak.png'], v_specs),
    ('RC 1008 EUROPEAN CHERRY', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1008-european-cherry.png', ARRAY['/images/products/louvers/mdf/rc-1008-european-cherry.png'], v_specs),
    ('RC 1009 BUBINGA', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1009-bubinga.png', ARRAY['/images/products/louvers/mdf/rc-1009-bubinga.png'], v_specs),
    ('RC 1010 CLASSIC WALNUT', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1010-classic-walnut.png', ARRAY['/images/products/louvers/mdf/rc-1010-classic-walnut.png'], v_specs),
    ('RC 1012 SAMARI OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1012-samari-oak.png', ARRAY['/images/products/louvers/mdf/rc-1012-samari-oak.png'], v_specs),
    ('RC 2001 GOLDEN TEAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2001-golden-teak.png', ARRAY['/images/products/louvers/mdf/rc-2001-golden-teak.png'], v_specs),
    ('RC 2002 ARMANI OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2002-armani-oak.png', ARRAY['/images/products/louvers/mdf/rc-2002-armani-oak.png'], v_specs),
    ('RC 2003 MOCHA', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2003-mocha.png', ARRAY['/images/products/louvers/mdf/rc-2003-mocha.png'], v_specs),
    ('RC 2005 JURASSIC', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2005-jurassic.png', ARRAY['/images/products/louvers/mdf/rc-2005-jurassic.png'], v_specs),
    ('RC 2006 STATUARIO', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2006-statuario.png', ARRAY['/images/products/louvers/mdf/rc-2006-statuario.png'], v_specs),
    ('RC 1001 SUGAR', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1001-sugar.png', ARRAY['/images/products/louvers/mdf/rc-1001-sugar.png'], v_specs),
    ('RC 1002 SAGE', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1002-sage.png', ARRAY['/images/products/louvers/mdf/rc-1002-sage.png'], v_specs),
    ('RC 1003 PIGEON', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1003-pigeon.png', ARRAY['/images/products/louvers/mdf/rc-1003-pigeon.png'], v_specs),
    ('RC 1004 ALABASTER', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1004-alabaster.png', ARRAY['/images/products/louvers/mdf/rc-1004-alabaster.png'], v_specs),
    ('RC 1029 RIBBED FUMED OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1029-ribbed-fumed-oak.png', ARRAY['/images/products/louvers/mdf/rc-1029-ribbed-fumed-oak.png'], v_specs),
    ('RC 1018 RIBBED EUROPEAN CHERRY', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1018-ribbed-european-cherry.png', ARRAY['/images/products/louvers/mdf/rc-1018-ribbed-european-cherry.png'], v_specs),
    ('RC 1016 RIBBED WALNUT', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1016-ribbed-walnut.png', ARRAY['/images/products/louvers/mdf/rc-1016-ribbed-walnut.png'], v_specs),
    ('RC 1015 RIBBED OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1015-ribbed-oak.png', ARRAY['/images/products/louvers/mdf/rc-1015-ribbed-oak.png'], v_specs),
    ('RC 1014 RIBBED PIGEON', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1014-ribbed-pigeon.png', ARRAY['/images/products/louvers/mdf/rc-1014-ribbed-pigeon.png'], v_specs),
    ('RC 1013 RIBBED SUGAR', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1013-ribbed-sugar.png', ARRAY['/images/products/louvers/mdf/rc-1013-ribbed-sugar.png'], v_specs),
    ('RC 1020 SUGAR PEAKS', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1020-sugar-peaks.png', ARRAY['/images/products/louvers/mdf/rc-1020-sugar-peaks.png'], v_specs),
    ('RC 2009 SMOKED CARICIA', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2009-smoked-caricia.png', ARRAY['/images/products/louvers/mdf/rc-2009-smoked-caricia.png'], v_specs),
    ('RC 2010 CARICIA', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2010-caricia.png', ARRAY['/images/products/louvers/mdf/rc-2010-caricia.png'], v_specs),
    ('RC 1006 TEAL', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-1006-teal.png', ARRAY['/images/products/louvers/mdf/rc-1006-teal.png'], v_specs),
    ('RC 2007 VINTAGE OAK', v_desc, 1200, v_mdf_id, 100, true, '/images/products/louvers/mdf/rc-2007-vintage-oak.png', ARRAY['/images/products/louvers/mdf/rc-2007-vintage-oak.png'], v_specs);

END $$;