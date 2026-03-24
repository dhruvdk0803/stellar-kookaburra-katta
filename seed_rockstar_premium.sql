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

    -- Ensure Subcategory 'Rockstar Premium Sunmica' exists
    SELECT id INTO v_category_id FROM categories WHERE name = 'Rockstar Premium Sunmica' LIMIT 1;
    IF v_category_id IS NULL THEN
        INSERT INTO categories (name, slug, parent_id) VALUES ('Rockstar Premium Sunmica', 'rockstar-premium-sunmica', v_parent_id) RETURNING id INTO v_category_id;
    END IF;

    -- Define Description and Specs
    v_desc := 'Rockstar Premium Sunmica (Decorative Laminates)

Elevate your interiors with Rockstar Premium Sunmica — a high-quality range of decorative laminate sheets designed to deliver style, durability, and versatility across modern spaces.

Crafted with advanced surface technology, these laminates feature rich textures, digital patterns, and elegant finishes that replicate wood, stone, abstract art, and contemporary designs. Whether you''re designing wardrobes, furniture, wall panels, or modular interiors, Rockstar Sunmica offers a perfect balance of aesthetics and performance.

Built to withstand everyday wear, these laminates are scratch-resistant, easy to maintain, and long-lasting, making them ideal for both residential and commercial applications.

