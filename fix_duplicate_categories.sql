DO $$
DECLARE
    v_primary_sunmica_id UUID;
    v_duplicate_record RECORD;
BEGIN
    -- Find the first 'Sunmica' category to keep (the oldest one)
    SELECT id INTO v_primary_sunmica_id 
    FROM categories 
    WHERE name ILIKE 'Sunmica' 
    ORDER BY created_at ASC 
    LIMIT 1;

    IF v_primary_sunmica_id IS NOT NULL THEN
        -- Loop through all OTHER 'Sunmica' categories
        FOR v_duplicate_record IN 
            SELECT id FROM categories 
            WHERE name ILIKE 'Sunmica' AND id != v_primary_sunmica_id
        LOOP
            -- 1. Update any subcategories pointing to the duplicate to point to the primary
            UPDATE categories 
            SET parent_id = v_primary_sunmica_id 
            WHERE parent_id = v_duplicate_record.id;

            -- 2. Update any products pointing directly to the duplicate (just in case)
            UPDATE products 
            SET category_id = v_primary_sunmica_id 
            WHERE category_id = v_duplicate_record.id;

            -- 3. Delete the duplicate category
            DELETE FROM categories WHERE id = v_duplicate_record.id;
        END LOOP;
    END IF;
END $$;