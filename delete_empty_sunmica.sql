DO $$
DECLARE
    v_record RECORD;
    v_child_count INT;
    v_product_count INT;
BEGIN
    -- Loop through all categories named 'Sunmica'
    FOR v_record IN 
        SELECT id, name FROM categories WHERE name ILIKE 'Sunmica'
    LOOP
        -- Check if this category has any subcategories
        SELECT COUNT(*) INTO v_child_count FROM categories WHERE parent_id = v_record.id;
        
        -- Check if this category has any direct products
        SELECT COUNT(*) INTO v_product_count FROM products WHERE category_id = v_record.id;
        
        -- If it has NO subcategories and NO products, it is safe to delete
        IF v_child_count = 0 AND v_product_count = 0 THEN
            DELETE FROM categories WHERE id = v_record.id;
        END IF;
    END LOOP;
END $$;