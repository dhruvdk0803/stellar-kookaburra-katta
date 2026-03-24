DO $$
DECLARE
    v_sunmica_id UUID;
    v_kridha_id UUID;
    v_rockstar_08_id UUID;
    v_rockstar_doorskin_id UUID;
    v_thermoluxe_id UUID;
    v_trustlam_id UUID;
BEGIN
    -- 1. Recreate Sunmica if it doesn't exist
    SELECT id INTO v_sunmica_id FROM categories WHERE name = 'Sunmica' LIMIT 1;
    IF v_sunmica_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Sunmica', 'sunmica') RETURNING id INTO v_sunmica_id;
    END IF;

    -- 2. Recreate Subcategories
    -- Kridha
    SELECT id INTO v_kridha_id FROM categories WHERE name = '1mm – Kridha' LIMIT 1;
    IF v_kridha_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('1mm – Kridha', '1mm-kridha', v_sunmica_id) RETURNING id INTO v_kridha_id;
    ELSE
        UPDATE categories SET parent_id = v_sunmica_id WHERE id = v_kridha_id;
    END IF;

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

    -- Trustlam
    SELECT id INTO v_trustlam_id FROM categories WHERE name = 'Pastels – Trustlam' LIMIT 1;
    IF v_trustlam_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Pastels – Trustlam', 'pastels-trustlam', v_sunmica_id) RETURNING id INTO v_trustlam_id;
    ELSE
        UPDATE categories SET parent_id = v_sunmica_id WHERE id = v_trustlam_id;
    END IF;

    -- 3. Attempt to rescue orphaned products
    UPDATE products SET category_id = v_thermoluxe_id WHERE category_id IS NULL AND image_url ILIKE '%thermoluxe%';
    UPDATE products SET category_id = v_rockstar_doorskin_id WHERE category_id IS NULL AND image_url ILIKE '%rockstar_doorskins%';
    UPDATE products SET category_id = v_rockstar_08_id WHERE category_id IS NULL AND image_url ILIKE '%rockstar_premium%';
    UPDATE products SET category_id = v_kridha_id WHERE category_id IS NULL AND image_url ILIKE '%kridha%';

END $$;