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
    ('505 - HG SPK | BLACK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/505-hg-spk-black.png', ARRAY['/images/products/rockstar_premium/505-hg-spk-black.png'], v_specs),
    ('506 - HG SPK | WINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/506-hg-spk-wine.png', ARRAY['/images/products/rockstar_premium/506-hg-spk-wine.png'], v_specs),
    ('1001 - HG | WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1001-hg-white.png', ARRAY['/images/products/rockstar_premium/1001-hg-white.png'], v_specs),
    ('1002 - HG | OFF WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1002-hg-off-white.png', ARRAY['/images/products/rockstar_premium/1002-hg-off-white.png'], v_specs),
    ('1007 - HG | LIGHT GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1007-hg-light-grey.png', ARRAY['/images/products/rockstar_premium/1007-hg-light-grey.png'], v_specs),
    ('1006 - HG | DARK GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1006-hg-dark-grey.png', ARRAY['/images/products/rockstar_premium/1006-hg-dark-grey.png'], v_specs),
    ('1011 - HG | BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1011-hg-beige.png', ARRAY['/images/products/rockstar_premium/1011-hg-beige.png'], v_specs),
    ('1022 - HG | LITE BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1022-hg-lite-beige.png', ARRAY['/images/products/rockstar_premium/1022-hg-lite-beige.png'], v_specs),
    ('1023 - HG | DOVE GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1023-hg-dove-grey.png', ARRAY['/images/products/rockstar_premium/1023-hg-dove-grey.png'], v_specs),
    ('1009 - HG | BLACK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1009-hg-black.png', ARRAY['/images/products/rockstar_premium/1009-hg-black.png'], v_specs),
    ('1013 - HG | COFFEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1013-hg-coffee.png', ARRAY['/images/products/rockstar_premium/1013-hg-coffee.png'], v_specs),
    ('1019 - HG | WINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1019-hg-wine.png', ARRAY['/images/products/rockstar_premium/1019-hg-wine.png'], v_specs),
    ('1021 - HG | ORANGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1021-hg-orange.png', ARRAY['/images/products/rockstar_premium/1021-hg-orange.png'], v_specs),
    ('1026 - HG | BLUE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1026-hg-blue.png', ARRAY['/images/products/rockstar_premium/1026-hg-blue.png'], v_specs),
    ('1003 - HG | GREEN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1003-hg-green.png', ARRAY['/images/products/rockstar_premium/1003-hg-green.png'], v_specs),
    ('1008 - HG | RED', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1008-hg-red.png', ARRAY['/images/products/rockstar_premium/1008-hg-red.png'], v_specs),
    ('1012 - HG | PINK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1012-hg-pink.png', ARRAY['/images/products/rockstar_premium/1012-hg-pink.png'], v_specs),
    ('1010 - HG | YELLOW', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1010-hg-yellow.png', ARRAY['/images/products/rockstar_premium/1010-hg-yellow.png'], v_specs),
    ('1675 - GV | MUSTARD PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1675-gv-mustard-pine.png', ARRAY['/images/products/rockstar_premium/1675-gv-mustard-pine.png'], v_specs),
    ('1674 - GV | BROWN PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1674-gv-brown-pine.png', ARRAY['/images/products/rockstar_premium/1674-gv-brown-pine.png'], v_specs),
    ('1676 - GV | DARK BROWN PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1676-gv-dark-brown-pine.png', ARRAY['/images/products/rockstar_premium/1676-gv-dark-brown-pine.png'], v_specs),
    ('1671 - GV | BRATTY OAK DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1671-gv-bratty-oak-dark.png', ARRAY['/images/products/rockstar_premium/1671-gv-bratty-oak-dark.png'], v_specs),
    ('1673 - GV | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1673-gv-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1673-gv-sunshine-spruce.png'], v_specs),
    ('1028 - GV | GAUNTLET GREY 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1028-gv-gauntlet-grey-2.png', ARRAY['/images/products/rockstar_premium/1028-gv-gauntlet-grey-2.png'], v_specs),
    ('1029 - GV | ICE BLUE 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1029-gv-ice-blue-2.png', ARRAY['/images/products/rockstar_premium/1029-gv-ice-blue-2.png'], v_specs),
    ('1018 - ST | SANDRIFT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1018-st-sandrift.png', ARRAY['/images/products/rockstar_premium/1018-st-sandrift.png'], v_specs),
    ('1025 - ST | PEANUT BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1025-st-peanut-beige.png', ARRAY['/images/products/rockstar_premium/1025-st-peanut-beige.png'], v_specs),
    ('1027 - ST | WINTER FOG', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1027-st-winter-fog.png', ARRAY['/images/products/rockstar_premium/1027-st-winter-fog.png'], v_specs),
    ('1024 - ST | PISTA GREEN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1024-st-pista-green.png', ARRAY['/images/products/rockstar_premium/1024-st-pista-green.png'], v_specs),
    ('1680 - ST | GALAXY CARRARA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1680-st-galaxy-carrara.png', ARRAY['/images/products/rockstar_premium/1680-st-galaxy-carrara.png'], v_specs),
    ('1684 - ST | ALISEO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1684-st-aliseo.png', ARRAY['/images/products/rockstar_premium/1684-st-aliseo.png'], v_specs),
    ('1619 - ST | BLACK TRAVERTINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1619-st-black-travertine.png', ARRAY['/images/products/rockstar_premium/1619-st-black-travertine.png'], v_specs),
    ('1682 - ST | ROYAL VENETINO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1682-st-royal-venetino.png', ARRAY['/images/products/rockstar_premium/1682-st-royal-venetino.png'], v_specs),
    ('1616 - ST | GOLD TRAVERTINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1616-st-gold-travertine.png', ARRAY['/images/products/rockstar_premium/1616-st-gold-travertine.png'], v_specs),
    ('1617 - ST | EMERALD CARRARA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1617-st-emerald-carrara.png', ARRAY['/images/products/rockstar_premium/1617-st-emerald-carrara.png'], v_specs),
    ('1646 - BM | GLASGOW TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1646-bm-glasgow-teak.png', ARRAY['/images/products/rockstar_premium/1646-bm-glasgow-teak.png', '/images/products/rockstar_premium/1646-bm-glasgow-teak-room.png'], v_specs),
    ('1686 - BM | BRATTY OAK GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1686-bm-bratty-oak-grey.png', ARRAY['/images/products/rockstar_premium/1686-bm-bratty-oak-grey.png'], v_specs),
    ('1676 - BM | KITAMI TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1676-bm-kitami-teak.png', ARRAY['/images/products/rockstar_premium/1676-bm-kitami-teak.png'], v_specs),
    ('1683 - BM | NORWEGIAN TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1683-bm-norwegian-teak.png', ARRAY['/images/products/rockstar_premium/1683-bm-norwegian-teak.png'], v_specs),
    ('1671 - BM | BRATTY OAK DARK 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1671-bm-bratty-oak-dark-2.png', ARRAY['/images/products/rockstar_premium/1671-bm-bratty-oak-dark-2.png'], v_specs),
    ('1001 - SMT | WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1001-smt-white.png', ARRAY['/images/products/rockstar_premium/1001-smt-white.png'], v_specs),
    ('1022 - SMT | LITE BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1022-smt-lite-beige.png', ARRAY['/images/products/rockstar_premium/1022-smt-lite-beige.png'], v_specs),
    ('1006 - SMT | DARK GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1006-smt-dark-grey.png', ARRAY['/images/products/rockstar_premium/1006-smt-dark-grey.png'], v_specs),
    ('1023 - SMT | DOVE GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1023-smt-dove-grey.png', ARRAY['/images/products/rockstar_premium/1023-smt-dove-grey.png'], v_specs),
    ('1671 - BM | BRATTY OAK DARK 3', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1671-bm-bratty-oak-dark-3.png', ARRAY['/images/products/rockstar_premium/1671-bm-bratty-oak-dark-3.png'], v_specs),
    ('1688 - BM | ROSSINI EICHE BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1688-bm-rossini-eiche-brown.png', ARRAY['/images/products/rockstar_premium/1688-bm-rossini-eiche-brown.png'], v_specs),
    ('1719 - SMT | ETERNITY LIGHT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1719-smt-eternity-light-wood.png', ARRAY['/images/products/rockstar_premium/1719-smt-eternity-light-wood.png'], v_specs),
    ('1720 - SMT | ETERNITY DARK WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1720-smt-eternity-dark-wood.png', ARRAY['/images/products/rockstar_premium/1720-smt-eternity-dark-wood.png'], v_specs),
    ('1627 - SMT | DARK ALPINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1627-smt-dark-alpine.png', ARRAY['/images/products/rockstar_premium/1627-smt-dark-alpine.png'], v_specs),
    ('1628 - SMT | LIGHT ALPINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1628-smt-light-alpine.png', ARRAY['/images/products/rockstar_premium/1628-smt-light-alpine.png'], v_specs),
    ('1674 - SMT | BROWN PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1674-smt-brown-pine.png', ARRAY['/images/products/rockstar_premium/1674-smt-brown-pine.png'], v_specs),
    ('1675 - SMT | MUSTARD PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1675-smt-mustard-pine.png', ARRAY['/images/products/rockstar_premium/1675-smt-mustard-pine.png'], v_specs),
    ('1716 - SMT | GRETA DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1716-smt-greta-dark.png', ARRAY['/images/products/rockstar_premium/1716-smt-greta-dark.png'], v_specs),
    ('1715 - SMT | GRETA LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1715-smt-greta-light.png', ARRAY['/images/products/rockstar_premium/1715-smt-greta-light.png'], v_specs),
    ('1622 - SMT | BREWTON BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1622-smt-brewton-brown.png', ARRAY['/images/products/rockstar_premium/1622-smt-brewton-brown.png'], v_specs),
    ('1623 - SMT | BREWTON GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1623-smt-brewton-grey.png', ARRAY['/images/products/rockstar_premium/1623-smt-brewton-grey.png'], v_specs),
    ('1620 - SMT | BONITO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1620-smt-bonito.png', ARRAY['/images/products/rockstar_premium/1620-smt-bonito.png'], v_specs),
    ('1621 - SMT | BLACK CALCUTTA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1621-smt-black-calcutta.png', ARRAY['/images/products/rockstar_premium/1621-smt-black-calcutta.png'], v_specs),
    ('1621 - SMT | BLACK CALCUTTA 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1621-smt-black-calcutta-2.png', ARRAY['/images/products/rockstar_premium/1621-smt-black-calcutta-2.png'], v_specs),
    ('1680 - SMT | GALAXY CARRARA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1680-smt-galaxy-carrara.png', ARRAY['/images/products/rockstar_premium/1680-smt-galaxy-carrara.png'], v_specs),
    ('1684 - SMT | ALISEO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1684-smt-aliseo.png', ARRAY['/images/products/rockstar_premium/1684-smt-aliseo.png'], v_specs),
    ('1682 - SMT | ROYAL VENETINO', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1682-smt-royal-venetino.png', ARRAY['/images/products/rockstar_premium/1682-smt-royal-venetino.png'], v_specs),
    ('1672 - CB | CACAO WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1672-cb-cacao-walnut.png', ARRAY['/images/products/rockstar_premium/1672-cb-cacao-walnut.png'], v_specs),
    ('1683 - CB | NORWEGIAN TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1683-cb-norwegian-teak.png', ARRAY['/images/products/rockstar_premium/1683-cb-norwegian-teak.png'], v_specs),
    ('1690 - CB | ALMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1690-cb-almond-glee.png', ARRAY['/images/products/rockstar_premium/1690-cb-almond-glee.png'], v_specs),
    ('1676 - CB | KITAMI TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1676-cb-kitami-teak.png', ARRAY['/images/products/rockstar_premium/1676-cb-kitami-teak.png'], v_specs),
    ('1625 - CB | BRUNETTE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1625-cb-brunette-walnut.png', ARRAY['/images/products/rockstar_premium/1625-cb-brunette-walnut.png'], v_specs),
    ('1685 - QC | KENDRICK BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1685-qc-kendrick-brown.png', ARRAY['/images/products/rockstar_premium/1685-qc-kendrick-brown.png'], v_specs),
    ('1679 - QC | CARAMEL PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1679-qc-caramel-pine.png', ARRAY['/images/products/rockstar_premium/1679-qc-caramel-pine.png'], v_specs),
    ('1631 - QC | NEVADA PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1631-qc-nevada-pine.png', ARRAY['/images/products/rockstar_premium/1631-qc-nevada-pine.png'], v_specs),
    ('1631 - QC | NEVADA PINE 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1631-qc-nevada-pine-2.png', ARRAY['/images/products/rockstar_premium/1631-qc-nevada-pine-2.png'], v_specs),
    ('1625 - QC | BRUNETTE WALNUT 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1625-qc-brunette-walnut-2.png', ARRAY['/images/products/rockstar_premium/1625-qc-brunette-walnut-2.png'], v_specs),
    ('1630 - QC | SUNRISE PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1630-qc-sunrise-pine.png', ARRAY['/images/products/rockstar_premium/1630-qc-sunrise-pine.png'], v_specs),
    ('1622 - LR | BREWTON BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1622-lr-brewton-brown.png', ARRAY['/images/products/rockstar_premium/1622-lr-brewton-brown.png'], v_specs),
    ('1623 - LR | BREWTON GREY LEATHER', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1623-lr-brewton-grey-leather.png', ARRAY['/images/products/rockstar_premium/1623-lr-brewton-grey-leather.png'], v_specs),
    ('1707 - LR | SYNC WOOD LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1707-lr-sync-wood-light.png', ARRAY['/images/products/rockstar_premium/1707-lr-sync-wood-light.png'], v_specs),
    ('1709 - LR | SYNC WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1709-lr-sync-wood.png', ARRAY['/images/products/rockstar_premium/1709-lr-sync-wood.png'], v_specs),
    ('1708 - LR | SYNC WOOD DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1708-lr-sync-wood-dark.png', ARRAY['/images/products/rockstar_premium/1708-lr-sync-wood-dark.png'], v_specs),
    ('1708 - CA (HZ) | SYNC WOOD DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1708-ca-hz-sync-wood-dark.png', ARRAY['/images/products/rockstar_premium/1708-ca-hz-sync-wood-dark.png'], v_specs),
    ('1637 - CA (HZ) | PERSTON LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1637-ca-hz-perston-light.png', ARRAY['/images/products/rockstar_premium/1637-ca-hz-perston-light.png'], v_specs),
    ('1636 - CA (HZ) | PRESTON DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1636-ca-hz-preston-dark.png', ARRAY['/images/products/rockstar_premium/1636-ca-hz-preston-dark.png'], v_specs),
    ('1624 - CA (HZ) | WINE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1624-ca-hz-wine-walnut.png', ARRAY['/images/products/rockstar_premium/1624-ca-hz-wine-walnut.png'], v_specs),
    ('1624 - CA (HZ) | WINE WALNUT 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1624-ca-hz-wine-walnut-2.png', ARRAY['/images/products/rockstar_premium/1624-ca-hz-wine-walnut-2.png'], v_specs);
END $$;