✨ KEY FEATURES
• Premium decorative laminate sheets (Sunmica)
• High-definition prints & realistic textures
• Scratch-resistant & durable surface
• Heat & moisture resistant
• Easy to clean and maintain
• Wide variety of modern & classic designs
• Ideal for furniture, walls, and interior applications';

    v_specs := '{
        "Product Type": "Decorative Laminate Sheet (Sunmica)",
        "Available Sizes": "8 ft x 4 ft (Standard)",
        "Finish Options": "Matte Finish, Gloss Finish, Textured Finish",
        "Thickness": "Typically 0.8mm – 1mm (can vary by design)",
        "Material": "High-pressure decorative laminate (HPL)",
        "Application Areas": "Wardrobes, Modular kitchens, Furniture surfaces, Wall panels, Office interiors"
    }'::jsonb;

    -- Insert Products
    INSERT INTO products (name, description, price, category_id, stock, is_active, image_url, images, specs) VALUES
    ('1672 - GV | CACAO WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1672-gv-cacao-walnut.png', ARRAY['/images/products/rockstar_premium/1672-gv-cacao-walnut.png'], v_specs),
    ('1018 - BB | SANDRIFT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1018-bb-sandrift.png', ARRAY['/images/products/rockstar_premium/1018-bb-sandrift.png'], v_specs),
    ('1025 - BB | PEANUT BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1025-bb-peanut-beige.png', ARRAY['/images/products/rockstar_premium/1025-bb-peanut-beige.png'], v_specs),
    ('1024 - BB | PISTA GREEN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1024-bb-pista-green.png', ARRAY['/images/products/rockstar_premium/1024-bb-pista-green.png'], v_specs),
    ('1027 - BB | WINTER FOG', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1027-bb-winter-fog.png', ARRAY['/images/products/rockstar_premium/1027-bb-winter-fog.png'], v_specs),
    ('1022 - BB | LITE BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1022-bb-lite-beige.png', ARRAY['/images/products/rockstar_premium/1022-bb-lite-beige.png'], v_specs),
    ('1014 - BB | META TAN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1014-bb-meta-tan.png', ARRAY['/images/products/rockstar_premium/1014-bb-meta-tan.png'], v_specs),
    ('1621 - BB | BLACK CALCUTTA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1621-bb-black-calcutta.png', ARRAY['/images/products/rockstar_premium/1621-bb-black-calcutta.png'], v_specs),
    ('1682 - BB | ROYAL VENETINO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1682-bb-royal-venetino.png', ARRAY['/images/products/rockstar_premium/1682-bb-royal-venetino.png'], v_specs),
    ('1678 - BB | GREEN MERANTI', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1678-bb-green-meranti.png', ARRAY['/images/products/rockstar_premium/1678-bb-green-meranti.png'], v_specs),
    ('1677 - BB | TOUGH YEW', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1677-bb-tough-yew.png', ARRAY['/images/products/rockstar_premium/1677-bb-tough-yew.png'], v_specs),
    ('1028 - GV | GAUNTLET GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1028-gv-gauntlet-grey.png', ARRAY['/images/products/rockstar_premium/1028-gv-gauntlet-grey.png'], v_specs),
    ('1029 - GV | ICE BLUE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1029-gv-ice-blue.png', ARRAY['/images/products/rockstar_premium/1029-gv-ice-blue.png'], v_specs),
    ('1680 - HG | GALAXY CARRARA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1680-hg-galaxy-carrara.png', ARRAY['/images/products/rockstar_premium/1680-hg-galaxy-carrara.png'], v_specs),
    ('1619 - HG | BLACK TRAVERTINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1619-hg-black-travertine.png', ARRAY['/images/products/rockstar_premium/1619-hg-black-travertine.png'], v_specs),
    ('1616 - HG | GOLD TRAVERTINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1616-hg-gold-travertine.png', ARRAY['/images/products/rockstar_premium/1616-hg-gold-travertine.png'], v_specs),
    ('1617 - HG | EMERALD CARRARA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1617-hg-emerald-carrara.png', ARRAY['/images/products/rockstar_premium/1617-hg-emerald-carrara.png'], v_specs),
    ('1617 - HG | EMERALD CARRARA 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1617-hg-emerald-carrara-2.png', ARRAY['/images/products/rockstar_premium/1617-hg-emerald-carrara-2.png'], v_specs),
    ('1682 - HG | ROYAL VENETINO 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1682-hg-royal-venetino.png', ARRAY['/images/products/rockstar_premium/1682-hg-royal-venetino.png'], v_specs),
    ('1621 - HG | BLACK CALCUTTA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1621-hg-black-calcutta.png', ARRAY['/images/products/rockstar_premium/1621-hg-black-calcutta.png'], v_specs),
    ('1684 - HG | ALISEO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1684-hg-aliseo.png', ARRAY['/images/products/rockstar_premium/1684-hg-aliseo.png'], v_specs),
    ('1620 - HG | BONITO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1620-hg-bonito.png', ARRAY['/images/products/rockstar_premium/1620-hg-bonito.png'], v_specs),
    ('1014 - MLT | META TAN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1014-mlt-meta-tan.png', ARRAY['/images/products/rockstar_premium/1014-mlt-meta-tan.png'], v_specs),
    ('1016 - MLT | META COFFEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1016-mlt-meta-coffee.png', ARRAY['/images/products/rockstar_premium/1016-mlt-meta-coffee.png'], v_specs),
    ('1017 - MLT | META UMBR', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1017-mlt-meta-umbr.png', ARRAY['/images/products/rockstar_premium/1017-mlt-meta-umbr.png'], v_specs),
    ('1018 - MLT | SANDRIFT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1018-mlt-sandrift.png', ARRAY['/images/products/rockstar_premium/1018-mlt-sandrift.png'], v_specs),
    ('1027 - MLT | WINTER FOG', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1027-mlt-winter-fog.png', ARRAY['/images/products/rockstar_premium/1027-mlt-winter-fog.png'], v_specs),
    ('1028 - MLT | GAUNTLET GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1028-mlt-gauntlet-grey.png', ARRAY['/images/products/rockstar_premium/1028-mlt-gauntlet-grey.png'], v_specs),
    ('1025 - MLT | PEANUT BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1025-mlt-peanut-beige.png', ARRAY['/images/products/rockstar_premium/1025-mlt-peanut-beige.png'], v_specs),
    ('1024 - MLT | PISTA GREEN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1024-mlt-pista-green.png', ARRAY['/images/products/rockstar_premium/1024-mlt-pista-green.png'], v_specs),
    ('1029 - MLT | ICE BLUE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1029-mlt-ice-blue.png', ARRAY['/images/products/rockstar_premium/1029-mlt-ice-blue.png'], v_specs),
    ('1713 - HG | NOGALLINO LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1713-hg-nogallino-light.png', ARRAY['/images/products/rockstar_premium/1713-hg-nogallino-light.png'], v_specs),
    ('1714 - HG | NOGALLINO DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1714-hg-nogallino-dark.png', ARRAY['/images/products/rockstar_premium/1714-hg-nogallino-dark.png'], v_specs),
    ('1715 - HG | GRETA LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1715-hg-greta-light.png', ARRAY['/images/products/rockstar_premium/1715-hg-greta-light.png'], v_specs),
    ('1716 - HG | GRETA DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1716-hg-greta-dark.png', ARRAY['/images/products/rockstar_premium/1716-hg-greta-dark.png'], v_specs),
    ('1717 - HG | CROSS LINE LIGHT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1717-hg-cross-line-light-wood.png', ARRAY['/images/products/rockstar_premium/1717-hg-cross-line-light-wood.png'], v_specs),
    ('1718 - HG | CROSS LINE DARK WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1718-hg-cross-line-dark-wood.png', ARRAY['/images/products/rockstar_premium/1718-hg-cross-line-dark-wood.png'], v_specs),
    ('1719 - HG | ETERNITY LIGHT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1719-hg-eternity-light-wood.png', ARRAY['/images/products/rockstar_premium/1719-hg-eternity-light-wood.png'], v_specs),
    ('1720 - HG | ETERNITY DARK WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1720-hg-eternity-dark-wood.png', ARRAY['/images/products/rockstar_premium/1720-hg-eternity-dark-wood.png'], v_specs),
    ('1653 - HG | UMBER OAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1653-hg-umber-oak.png', ARRAY['/images/products/rockstar_premium/1653-hg-umber-oak.png'], v_specs),
    ('1679 - HG | CARAMEL PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1679-hg-caramel-pine.png', ARRAY['/images/products/rockstar_premium/1679-hg-caramel-pine.png'], v_specs),
    ('1645 - HG | CHOCO BARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1645-hg-choco-bark.png', ARRAY['/images/products/rockstar_premium/1645-hg-choco-bark.png'], v_specs),
    ('1638 - HG | GOLD BARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1638-hg-gold-bark.png', ARRAY['/images/products/rockstar_premium/1638-hg-gold-bark.png'], v_specs),
    ('1651 - HG | MAJESTIC REDWOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1651-hg-majestic-redwood.png', ARRAY['/images/products/rockstar_premium/1651-hg-majestic-redwood.png'], v_specs),
    ('1644 - HG | MAJESTIC BLACKWOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1644-hg-majestic-blackwood.png', ARRAY['/images/products/rockstar_premium/1644-hg-majestic-blackwood.png'], v_specs),
    ('1634 - HG | WHITE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1634-hg-white-spruce.png', ARRAY['/images/products/rockstar_premium/1634-hg-white-spruce.png'], v_specs),
    ('1659 - HG | MOCHOA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1659-hg-mochoa.png', ARRAY['/images/products/rockstar_premium/1659-hg-mochoa.png'], v_specs),
    ('1650 - HG | RICHMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1650-hg-richmond-glee.png', ARRAY['/images/products/rockstar_premium/1650-hg-richmond-glee.png'], v_specs),
    ('1662 - HG | DRIFT WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1662-hg-drift-walnut.png', ARRAY['/images/products/rockstar_premium/1662-hg-drift-walnut.png'], v_specs),
    ('1657 - HG | JAKARTA BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1657-hg-jakarta-brown.png', ARRAY['/images/products/rockstar_premium/1657-hg-jakarta-brown.png'], v_specs),
    ('1646 - HG | GLASGOW TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1646-hg-glasgow-teak.png', ARRAY['/images/products/rockstar_premium/1646-hg-glasgow-teak.png'], v_specs),
    ('1660 - HG | EXOTIC IVORY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1660-hg-exotic-ivory.png', ARRAY['/images/products/rockstar_premium/1660-hg-exotic-ivory.png'], v_specs),
    ('1661 - HG | SAPPHIRE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1661-hg-sapphire-walnut.png', ARRAY['/images/products/rockstar_premium/1661-hg-sapphire-walnut.png'], v_specs),
    ('1630 - HG | SUNRISE PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1630-hg-sunrise-pine.png', ARRAY['/images/products/rockstar_premium/1630-hg-sunrise-pine.png'], v_specs),
    ('1633 - HG | BROWN SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1633-hg-brown-spruce.png', ARRAY['/images/products/rockstar_premium/1633-hg-brown-spruce.png'], v_specs),
    ('1663 - HG | CHERRY WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1663-hg-cherry-wood.png', ARRAY['/images/products/rockstar_premium/1663-hg-cherry-wood.png'], v_specs),
    ('1664 - HG | BRUSH TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1664-hg-brush-teak.png', ARRAY['/images/products/rockstar_premium/1664-hg-brush-teak.png'], v_specs),
    ('1643 - HG | VANCOUVER WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-hg-vancouver-wood.png', ARRAY['/images/products/rockstar_premium/1643-hg-vancouver-wood.png'], v_specs),
    ('1665 - HG | CHERRY TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1665-hg-cherry-teak.png', ARRAY['/images/products/rockstar_premium/1665-hg-cherry-teak.png'], v_specs),
    ('1626 - HG | EXOTIC BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1626-hg-exotic-brown.png', ARRAY['/images/products/rockstar_premium/1626-hg-exotic-brown.png'], v_specs),
    ('HG-1627 / DARK ALPINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/hg-1627-dark-alpine.png', ARRAY['/images/products/rockstar_premium/hg-1627-dark-alpine.png'], v_specs),
    ('1628 - HG | LIGHT ALPINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1628-hg-light-alpine.png', ARRAY['/images/products/rockstar_premium/1628-hg-light-alpine.png'], v_specs),
    ('1648 - HG | REDMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1648-hg-redmond-glee.png', ARRAY['/images/products/rockstar_premium/1648-hg-redmond-glee.png'], v_specs),
    ('1652 - HG | DARKENED MAPLE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1652-hg-darkened-maple.png', ARRAY['/images/products/rockstar_premium/1652-hg-darkened-maple.png'], v_specs),
    ('1631 - HG | NEVADA PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1631-hg-nevada-pine.png', ARRAY['/images/products/rockstar_premium/1631-hg-nevada-pine.png'], v_specs),
    ('1708 - HG | SYNC WOOD DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1708-hg-sync-wood-dark.png', ARRAY['/images/products/rockstar_premium/1708-hg-sync-wood-dark.png'], v_specs),
    ('1709 - HG | SYNC WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1709-hg-sync-wood.png', ARRAY['/images/products/rockstar_premium/1709-hg-sync-wood.png'], v_specs),
    ('1677 - HG | TOUGH YEW 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1677-hg-tough-yew-2.png', ARRAY['/images/products/rockstar_premium/1677-hg-tough-yew-2.png'], v_specs),
    ('1678 - HG | GREEN MERANTI 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1678-hg-green-meranti-2.png', ARRAY['/images/products/rockstar_premium/1678-hg-green-meranti-2.png'], v_specs),
    ('1642 - HG(HZ) | VERMONT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1642-hg-hz-vermont-wood.png', ARRAY['/images/products/rockstar_premium/1642-hg-hz-vermont-wood.png'], v_specs),
    ('1644 - HG(HZ) | VENICE WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1644-hg-hz-venice-wood.png', ARRAY['/images/products/rockstar_premium/1644-hg-hz-venice-wood.png'], v_specs),
    ('1705 - HG(HZ) | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1705-hg-hz-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1705-hg-hz-sunshine-spruce.png'], v_specs),
    ('1643 - HG(HZ) | VANCOUVER WOOD 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-hg-hz-vancouver-wood-2.png', ARRAY['/images/products/rockstar_premium/1643-hg-hz-vancouver-wood-2.png'], v_specs),
    ('1637 - HG(HZ) | PRESTON LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1637-hg-hz-preston-light.png', ARRAY['/images/products/rockstar_premium/1637-hg-hz-preston-light.png'], v_specs),
    ('1636 - HG(HZ) | PRESTON DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1636-hg-hz-preston-dark.png', ARRAY['/images/products/rockstar_premium/1636-hg-hz-preston-dark.png'], v_specs),
    ('503 - HG SPK | OFF WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/503-hg-spk-off-white.png', ARRAY['/images/products/rockstar_premium/503-hg-spk-off-white.png'], v_specs),
    ('504 - HG SPK | DARK GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/504-hg-spk-dark-grey.png', ARRAY['/images/products/rockstar_premium/504-hg-spk-dark-grey.png'], v_specs),
    ('1672 - GV | CACAO WALNUT 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1672-gv-cacao-walnut-2.png', ARRAY['/images/products/rockstar_premium/1672-gv-cacao-walnut-2.png'], v_specs);
END $$;