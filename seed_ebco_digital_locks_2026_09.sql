-- Ebco Digital Locks (September 2026) - from owner-provided Excel + Google-Drive photos.
-- 13 products inserted; each row carries its full photo gallery in images TEXT[].
-- Images are in /public/images/ebco/ - deploy with the frontend.
-- Safe to re-run: rows are tagged with Source='ebco-digital-locks-september-2026'
-- and deleted before re-insert.

ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;

DO $$
DECLARE
  v_parent UUID;
  v_ebco UUID;
BEGIN
  SELECT id INTO v_parent FROM categories WHERE slug='ebco' OR lower(name)='ebco' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Ebco','ebco') RETURNING id INTO v_parent;
  END IF;
  SELECT id INTO v_ebco FROM categories WHERE parent_id=v_parent AND name='Digital Locks' LIMIT 1;
  IF v_ebco IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Digital Locks', 'ebco-digital-locks', v_parent) RETURNING id INTO v_ebco;
  END IF;

  -- Remove rows from any earlier run of this script, then re-insert.
  DELETE FROM products WHERE specs->>'Source' = 'ebco-digital-locks-september-2026';

  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES
  ('Sync-Pro Digital Lock SP02', 'Multiple access options like fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 24930, '/images/ebco/ebco-1a.jpg', ARRAY['/images/ebco/ebco-1a.jpg', '/images/ebco/ebco-1b.jpg', '/images/ebco/ebco-1c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLSP025ASA-BL", "Finish": "Black", "Users": "General Up to 290 - Admin Up to 10 - Fingerprint Up to 100 - Password + Card Up to 200", "Door Thickness": "25-50 mm", "Backset": "28 mm", "Door Type": "Wooden Door - Aluminium Door", "Dimensions with Handle": "Internal : 387(H) X 36(W) X 61.5(D) - External : 350(H) X 36(W) X 61.5(D)", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Sync-Pro Digital Lock SP01', 'Multiple access options like fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Years Warranty.', 24930, '/images/ebco/ebco-2a.jpg', ARRAY['/images/ebco/ebco-2a.jpg', '/images/ebco/ebco-2b.jpg', '/images/ebco/ebco-2c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLSP025ASA-BL", "Finish": "Black", "Users": "General Up to 290 - Admin Up to 10 - Fingerprint Up to 100 - Password + Card Up to 200", "Door Thickness": "25-50 mm", "Backset": "28 mm", "Door Type": "Wooden Sliding Door - Aluminium Sliding Door", "Dimensions with Handle": "Internal : 387(H) X 36(W) X 61.5(D) - External : 350(H) X 36(W) X 61.5(D)", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Crest Digital Lock CR04', 'Multiple access options like fingerprint, RFID card, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 12581, '/images/ebco/ebco-3a.jpg', ARRAY['/images/ebco/ebco-3a.jpg', '/images/ebco/ebco-3b.png', '/images/ebco/ebco-3c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLCR045ASA-BL", "Finish": "Black", "Users": "General Up to 290 - Admin Up to 10 - Fingerprint Up to 100 - Password + Card Up to 200", "Door Thickness": "35-55 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 293(H) X 153.2(W) X 67.2(D) - External : 293(H) X 155.2(W) X 73(D)", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Crest Digital Lock CR02 | CR03', 'Multiple access options like fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 12121, '/images/ebco/ebco-4a.jpg', ARRAY['/images/ebco/ebco-4a.jpg', '/images/ebco/ebco-4b.jpg', '/images/ebco/ebco-4c.jpg', '/images/ebco/ebco-4d.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLCR025ASA-BL / DHDDLCR035ASA-AT", "Finish": "Black", "Users": "General Up to 290 - Admin Up to 10 - Fingerprint Up to 100 - Password + Card Up to 200", "Door Thickness": "35-55 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 293(H) X 153.2(W) X 67.2(D) - External : 293(H) X 155.2(W) X 73(D)", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Crest Digital Lock CR01', 'Multiple access options like fingerprint, RFID card, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 10100, '/images/ebco/ebco-5a.jpg', ARRAY['/images/ebco/ebco-5a.jpg', '/images/ebco/ebco-5b.jpg', '/images/ebco/ebco-5c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLCR015ASA-BL", "Finish": "Black", "Users": "Admin Up to 10 - Fingerprint Up to 100 - Password Up to 100 - Card Up to 100", "Door Thickness": "35-90 mm", "Backset": "50 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 270(H) X 63(W) X 70(D) - External : 270(H) X 63(W) X 70(D)", "Country of Origin": "Hong Kong", "Item Weight": "2.087", "Material": "ABS", "Package Contents": "Consists of lock body 1 nos, morties lock case 1 nos, key - 2 nos,cylinder-1nos, card-2 nos,fitting acc-1 pkt, user manual- 2 nos", "Warranty": "2 Year", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Regalia Digital Lock RL04', 'Multiple access options like fingerprint, RFID card, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
See who is at the door in your mobile and inside screen with the built-in camera.
Peace of mind with 2-Year Warranty', 20800, '/images/ebco/ebco-6a.jpg', ARRAY['/images/ebco/ebco-6a.jpg', '/images/ebco/ebco-6b.jpg', '/images/ebco/ebco-6c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLRL045ASA-BL", "Finish": "Black", "Users": "Admin Up to 10 - Fingerprint Up to 100 - Password Up to 100 - Card Up to 100", "Door Thickness": "35-60 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 334(H) X 153.3(W) X 64.1(D) - External : 334(H) X 153.3(W) X 64.1(D)", "Country of Origin": "Hong Kong", "Item Weight": "2.937", "Material": "ABS", "Package Contents": "Consists of lock body 1 nos, morties lock case 1 nos, key - 2 nos,cylinder-1nos, card-2 nos,fitting acc-1 pkt, user manual- 2 nos", "Warranty": "2 Years", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Regalia Digital Lock RL03', 'Multiple access options like fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 18000, '/images/ebco/ebco-7a.jpg', ARRAY['/images/ebco/ebco-7a.jpg', '/images/ebco/ebco-7b.jpg', '/images/ebco/ebco-7c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLRL035ASA-BL", "Finish": "Black", "Users": "General Up to 290 - Admin Up to 10 - Fingerprint Up to 100 - Password + Card Up to 200", "Door Thickness": "35-55 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 295(H) X 150(W) X 75.1(D) - External : 295(H) X 150(W) X 79.6(D)", "Country of Origin": "Thailand", "Item Weight": "3.058", "Material": "Metal", "Package Contents": "Consists of lock body 1 nos, morties lock case 1 nos, key - 2 nos, card-2 nos,fitting acc-1 pkt, user manual- 2 nos", "Warranty": "2 Years", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Regalia Digital Lock RL02', 'Multiple access options like fingerprint, RFID card, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 17700, '/images/ebco/ebco-8a.jpg', ARRAY['/images/ebco/ebco-8a.jpg', '/images/ebco/ebco-8b.jpg', '/images/ebco/ebco-8c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLRL025ASA-BL", "Finish": "Black", "Users": "Fingerprint Up to 100 (Admin 1 User) - Password Up to 200 (Admin 1 User) - Card Up to 100", "Door Thickness": "35-90 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 363.3(H) X 169.7(W) X 78.1(D) - External : 359(H) X 169(W) X 78.1(D)", "Country of Origin": "Hong Kong", "Item Weight": "3.814", "Material": "ABS", "Package Contents": "Consists of lock body 1 nos, mortise lock case 1 nos, key - 2 nos,cylinder-1nos, card-2 nos, fitting acc-1 pkt, user manual- 2 nos", "Warranty": "2 Years", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Regalia Digital Lock RL01', 'Multiple access options like fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Works on long-life AA Alkaline batteries, with low batter indication.
Emergency USB power port and physical key if the battery dies.
Peace of mind with 2-Year Warranty', 15150, '/images/ebco/ebco-9a.jpg', ARRAY['/images/ebco/ebco-9a.jpg', '/images/ebco/ebco-9b.jpg', '/images/ebco/ebco-9c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLRL015ASA-BL", "Finish": "Black", "Users": "General Up to 290 - Admin Up to 10 - Fingerprint Up to 100 - Password + Card Up to 200", "Door Thickness": "35-55 mm", "Backset": "50 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 260(H) X 150(W) X 75.1(D) - External : 260(H) X 150(W) X 79.6(D)", "Country of Origin": "Thailand", "Item Weight": "2.357", "Material": "Metal", "Package Contents": "Consists of lock body 1 nos, morties lock case 1 nos, key - 2 nos, card-2 nos,fitting acc-1 pkt, user manual- 2 nos", "Warranty": "2 Years", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Imperia Digital Lock IM07 | IM08', 'Multiple access options like face recognition, palm scanning, fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Reliable, long-life performance with a high-capacity, easy-to-recharge lithium battery.
Emergency USB power port and physical key if the battery dies.
See who is at the door in your mobile and inside screen with the built-in camera.
Peace of mind with 2-Year Warranty', 53198, '/images/ebco/ebco-10a.jpg', ARRAY['/images/ebco/ebco-10a.jpg', '/images/ebco/ebco-10b.jpg', '/images/ebco/ebco-10c.jpg', '/images/ebco/ebco-10d.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLIM077AFA-BL / DHDDLIM087AFA-AT", "Finish": "Black / Anthracite", "Users": "General Up to 191 - Admin Up to 9 - Fingerprint Up to 50 - Password + Card + Palm + Face Up to 150", "Door Thickness": "35-55 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 422(H) X 80(W) X 78.8(D) - External : 422(H) X 80(W) X 71.8(D)", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Imperia Digital Lock IM05 | IM06', 'Multiple access options like face recognition, palm scanning, fingerprint, NFC, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Reliable, long-life performance with a high-capacity, easy-to-recharge lithium battery.
Emergency USB power port and physical key if the battery dies.
See who is at the door in your mobile and inside screen with the built-in camera.
Peace of mind with 2-Year Warranty', 46525, '/images/ebco/ebco-11a.jpg', ARRAY['/images/ebco/ebco-11a.jpg', '/images/ebco/ebco-11b.jpg', '/images/ebco/ebco-11c.jpg', '/images/ebco/ebco-11d.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLIM057AFA-BL / DHDDLIM067AFA-AT", "Finish": "Black / Anthracite", "Users": "General Up to 191 - Admin Up to 9 - Fingerprint Up to 50 - Password + Card + Palm + Face Up to 150", "Door Thickness": "35-55 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 422(H) X 140.2(W) X 80.6(D) - External : 422(H) X 140.2(W) X 77.8(D)", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Imperia Digital Lock IM03', 'Multiple access options like face recognition, palm scanning, fingerprint, RFID card, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Reliable, long-life performance with a high-capacity, easy-to-recharge lithium battery.
Emergency USB power port and physical key if the battery dies.
See who is at the door in your mobile and inside screen with the built-in camera.
Peace of mind with 2-Year Warranty', 42000, '/images/ebco/ebco-12a.jpg', ARRAY['/images/ebco/ebco-12a.jpg', '/images/ebco/ebco-12b.jpg', '/images/ebco/ebco-12c.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLIM037AFA-BL", "Finish": "Black", "Users": "Admin Up to 10 - Fingerprint Up to 50 - Password Up to 100 - Card Up to 100 - Face + Palm Up to 50", "Door Thickness": "40-90 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 419(H) X 74(W) X 62(D) - External : 420(H) X 70(W) X 47.7(D)", "Country of Origin": "Hong Kong", "Item Weight": "4.61", "Material": "ABS", "Package Contents": "Consists of lock body 1 nos, morties lock case 1 nos, lithium batteries-1nos, cylinder-1nos, card-2 nos,keys-2 nos, Accessories package-2 nos user manual- 1 nos", "Warranty": "2 Years", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Imperia Digital Lock IM01 | IM02', 'Multiple access options like face recognition, palm scanning, fingerprint, RFID card, or a secure password.
Control your lock and get alerts from anywhere via WiFi and the mobile app.
Stay undisturbed with Privacy Mode and a loud alarm for tampering.
Reliable, long-life performance with a high-capacity, easy-to-recharge lithium battery.
Emergency USB power port and physical key if the battery dies.
See who is at the door in your mobile and inside screen with the built-in camera.
Peace of mind with 2-Year Warranty', 38100, '/images/ebco/ebco-13a.jpg', ARRAY['/images/ebco/ebco-13a.jpg', '/images/ebco/ebco-13b.jpg', '/images/ebco/ebco-13c.jpg', '/images/ebco/ebco-13d.jpg', '/images/ebco/ebco-13e.png'], '{"Brand": "Ebco", "Category": "Digital Locks", "Item Code": "DHDDLIM017AFA-BL / DHDDLIM027AFA-CR", "Finish": "Black / Copper", "Users": "Face Up to 20 - Palm Up to 20 - Card Up to 50 - Fingerprint Up to 100 - Password Up to 50", "Door Thickness": "38-120 mm", "Backset": "60 mm", "Door Type": "Wooden Door", "Dimensions with Handle": "Internal : 420(H) X 73(W) X 68(D) - External : 416(H) X 68(W) X 58(D)", "Country of Origin": "Hong Kong", "Item Weight": "4.75", "Material": "ABS", "Package Contents": "Consists of lock body 1 nos, mortise lock case 1 nos, Li-ion battery 2 nos, key - 2 nos,cylinder-1nos, card-2 nos, fitting acc-1 pkt, user manual- 2 nos", "Warranty": "2 Years", "GST": "18%", "Source": "ebco-digital-locks-september-2026"}'::jsonb, NULL, v_ebco, 100, true);
END $$;
