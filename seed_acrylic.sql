DO $$
DECLARE
    v_acrylic_id UUID;
    v_fluted_id UUID;
    v_sheets_id UUID;
    v_desc TEXT;
    v_specs JSONB;
BEGIN
    -- 1. Create Main Category
    SELECT id INTO v_acrylic_id FROM categories WHERE name = 'Acrylic' LIMIT 1;
    IF v_acrylic_id IS NULL THEN
        INSERT INTO categories (name, slug) VALUES ('Acrylic', 'acrylic') RETURNING id INTO v_acrylic_id;
    END IF;

    -- 2. Create Subcategories
    SELECT id INTO v_fluted_id FROM categories WHERE name = 'Fluted Acrylic' LIMIT 1;
    IF v_fluted_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Fluted Acrylic', 'fluted-acrylic', v_acrylic_id) RETURNING id INTO v_fluted_id;
    END IF;

    SELECT id INTO v_sheets_id FROM categories WHERE name = 'Acrylic Sheets' LIMIT 1;
    IF v_sheets_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Acrylic Sheets', 'acrylic-sheets', v_acrylic_id) RETURNING id INTO v_sheets_id;
    END IF;

    -- 3. Define Description and Specs
    v_desc := 'Premium Acrylic High-Gloss Sheets

Transform interiors with the brilliance of Acrylic Sheets — a premium surface solution designed for ultra-glossy, mirror-like finishes and modern aesthetics. Engineered for high-end applications, these sheets deliver a luxurious glass-like appearance with superior durability and color depth.

Unlike traditional laminates, acrylic sheets offer rich, vibrant colors, flawless reflections, and a perfectly smooth surface, making them ideal for contemporary interiors that demand elegance and shine.

Perfectly suited for modular designs, these sheets combine style, strength, and easy maintenance — giving your spaces a sleek, high-end finish.

✨ KEY FEATURES (SELLING POINTS)
- Ultra high-gloss (mirror-like reflection)
- Rich, deep color finish (premium look)
- Scratch-resistant surface (better than standard laminates)
- UV-resistant (no yellowing over time)
- Moisture-resistant (ideal for kitchens)
- Easy to clean & maintain
- Seamless smooth surface
- Long-lasting shine retention

