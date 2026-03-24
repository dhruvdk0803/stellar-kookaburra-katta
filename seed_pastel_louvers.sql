DO $$
DECLARE
    v_panels_id UUID;
    v_pastel_id UUID;
    v_desc TEXT;
    v_specs JSONB;
BEGIN
    -- 1. Create Main Category (if it doesn't exist)
    SELECT id INTO v_panels_id FROM categories WHERE name = 'Panels' LIMIT 1;
    IF v_panels_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Panels', 'panels') RETURNING id INTO v_panels_id;
    END IF;

    -- 2. Create Subcategory
    SELECT id INTO v_pastel_id FROM categories WHERE name = 'Pastel Louvers' LIMIT 1;
    IF v_pastel_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Pastel Louvers', 'pastel-louvers', v_panels_id) RETURNING id INTO v_pastel_id;
    END IF;

    -- 3. Define Description and Specs
    v_desc := 'Groove Fluted Panels (Louver Collection)

Elevate your interiors with Groove Panels — a modern wall cladding solution designed with elegant vertical fluting. These panels add depth, texture, and sophistication, transforming plain walls into premium feature elements.

Crafted for contemporary spaces, the pastel collection brings soft tones with a 3D architectural finish — perfect for creating statement walls in homes and commercial interiors.

✨ Key Highlights
- Premium fluted (vertical groove) design
- 3D textured wall finish
- Available in elegant pastel shades
- Lightweight & easy installation
- Waterproof & termite-resistant
- Durable and long-lasting';

    v_specs := '{
        "Height": "9 Feet",
        "Width": "115–125 mm",
        "Thickness": "8–12 mm",
        "Finish": "Matte / Textured",
        "Best For": "TV panels, Accent walls, Bedroom backdrops, Office interiors, Showroom walls"
    }'::jsonb;

    -- 4. Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('Pastel Louver Panel 01', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-01.png', ARRAY['/images/products/louvers/pastel/pastel-louver-01.png'], v_specs),
    ('Pastel Louver Panel 02', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-02.png', ARRAY['/images/products/louvers/pastel/pastel-louver-02.png'], v_specs),
    ('Pastel Louver Panel 03', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-03.png', ARRAY['/images/products/louvers/pastel/pastel-louver-03.png'], v_specs),
    ('Pastel Louver Panel 04', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-04.png', ARRAY['/images/products/louvers/pastel/pastel-louver-04.png'], v_specs),
    ('Pastel Louver Panel 05', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-05.png', ARRAY['/images/products/louvers/pastel/pastel-louver-05.png'], v_specs),
    ('Pastel Louver Panel 06', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-06.png', ARRAY['/images/products/louvers/pastel/pastel-louver-06.png'], v_specs),
    ('Pastel Louver Panel 07', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-07.png', ARRAY['/images/products/louvers/pastel/pastel-louver-07.png'], v_specs),
    ('Pastel Louver Panel 08', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-08.png', ARRAY['/images/products/louvers/pastel/pastel-louver-08.png'], v_specs),
    ('Pastel Louver Panel 09', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-09.png', ARRAY['/images/products/louvers/pastel/pastel-louver-09.png'], v_specs),
    ('Pastel Louver Panel 10', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-10.png', ARRAY['/images/products/louvers/pastel/pastel-louver-10.png'], v_specs),
    ('Pastel Louver Panel 11', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-11.png', ARRAY['/images/products/louvers/pastel/pastel-louver-11.png'], v_specs),
    ('Pastel Louver Panel 12', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-12.png', ARRAY['/images/products/louvers/pastel/pastel-louver-12.png'], v_specs),
    ('Pastel Louver Panel 13', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-13.png', ARRAY['/images/products/louvers/pastel/pastel-louver-13.png'], v_specs),
    ('Pastel Louver Panel 14', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-14.png', ARRAY['/images/products/louvers/pastel/pastel-louver-14.png'], v_specs),
    ('Pastel Louver Panel 15', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-15.png', ARRAY['/images/products/louvers/pastel/pastel-louver-15.png'], v_specs),
    ('Pastel Louver Panel 16', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-16.png', ARRAY['/images/products/louvers/pastel/pastel-louver-16.png'], v_specs),
    ('Pastel Louver Panel 17', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-17.png', ARRAY['/images/products/louvers/pastel/pastel-louver-17.png'], v_specs),
    ('Pastel Louver Panel 18', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-18.png', ARRAY['/images/products/louvers/pastel/pastel-louver-18.png'], v_specs),
    ('Pastel Louver Panel 19', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-19.png', ARRAY['/images/products/louvers/pastel/pastel-louver-19.png'], v_specs),
    ('Pastel Louver Panel 20', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-20.png', ARRAY['/images/products/louvers/pastel/pastel-louver-20.png'], v_specs),
    ('Pastel Louver Panel 21', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-21.png', ARRAY['/images/products/louvers/pastel/pastel-louver-21.png'], v_specs),
    ('Pastel Louver Panel 22', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-22.png', ARRAY['/images/products/louvers/pastel/pastel-louver-22.png'], v_specs),
    ('Pastel Louver Panel 23', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-23.png', ARRAY['/images/products/louvers/pastel/pastel-louver-23.png'], v_specs),
    ('Pastel Louver Panel 24', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-24.png', ARRAY['/images/products/louvers/pastel/pastel-louver-24.png'], v_specs),
    ('Pastel Louver Panel 25', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-25.png', ARRAY['/images/products/louvers/pastel/pastel-louver-25.png'], v_specs),
    ('Pastel Louver Panel 26', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-26.png', ARRAY['/images/products/louvers/pastel/pastel-louver-26.png'], v_specs),
    ('Pastel Louver Panel 27', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-27.png', ARRAY['/images/products/louvers/pastel/pastel-louver-27.png'], v_specs),
    ('Pastel Louver Panel 28', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-28.png', ARRAY['/images/products/louvers/pastel/pastel-louver-28.png'], v_specs),
    ('Pastel Louver Panel 29', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-29.png', ARRAY['/images/products/louvers/pastel/pastel-louver-29.png'], v_specs),
    ('Pastel Louver Panel 30', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-30.png', ARRAY['/images/products/louvers/pastel/pastel-louver-30.png'], v_specs),
    ('Pastel Louver Panel 31', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-31.png', ARRAY['/images/products/louvers/pastel/pastel-louver-31.png'], v_specs),
    ('Pastel Louver Panel 32', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-32.png', ARRAY['/images/products/louvers/pastel/pastel-louver-32.png'], v_specs),
    ('Pastel Louver Panel 33', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-33.png', ARRAY['/images/products/louvers/pastel/pastel-louver-33.png'], v_specs),
    ('Pastel Louver Panel 34', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-34.png', ARRAY['/images/products/louvers/pastel/pastel-louver-34.png'], v_specs),
    ('Pastel Louver Panel 35', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-35.png', ARRAY['/images/products/louvers/pastel/pastel-louver-35.png'], v_specs),
    ('Pastel Louver Panel 36', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-36.png', ARRAY['/images/products/louvers/pastel/pastel-louver-36.png'], v_specs),
    ('Pastel Louver Panel 37', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-37.png', ARRAY['/images/products/louvers/pastel/pastel-louver-37.png'], v_specs),
    ('Pastel Louver Panel 38', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-38.png', ARRAY['/images/products/louvers/pastel/pastel-louver-38.png'], v_specs),
    ('Pastel Louver Panel 39', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-39.png', ARRAY['/images/products/louvers/pastel/pastel-louver-39.png'], v_specs),
    ('Pastel Louver Panel 40', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-40.png', ARRAY['/images/products/louvers/pastel/pastel-louver-40.png'], v_specs),
    ('Pastel Louver Panel 41', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-41.png', ARRAY['/images/products/louvers/pastel/pastel-louver-41.png'], v_specs),
    ('Pastel Louver Panel 42', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-42.png', ARRAY['/images/products/louvers/pastel/pastel-louver-42.png'], v_specs),
    ('Pastel Louver Panel 43', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-43.png', ARRAY['/images/products/louvers/pastel/pastel-louver-43.png'], v_specs),
    ('Pastel Louver Panel 44', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-44.png', ARRAY['/images/products/louvers/pastel/pastel-louver-44.png'], v_specs),
    ('Pastel Louver Panel 45', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-45.png', ARRAY['/images/products/louvers/pastel/pastel-louver-45.png'], v_specs),
    ('Pastel Louver Panel 46', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-46.png', ARRAY['/images/products/louvers/pastel/pastel-louver-46.png'], v_specs),
    ('Pastel Louver Panel 47', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-47.png', ARRAY['/images/products/louvers/pastel/pastel-louver-47.png'], v_specs),
    ('Pastel Louver Panel 48', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-48.png', ARRAY['/images/products/louvers/pastel/pastel-louver-48.png'], v_specs),
    ('Pastel Louver Panel 49', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-49.png', ARRAY['/images/products/louvers/pastel/pastel-louver-49.png'], v_specs),
    ('Pastel Louver Panel 50', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-50.png', ARRAY['/images/products/louvers/pastel/pastel-louver-50.png'], v_specs),
    ('Pastel Louver Panel 51', v_desc, 950, v_pastel_id, 100, true, '/images/products/louvers/pastel/pastel-louver-51.png', ARRAY['/images/products/louvers/pastel/pastel-louver-51.png'], v_specs);

END $$;