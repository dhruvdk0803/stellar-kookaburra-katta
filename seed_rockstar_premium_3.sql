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
    ('1638 - VO | GOLD BARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1638-vo-gold-bark.png', ARRAY['/images/products/rockstar_premium/1638-vo-gold-bark.png'], v_specs),
    ('1653 - VO | UMBER OAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1653-vo-umber-oak.png', ARRAY['/images/products/rockstar_premium/1653-vo-umber-oak.png'], v_specs),
    ('1672 - VO | CACAO WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1672-vo-cacao-walnut.png', ARRAY['/images/products/rockstar_premium/1672-vo-cacao-walnut.png'], v_specs),
    ('1633 - VO | BROWN SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1633-vo-brown-spruce.png', ARRAY['/images/products/rockstar_premium/1633-vo-brown-spruce.png'], v_specs),
    ('1679 - VO | CARAMEL PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1679-vo-caramel-pine.png', ARRAY['/images/products/rockstar_premium/1679-vo-caramel-pine.png'], v_specs),
    ('1676 - VO | KITAMI TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1676-vo-kitami-teak.png', ARRAY['/images/products/rockstar_premium/1676-vo-kitami-teak.png'], v_specs),
    ('1640 - VO | COFFEE BARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1640-vo-coffee-bark.png', ARRAY['/images/products/rockstar_premium/1640-vo-coffee-bark.png'], v_specs),
    ('1642 - OK(HZ) | VERMONT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1642-ok-hz-vermont-wood.png', ARRAY['/images/products/rockstar_premium/1642-ok-hz-vermont-wood.png'], v_specs),
    ('1672 - OK(HZ) | CACAO WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1672-ok-hz-cacao-walnut.png', ARRAY['/images/products/rockstar_premium/1672-ok-hz-cacao-walnut.png'], v_specs),
    ('1640 - OK(HZ) | COFFEE BARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1640-ok-hz-coffee-bark.png', ARRAY['/images/products/rockstar_premium/1640-ok-hz-coffee-bark.png'], v_specs),
    ('1634 - OK(HZ) | WHITE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1634-ok-hz-white-spruce.png', ARRAY['/images/products/rockstar_premium/1634-ok-hz-white-spruce.png'], v_specs),
    ('1625 - OK(HZ) | BRUNETTE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1625-ok-hz-brunette-walnut.png', ARRAY['/images/products/rockstar_premium/1625-ok-hz-brunette-walnut.png'], v_specs),
    ('1705 - OK(HZ) | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1705-ok-hz-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1705-ok-hz-sunshine-spruce.png'], v_specs),
    ('1625 - CD | BRUNETTE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1625-cd-brunette-walnut.png', ARRAY['/images/products/rockstar_premium/1625-cd-brunette-walnut.png'], v_specs),
    ('1651 - CD | BROWN BRISBANE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1651-cd-brown-brisbane.png', ARRAY['/images/products/rockstar_premium/1651-cd-brown-brisbane.png'], v_specs),
    ('1690 - CD | ALMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1690-cd-almond-glee.png', ARRAY['/images/products/rockstar_premium/1690-cd-almond-glee.png'], v_specs),
    ('1643 - CD | VANCOUVER WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-cd-vancouver-wood.png', ARRAY['/images/products/rockstar_premium/1643-cd-vancouver-wood.png'], v_specs),
    ('1673 - CD | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1673-cd-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1673-cd-sunshine-spruce.png'], v_specs),
    ('1679 - AK | CARAMEL PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1679-ak-caramel-pine.png', ARRAY['/images/products/rockstar_premium/1679-ak-caramel-pine.png'], v_specs),
    ('1688 - AK | ROSSINI EICHE BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1688-ak-rossini-eiche-brown.png', ARRAY['/images/products/rockstar_premium/1688-ak-rossini-eiche-brown.png'], v_specs),
    ('1630 - AK | SUNRISE PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1630-ak-sunrise-pine.png', ARRAY['/images/products/rockstar_premium/1630-ak-sunrise-pine.png'], v_specs),
    ('1647 - AK | BLACK BRUEN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1647-ak-black-bruen.png', ARRAY['/images/products/rockstar_premium/1647-ak-black-bruen.png'], v_specs),
    ('1646 - AK | GLASGOW TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1646-ak-glasgow-teak.png', ARRAY['/images/products/rockstar_premium/1646-ak-glasgow-teak.png'], v_specs),
    ('1643 - OAK(HZ) | VANCOUVER WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-oak-hz-vancouver-wood.png', ARRAY['/images/products/rockstar_premium/1643-oak-hz-vancouver-wood.png'], v_specs),
    ('1690 - OAK(HZ) | ALMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1690-oak-hz-almond-glee.png', ARRAY['/images/products/rockstar_premium/1690-oak-hz-almond-glee.png'], v_specs),
    ('1650 - OAK(HZ) | RICHMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1650-oak-hz-richmond-glee.png', ARRAY['/images/products/rockstar_premium/1650-oak-hz-richmond-glee.png'], v_specs),
    ('1648 - OAK(HZ) | REDMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1648-oak-hz-redmond-glee.png', ARRAY['/images/products/rockstar_premium/1648-oak-hz-redmond-glee.png'], v_specs),
    ('1705 - OAK(HZ) | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1705-oak-hz-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1705-oak-hz-sunshine-spruce.png'], v_specs),
    ('1634 - FN | WHITE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1634-fn-white-spruce.png', ARRAY['/images/products/rockstar_premium/1634-fn-white-spruce.png'], v_specs),
    ('1651 - FN | BROWN BRISBANE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1651-fn-brown-brisbane.png', ARRAY['/images/products/rockstar_premium/1651-fn-brown-brisbane.png'], v_specs),
    ('1643 - FN | VANCOUVER WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-fn-vancouver-wood.png', ARRAY['/images/products/rockstar_premium/1643-fn-vancouver-wood.png'], v_specs),
    ('1625 - FN | BRUNETTE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1625-fn-brunette-walnut.png', ARRAY['/images/products/rockstar_premium/1625-fn-brunette-walnut.png'], v_specs),
    ('1673 - FN | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1673-fn-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1673-fn-sunshine-spruce.png'], v_specs),
    ('1690 - LS | ALMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1690-ls-almond-glee.png', ARRAY['/images/products/rockstar_premium/1690-ls-almond-glee.png'], v_specs),
    ('1643 - LS | VANCOUVER WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-ls-vancouver-wood.png', ARRAY['/images/products/rockstar_premium/1643-ls-vancouver-wood.png'], v_specs),
    ('1019 - LS | WINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1019-ls-wine.png', ARRAY['/images/products/rockstar_premium/1019-ls-wine.png'], v_specs),
    ('1022 - LS | LITE BEIGE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1022-ls-lite-beige.png', ARRAY['/images/products/rockstar_premium/1022-ls-lite-beige.png'], v_specs),
    ('1006 - LS | DARK GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1006-ls-dark-grey.png', ARRAY['/images/products/rockstar_premium/1006-ls-dark-grey.png'], v_specs),
    ('1007 - LS | LIGHT GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1007-ls-light-grey.png', ARRAY['/images/products/rockstar_premium/1007-ls-light-grey.png'], v_specs),
    ('1642 - CV | VERMONT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1642-cv-vermont-wood.png', ARRAY['/images/products/rockstar_premium/1642-cv-vermont-wood.png'], v_specs),
    ('1632 - CV | DAKOTA PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1632-cv-dakota-pine.png', ARRAY['/images/products/rockstar_premium/1632-cv-dakota-pine.png'], v_specs),
    ('1708 - CV | SYNC WOOD DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1708-cv-sync-wood-dark.png', ARRAY['/images/products/rockstar_premium/1708-cv-sync-wood-dark.png'], v_specs),
    ('1690 - CV | ALMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1690-cv-almond-glee.png', ARRAY['/images/products/rockstar_premium/1690-cv-almond-glee.png'], v_specs),
    ('1673 - CV | SUNSHINE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1673-cv-sunshine-spruce.png', ARRAY['/images/products/rockstar_premium/1673-cv-sunshine-spruce.png'], v_specs),
    ('1635 - CV | BLACK SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1635-cv-black-spruce.png', ARRAY['/images/products/rockstar_premium/1635-cv-black-spruce.png'], v_specs),
    ('1019 - GL | WINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1019-gl-wine.png', ARRAY['/images/products/rockstar_premium/1019-gl-wine.png'], v_specs),
    ('1002 - GL | OFF WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1002-gl-off-white.png', ARRAY['/images/products/rockstar_premium/1002-gl-off-white.png'], v_specs),
    ('1625 - GL | BRUNETTE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1625-gl-brunette-walnut.png', ARRAY['/images/products/rockstar_premium/1625-gl-brunette-walnut.png'], v_specs),
    ('1632 - GL | DAKOTA PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1632-gl-dakota-pine.png', ARRAY['/images/products/rockstar_premium/1632-gl-dakota-pine.png'], v_specs),
    ('1708 - GL | SYNC WOOD DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1708-gl-sync-wood-dark.png', ARRAY['/images/products/rockstar_premium/1708-gl-sync-wood-dark.png'], v_specs),
    ('1713 - SF | NOGALLINO LIGHT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1713-sf-nogallino-light.png', ARRAY['/images/products/rockstar_premium/1713-sf-nogallino-light.png'], v_specs),
    ('1714 - SF | NOGALLINO DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1714-sf-nogallino-dark.png', ARRAY['/images/products/rockstar_premium/1714-sf-nogallino-dark.png'], v_specs),
    ('1717 - SF | CROSS LINE LIGHT WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1717-sf-cross-line-light-wood.png', ARRAY['/images/products/rockstar_premium/1717-sf-cross-line-light-wood.png'], v_specs),
    ('1718 - SF | CROSS LINE DARK WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1718-sf-cross-line-dark-wood.png', ARRAY['/images/products/rockstar_premium/1718-sf-cross-line-dark-wood.png'], v_specs),
    ('1708 - SF | SYNC WOOD DARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1708-sf-sync-wood-dark.png', ARRAY['/images/products/rockstar_premium/1708-sf-sync-wood-dark.png'], v_specs),
    ('1709 - SF | SYNC WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1709-sf-sync-wood.png', ARRAY['/images/products/rockstar_premium/1709-sf-sync-wood.png'], v_specs),
    ('1690 - SF | ALMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1690-sf-almond-glee.png', ARRAY['/images/products/rockstar_premium/1690-sf-almond-glee.png'], v_specs),
    ('1679 - SF | CARAMEL PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1679-sf-caramel-pine.png', ARRAY['/images/products/rockstar_premium/1679-sf-caramel-pine.png'], v_specs),
    ('1627 - SF | DARK ALPINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1627-sf-dark-alpine.png', ARRAY['/images/products/rockstar_premium/1627-sf-dark-alpine.png'], v_specs),
    ('1643 - SF | VANCOUVER WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-sf-vancouver-wood.png', ARRAY['/images/products/rockstar_premium/1643-sf-vancouver-wood.png'], v_specs),
    ('1628 - SF | LIGHT ALPINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1628-sf-light-alpine.png', ARRAY['/images/products/rockstar_premium/1628-sf-light-alpine.png'], v_specs),
    ('1645 - SF | CHOCO BARK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1645-sf-choco-bark.png', ARRAY['/images/products/rockstar_premium/1645-sf-choco-bark.png'], v_specs),
    ('1651 - SF | MAJESTIC REDWOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1651-sf-majestic-redwood.png', ARRAY['/images/products/rockstar_premium/1651-sf-majestic-redwood.png'], v_specs),
    ('1644 - SF | MAJESTIC BLACKWOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1644-sf-majestic-blackwood.png', ARRAY['/images/products/rockstar_premium/1644-sf-majestic-blackwood.png'], v_specs),
    ('1660 - SF | EXOTIC IVORY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1660-sf-exotic-ivory.png', ARRAY['/images/products/rockstar_premium/1660-sf-exotic-ivory.png'], v_specs),
    ('1657 - SF | JAKARTA BROWN', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1657-sf-jakarta-brown.png', ARRAY['/images/products/rockstar_premium/1657-sf-jakarta-brown.png'], v_specs),
    ('1643 - SF | VANCOUVER WOOD 2', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1643-sf-vancouver-wood-2.png', ARRAY['/images/products/rockstar_premium/1643-sf-vancouver-wood-2.png'], v_specs),
    ('1646 - SF | GLASGOW TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1646-sf-glasgow-teak.png', ARRAY['/images/products/rockstar_premium/1646-sf-glasgow-teak.png'], v_specs),
    ('1630 - SF | SUNRISE PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1630-sf-sunrise-pine.png', ARRAY['/images/products/rockstar_premium/1630-sf-sunrise-pine.png'], v_specs),
    ('1634 - SF | WHITE SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1634-sf-white-spruce.png', ARRAY['/images/products/rockstar_premium/1634-sf-white-spruce.png'], v_specs),
    ('1659 - SF | MOCHOA', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1659-sf-mochoa.png', ARRAY['/images/products/rockstar_premium/1659-sf-mochoa.png'], v_specs),
    ('1633 - SF | BROWN SPRUCE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1633-sf-brown-spruce.png', ARRAY['/images/products/rockstar_premium/1633-sf-brown-spruce.png'], v_specs),
    ('1631 - SF | NEVADA PINE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1631-sf-nevada-pine.png', ARRAY['/images/products/rockstar_premium/1631-sf-nevada-pine.png'], v_specs),
    ('1648 - SF | REDMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1648-sf-redmond-glee.png', ARRAY['/images/products/rockstar_premium/1648-sf-redmond-glee.png'], v_specs),
    ('1661 - SF | SAPPHIRE WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1661-sf-sapphire-walnut.png', ARRAY['/images/products/rockstar_premium/1661-sf-sapphire-walnut.png'], v_specs),
    ('1665 - SF | CHERRY TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1665-sf-cherry-teak.png', ARRAY['/images/products/rockstar_premium/1665-sf-cherry-teak.png'], v_specs),
    ('1662 - SF | DRIFT WALNUT', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1662-sf-drift-walnut.png', ARRAY['/images/products/rockstar_premium/1662-sf-drift-walnut.png'], v_specs),
    ('1650 - SF | RICHMOND GLEE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1650-sf-richmond-glee.png', ARRAY['/images/products/rockstar_premium/1650-sf-richmond-glee.png'], v_specs),
    ('1663 - SF | CHERRY WOOD', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1663-sf-cherry-wood.png', ARRAY['/images/products/rockstar_premium/1663-sf-cherry-wood.png'], v_specs),
    ('1652 - SF | DARKENED MAPLE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1652-sf-darkened-maple.png', ARRAY['/images/products/rockstar_premium/1652-sf-darkened-maple.png'], v_specs),
    ('1664 - SF | BRUSH TEAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1664-sf-brush-teak.png', ARRAY['/images/products/rockstar_premium/1664-sf-brush-teak.png'], v_specs),
    ('1653 - SF | UMBER OAK', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1653-sf-umber-oak.png', ARRAY['/images/products/rockstar_premium/1653-sf-umber-oak.png'], v_specs),
    ('1001 - SF | WHITE', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1001-sf-white.png', ARRAY['/images/products/rockstar_premium/1001-sf-white.png'], v_specs),
    ('1006 - SF | DARK GREY', v_desc, 1200, v_category_id, 100, true, '/images/products/rockstar_premium/1006-sf-dark-grey.png', ARRAY['/images/products/rockstar_premium/1006-sf-dark-grey.png'], v_specs);
END $$;