👉 Acrylic sheets are positioned as more premium than Sunmica — highlight this clearly.';

    v_specs := '{
        "Product Type": "Acrylic Decorative Sheets",
        "Finish": "High Gloss (Primary USP)",
        "Thickness": "~1 mm (varies slightly by brand, usually 0.8–1.5 mm)",
        "Size": "8 ft x 4 ft (Standard) / 8 ft x 2 ft (Fluted)",
        "Surface": "Glass-like reflective surface",
        "Application Areas": "Modular kitchen shutters (MAIN USE 🔥), Wardrobes & sliding doors, Cabinets & furniture panels, Wall panels (luxury interiors)"
    }'::jsonb;

    -- 4. Insert Products
    -- Fluted Acrylic (RL Series - 8x2)
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('RL 2727 STATUARIO', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2727-statuario.png', ARRAY['/images/products/acrylic/rl-2727-statuario.png'], v_specs),
    ('RL 2724 CLASSIC WALNUT', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2724-classic-walnut.png', ARRAY['/images/products/acrylic/rl-2724-classic-walnut.png'], v_specs),
    ('RL 2723 IVORY JEWEL', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2723-ivory-jewel.png', ARRAY['/images/products/acrylic/rl-2723-ivory-jewel.png'], v_specs),
    ('RL 2722 SAPPHIRE', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2722-sapphire.png', ARRAY['/images/products/acrylic/rl-2722-sapphire.png'], v_specs),
    ('RL 2725 EMERALD', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2725-emerald.png', ARRAY['/images/products/acrylic/rl-2725-emerald.png'], v_specs),
    ('RL 2726 SCARLET', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2726-scarlet.png', ARRAY['/images/products/acrylic/rl-2726-scarlet.png'], v_specs),
    ('RL 2714 BIANCO LASA', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2714-bianco-lasa.png', ARRAY['/images/products/acrylic/rl-2714-bianco-lasa.png'], v_specs),
    ('RL 2713 GOLD FLAKES', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2713-gold-flakes.png', ARRAY['/images/products/acrylic/rl-2713-gold-flakes.png'], v_specs),
    ('RL 2707 BASIL', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2707-basil.png', ARRAY['/images/products/acrylic/rl-2707-basil.png'], v_specs),
    ('RL 2703 LAPIS', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2703-lapis.png', ARRAY['/images/products/acrylic/rl-2703-lapis.png'], v_specs),
    ('RL 2701 SNOW', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2701-snow.png', ARRAY['/images/products/acrylic/rl-2701-snow.png'], v_specs),
    ('RL 2702 FRAPPE', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2702-frappe.png', ARRAY['/images/products/acrylic/rl-2702-frappe.png'], v_specs),
    ('RL 2708 MENTHOL', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2708-menthol.png', ARRAY['/images/products/acrylic/rl-2708-menthol.png'], v_specs),
    ('RL 2709 FADED', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2709-faded.png', ARRAY['/images/products/acrylic/rl-2709-faded.png'], v_specs),
    ('RL 2711 CHEROOT', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2711-cheroot.png', ARRAY['/images/products/acrylic/rl-2711-cheroot.png'], v_specs),
    ('RL 2704 RHINO', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2704-rhino.png', ARRAY['/images/products/acrylic/rl-2704-rhino.png'], v_specs),
    ('RL 2705 BENJAMIN MOORE', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2705-benjamin-moore.png', ARRAY['/images/products/acrylic/rl-2705-benjamin-moore.png'], v_specs),
    ('RL 2716 ASHEN', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2716-ashen.png', ARRAY['/images/products/acrylic/rl-2716-ashen.png'], v_specs),
    ('RL 2718 GRAPHITE', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2718-graphite.png', ARRAY['/images/products/acrylic/rl-2718-graphite.png'], v_specs),
    ('RL 2712 ROSEATE', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2712-roseate.png', ARRAY['/images/products/acrylic/rl-2712-roseate.png'], v_specs),
    ('RL 2710 METONYX', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2710-metonyx.png', ARRAY['/images/products/acrylic/rl-2710-metonyx.png'], v_specs),
    ('RL 2715 PEARL', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2715-pearl.png', ARRAY['/images/products/acrylic/rl-2715-pearl.png'], v_specs),
    ('RL 2717 ASMONY', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2717-asmony.png', ARRAY['/images/products/acrylic/rl-2717-asmony.png'], v_specs),
    ('RL 2720 FOSSIL', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2720-fossil.png', ARRAY['/images/products/acrylic/rl-2720-fossil.png'], v_specs),
    ('RL 2719 TEAL', v_desc, 2400, v_fluted_id, 100, true, '/images/products/acrylic/rl-2719-teal.png', ARRAY['/images/products/acrylic/rl-2719-teal.png'], v_specs);

    -- Acrylic Sheets (RM Series - 8x4)
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('RM 4016 VONI', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4016-voni.png', ARRAY['/images/products/acrylic/rm-4016-voni.png'], v_specs),
    ('RM 4029 RHINO', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4029-rhino.png', ARRAY['/images/products/acrylic/rm-4029-rhino.png'], v_specs),
    ('RM 6025 ARMOUR', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6025-armour.png', ARRAY['/images/products/acrylic/rm-6025-armour.png'], v_specs),
    ('RM 4041 SANGRIA', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4041-sangria.png', ARRAY['/images/products/acrylic/rm-4041-sangria.png'], v_specs),
    ('RM 6123 DASRU', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6123-dasru.png', ARRAY['/images/products/acrylic/rm-6123-dasru.png'], v_specs),
    ('RM 6024 KAMBABA', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6024-kambaba.png', ARRAY['/images/products/acrylic/rm-6024-kambaba.png'], v_specs),
    ('RM 4009 MIDNIGHT', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4009-midnight.png', ARRAY['/images/products/acrylic/rm-4009-midnight.png'], v_specs),
    ('RM 6021 GOLD FLAKES', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6021-gold-flakes.png', ARRAY['/images/products/acrylic/rm-6021-gold-flakes.png'], v_specs),
    ('RM 4002 COTTON', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4002-cotton.png', ARRAY['/images/products/acrylic/rm-4002-cotton.png'], v_specs),
    ('RM 4043 BASIL', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4043-basil.png', ARRAY['/images/products/acrylic/rm-4043-basil.png'], v_specs),
    ('RM 4034 LAPIS', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4034-lapis.png', ARRAY['/images/products/acrylic/rm-4034-lapis.png'], v_specs),
    ('RM 4001 SNOW', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4001-snow.png', ARRAY['/images/products/acrylic/rm-4001-snow.png'], v_specs),
    ('RM 4003 FRAPPE', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4003-frappe.png', ARRAY['/images/products/acrylic/rm-4003-frappe.png'], v_specs),
    ('RM 4030 MENTHOL', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4030-menthol.png', ARRAY['/images/products/acrylic/rm-4030-menthol.png'], v_specs),
    ('RM 4005 FOSSIL', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4005-fossil.png', ARRAY['/images/products/acrylic/rm-4005-fossil.png'], v_specs),
    ('RM 4042 GULABJI', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4042-gulabji.png', ARRAY['/images/products/acrylic/rm-4042-gulabji.png'], v_specs),
    ('RM 4036 BENJAMIN MOORE', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4036-benjamin-moore.png', ARRAY['/images/products/acrylic/rm-4036-benjamin-moore.png'], v_specs),
    ('RM 6115 GREIGE', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6115-greige.png', ARRAY['/images/products/acrylic/rm-6115-greige.png'], v_specs),
    ('RM 6109 CHEROOT', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6109-cheroot.png', ARRAY['/images/products/acrylic/rm-6109-cheroot.png'], v_specs),
    ('RM 6119 GRAPHITE', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6119-graphite.png', ARRAY['/images/products/acrylic/rm-6119-graphite.png'], v_specs),
    ('RM 6110 ROSEATE', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6110-roseate.png', ARRAY['/images/products/acrylic/rm-6110-roseate.png'], v_specs),
    ('RM 6108 METONYX', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6108-metonyx.png', ARRAY['/images/products/acrylic/rm-6108-metonyx.png'], v_specs),
    ('RM 6101 PEARL', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6101-pearl.png', ARRAY['/images/products/acrylic/rm-6101-pearl.png'], v_specs),
    ('RM 6111 ASMONY', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-6111-asmony.png', ARRAY['/images/products/acrylic/rm-6111-asmony.png'], v_specs),
    ('RM 4033 TEAL', v_desc, 3200, v_sheets_id, 100, true, '/images/products/acrylic/rm-4033-teal.png', ARRAY['/images/products/acrylic/rm-4033-teal.png'], v_specs);

END $$;