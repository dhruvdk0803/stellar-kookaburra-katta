DO $$
DECLARE
    v_sunmica_id UUID;
    v_rockstar_08_id UUID;
    v_rockstar_doorskin_id UUID;
    v_thermoluxe_id UUID;
BEGIN
    -- 1. Ensure Main Sunmica Category Exists
    SELECT id INTO v_sunmica_id FROM categories WHERE name = 'Sunmica' LIMIT 1;
    IF v_sunmica_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Sunmica', 'sunmica') RETURNING id INTO v_sunmica_id;
    END IF;

    -- 2. Ensure Subcategories Exist and are linked to Sunmica
    -- Rockstar 0.8mm
    SELECT id INTO v_rockstar_08_id FROM categories WHERE name = '0.8mm – Rockstar' LIMIT 1;
    IF v_rockstar_08_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('0.8mm – Rockstar', '0-8mm-rockstar', v_sunmica_id) RETURNING id INTO v_rockstar_08_id;
    ELSE
        UPDATE categories SET parent_id = v_sunmica_id WHERE id = v_rockstar_08_id;
    END IF;

    -- Rockstar Doorskin
    SELECT id INTO v_rockstar_doorskin_id FROM categories WHERE name = 'Doorskin – Rockstar' LIMIT 1;
    IF v_rockstar_doorskin_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Doorskin – Rockstar', 'doorskin-rockstar', v_sunmica_id) RETURNING id INTO v_rockstar_doorskin_id;
    ELSE
        UPDATE categories SET parent_id = v_sunmica_id WHERE id = v_rockstar_doorskin_id;
    END IF;

    -- Thermoluxe
    SELECT id INTO v_thermoluxe_id FROM categories WHERE name = '1.3mm – Thermoluxe' LIMIT 1;
    IF v_thermoluxe_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('1.3mm – Thermoluxe', '1-3mm-thermoluxe', v_sunmica_id) RETURNING id INTO v_thermoluxe_id;
    ELSE
        UPDATE categories SET parent_id = v_sunmica_id WHERE id = v_thermoluxe_id;
    END IF;

    -- 3. Delete unwanted Kridha category and its products
    DELETE FROM products WHERE category_id IN (SELECT id FROM categories WHERE name ILIKE '%Kridha%');
    DELETE FROM categories WHERE name ILIKE '%Kridha%';

    -- 4. Re-link all products perfectly based on their image paths
    
    -- Fix Doorskins (images are in /rockstar/ folder)
    UPDATE products 
    SET category_id = v_rockstar_doorskin_id 
    WHERE image_url ILIKE '%/rockstar/%' OR images::text ILIKE '%/rockstar/%';

    -- Fix Rockstar Premium (images are in /rockstar_premium/ folder)
    UPDATE products 
    SET category_id = v_rockstar_08_id 
    WHERE image_url ILIKE '%/rockstar_premium/%' OR images::text ILIKE '%/rockstar_premium/%';

    -- Fix Thermoluxe (images are in /thermoluxe/ folder)
    UPDATE products 
    SET category_id = v_thermoluxe_id 
    WHERE image_url ILIKE '%/thermoluxe/%' OR images::text ILIKE '%/thermoluxe/%';

END $$;