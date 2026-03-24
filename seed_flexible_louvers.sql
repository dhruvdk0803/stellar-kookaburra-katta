DO $$
DECLARE
    v_panels_id UUID;
    v_flex_id UUID;
    v_desc TEXT;
    v_specs JSONB;
BEGIN
    -- 1. Create Main Category (if it doesn't exist)
    SELECT id INTO v_panels_id FROM categories WHERE name = 'Panels' LIMIT 1;
    IF v_panels_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Panels', 'panels') RETURNING id INTO v_panels_id;
    END IF;

    -- 2. Create Subcategory
    SELECT id INTO v_flex_id FROM categories WHERE name = 'Flexible Interlocking' LIMIT 1;
    IF v_flex_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Flexible Interlocking', 'flexible-interlocking', v_panels_id) RETURNING id INTO v_flex_id;
    END IF;

    -- 3. Define Description and Specs
    v_desc := 'IRIS Curve Flexible Panels

Redefine interior design with IRIS Curve — India’s first flexible interlocking panel system designed for seamless curved applications. Whether it''s columns, reception desks, or architectural feature walls, these panels adapt effortlessly to any shape while delivering a premium, modern finish.

Engineered for flexibility and durability, IRIS Curve panels offer unmatched design freedom with easy installation and long-lasting performance.

✨ Key Highlights
- Flexible design for curved surfaces
- Seamless interlocking system
- Pre-finished premium surfaces
- Water & termite resistant
- Durable and low maintenance
- Perfect for modern luxury interiors';

    v_specs := '{
        "Size": "600mm (2ft) × 2440mm (8ft)",
        "Type": "Flexible Interlocking Panels",
        "Finish": "Pre-finished",
        "Installation": "Adhesive + interlocking system",
        "Best For": "Curved walls & pillars, Reception counters, Feature architectural elements, Commercial interiors, Luxury residential spaces"
    }'::jsonb;

    -- 4. Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('IRIS Curve 9107', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/9107.png', ARRAY['/images/products/louvers/flexible/9107.png'], v_specs),
    ('IRIS Curve 9124', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/9124.png', ARRAY['/images/products/louvers/flexible/9124.png'], v_specs),
    ('IRIS Curve 9125', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/9125.png', ARRAY['/images/products/louvers/flexible/9125.png'], v_specs),
    ('IRIS Curve GL 9101', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9101.png', ARRAY['/images/products/louvers/flexible/gl-9101.png'], v_specs),
    ('IRIS Curve GL 9102', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9102.png', ARRAY['/images/products/louvers/flexible/gl-9102.png', '/images/products/louvers/flexible/gl-9102-1.png'], v_specs),
    ('IRIS Curve GL 9103', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9103.png', ARRAY['/images/products/louvers/flexible/gl-9103.png'], v_specs),
    ('IRIS Curve GL 9104', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9104.png', ARRAY['/images/products/louvers/flexible/gl-9104.png'], v_specs),
    ('IRIS Curve GL 9105', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9105.png', ARRAY['/images/products/louvers/flexible/gl-9105.png'], v_specs),
    ('IRIS Curve GL 9106', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9106.png', ARRAY['/images/products/louvers/flexible/gl-9106.png'], v_specs),
    ('IRIS Curve GL 9108', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9108.png', ARRAY['/images/products/louvers/flexible/gl-9108.png'], v_specs),
    ('IRIS Curve GL 9109', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9109.png', ARRAY['/images/products/louvers/flexible/gl-9109.png'], v_specs),
    ('IRIS Curve GL 9110', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9110.png', ARRAY['/images/products/louvers/flexible/gl-9110.png'], v_specs),
    ('IRIS Curve GL 9111', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9111.png', ARRAY['/images/products/louvers/flexible/gl-9111.png'], v_specs),
    ('IRIS Curve GL 9112', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9112.png', ARRAY['/images/products/louvers/flexible/gl-9112.png'], v_specs),
    ('IRIS Curve GL 9121', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9121.png', ARRAY['/images/products/louvers/flexible/gl-9121.png'], v_specs),
    ('IRIS Curve GL 9122', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9122.png', ARRAY['/images/products/louvers/flexible/gl-9122.png'], v_specs),
    ('IRIS Curve GL 9123', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9123.png', ARRAY['/images/products/louvers/flexible/gl-9123.png'], v_specs),
    ('IRIS Curve GL 9126', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9126.png', ARRAY['/images/products/louvers/flexible/gl-9126.png'], v_specs),
    ('IRIS Curve GL 9127', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9127.png', ARRAY['/images/products/louvers/flexible/gl-9127.png'], v_specs),
    ('IRIS Curve GL 9128', v_desc, 1500, v_flex_id, 100, true, '/images/products/louvers/flexible/gl-9128.png', ARRAY['/images/products/louvers/flexible/gl-9128.png'], v_specs);

END $$;