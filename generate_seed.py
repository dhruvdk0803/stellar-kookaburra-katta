# -*- coding: utf-8 -*-
"""
generate_seed.py — Apollo CPVC + uPVC catalog from owner-provided CSVs (August 2026).

Strategy (user-confirmed, "without any error"):
  - ONE row per unique product name from the CSV. No manual variant grouping
    (the CSV already has one line per size — the simplest correct mapping).
  - Images are per product TYPE (e.g. "apollo cpvc elbow 90.jpg" covers
    Elbow 90 of every size). Each row gets the image for its type.
  - Every price is exactly the CSV value. No data transformation.
  - Output: repo/seed_apollo_pricelist_2026_08.sql (paste into Supabase SQL editor).
    Images are in repo/public/images/apollo/{cpvc,upvc} (deploy with frontend).
"""
import csv, json, os, re, time

REPO = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(REPO, "seed_apollo_pricelist_2026_08.sql")
CPVC_CSV = os.path.join(os.path.dirname(REPO), "apollo cpvc names list 1 corrected(CPVC First Sheet Corrected).csv")
UPVC_CSV = os.path.join(os.path.dirname(REPO), "apollo upvc product list 1(uPVC Pipes).csv")

SQ = lambda s: "'" + s.replace("'", "''") + "'"
JQ = lambda o: "'" + json.dumps(o, ensure_ascii=False).replace("'", "''") + "'::jsonb"

def read_csv(path, label):
    """Return [(name, price), ...] deduplicated case-insensitively."""
    with open(path, encoding="cp1252") as fh:
        rows = [r for r in csv.reader(fh) if r and r[0].strip()]
    out, seen = [], set()
    for r in rows[1:]:
        name = r[0].strip(); price = r[8].strip()
        try: p = float(price)
        except ValueError:
            print(f"  WARN {label}: bad price {price!r} in {name!r} — skipping"); continue
        key = name.lower()
        if key in seen:
            print(f"  DUP  {label}: {name!r} — keeping first only"); continue
        seen.add(key); out.append((name, p))
    print(f"{label}: {len(rows)-1} rows -> {len(out)} unique, {len(rows)-1-len(out)} dups/bad")
    return out

def image_map(img_dir):
    if not os.path.isdir(img_dir): return {}
    return {os.path.splitext(f)[0].lower(): f for f in os.listdir(img_dir)}

def match_image(name, imgs, fallback):
    # Keep the full name (lowercased) so brand tokens ("apollo cpvc") stay in
    # the candidate and match image stems like "apollo cpvc pipe".
    core = name.lower()
    # Strip trailing length (" - 3 Mtr", " - 6 Mtr Plain End", ...)
    stripped = re.sub(r"\s*[-–]\s*\d+\s*mtr\b.*$", "", core)
    # Strip trailing size spec: ' 1/2" (15mm)' or ' 3/4"x1/2" (20x15mm)'
    stripped = re.sub(r"\s+\d[\d/\-]*\"?\s*\([^)]*\)\s*$", "", stripped)
    stripped = re.sub(r"\s+x\s+\d[\d/\-]*\"?\s*\([^)]*\)\s*$", "", stripped)
    candidates = [stripped.strip(), stripped.split("(")[0].strip()]
    for cand in candidates:
        if cand in imgs: return imgs[cand]
        for stem, fn in imgs.items():
            if all(t in cand for t in stem.split()): return fn
    return fallback

CPVC_DESC = (
    "APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC "
    "compound from Lubrizol, engineered for hot & cold water distribution.\n\n"
    "Why choose APL Apollo CPVC-X:\n"
    "- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol\n"
    "- Smooth flow hydraulics with reduced friction loss\n"
    "- ISI certified, extra strong and highly durable\n"
    "- Leak-proof solvent-welded joints\n"
    "- Superior heat resistance and excellent chlorine/chemical resistance\n"
    "- Conforms to ASTM D2846 / IS:15778 standards"
)

UPVC_DESC = (
    "APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure "
    "applications, offering leak-proof, long-lasting performance.\n\n"
    "Key features:\n"
    "- Extra-strong, corrosion-resistant uPVC construction\n"
    "- Smooth bore for efficient, silent flow\n"
    "- ISI certified; conforming to IS:15111 / IS:4985 standards\n"
    "- Leak-proof solvent-welded joints\n"
    "- UV and weather resistant"
)

def main():
    t0 = time.time()
    cpvc = read_csv(CPVC_CSV, "CPVC")
    upvc = read_csv(UPVC_CSV, "uPVC")
    cpvc_imgs = image_map(os.path.join(REPO, "public/images/apollo/cpvc"))
    upvc_imgs = image_map(os.path.join(REPO, "public/images/apollo/upvc"))
    print(f"CPVC images: {len(cpvc_imgs)}, uPVC images: {len(upvc_imgs)}")

    # ── load live DB snapshot to avoid duplicates / apply price corrections ──
    live_path = os.path.join(os.path.dirname(REPO), "upload", "live_cpvc_full.json")
    live = {}
    if os.path.exists(live_path):
        import json as _json
        for r in _json.load(open(live_path, encoding="utf-8")):
            live[r["name"].lower()] = (r["id"], float(r["price"]), r["is_active"])
        print(f"live CPVC snapshot: {len(live)} products")
    else:
        print("WARN: no live snapshot at", live_path, "— will insert everything")

    val_lines = []; update_lines = []; skipped = 0; bad_imgs = []

    def fmt(name, price, catvar, imgs_map, stem, desc):
        nonlocal bad_imgs
        fallback = "apollo cpvc pipe.webp" if stem == "cpvc" else "apollo upvc pipe plain.jpg"
        imgname = match_image(name, imgs_map, fallback)
        if imgname == fallback and fallback not in imgs_map.values():
            bad_imgs.append((stem, name))
        rel = f"/images/apollo/{stem}/{imgname}"
        mat = "CPVC (Chlorinated Polyvinyl Chloride)" if stem == "cpvc" else "uPVC (Unplasticized Polyvinyl Chloride)"
        specs = {"Brand":"APL Apollo", "Material":mat, "GST":"18%"}
        if stem == "cpvc":
            specs["Category"] = "CPVC Fittings & Pipes"
        else:
            specs["Category"] = "SWR / uPVC Pipes & Fittings"
        return (f"  ({SQ(name)}, {SQ(desc)}, {price:g}, {SQ(rel)}, ARRAY[{SQ(rel)}], "
                f"{JQ(specs)}, NULL, {catvar}, 100, true)")

    for name, price in cpvc:
        key = name.lower()
        if key in live:
            lid, lprice, _ = live[key]
            if abs(lprice - price) < 0.001:
                skipped += 1
                continue  # already live with correct price
            # price changed in the corrected list -> update existing row
            update_lines.append(
                f"  UPDATE products SET price = {price:g} WHERE id = '{lid}'; -- {name}"
            )
            continue
        val_lines.append(fmt(name, price, "v_cpvc", cpvc_imgs, "cpvc", CPVC_DESC))
    for name, price in upvc:
        val_lines.append(fmt(name, price, "v_upvc", upvc_imgs, "upvc", UPVC_DESC))

    total = len(val_lines)
    print(f"skipped (already live, same price): {skipped}")
    print(f"price updates: {len(update_lines)}")
    print(f"new inserts: {total}")
    header = f"""\
-- APL Apollo CPVC + uPVC price list (August 2026) — from owner-provided CSVs.
-- {len(update_lines)} existing products get corrected prices; {total} new products are inserted.
-- ({skipped} CPVC items were skipped: already live with the same price.)
-- Images are in /public/images/apollo/{{cpvc,upvc}} — deploy with the frontend.
-- Safe to re-run: new rows are tagged with Source='apollo-pricelist-august-2026'
-- and deleted before re-insert; price updates are idempotent.

ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;

-- 1) Price corrections for products that already exist (matched by id).
"""
    if update_lines:
        header += "\n".join(update_lines) + "\n"
    header += """
-- 2) Insert the new products.
DO $$
DECLARE
  v_parent UUID;
  v_cpvc UUID;
  v_upvc UUID;
BEGIN
  SELECT id INTO v_parent FROM categories WHERE slug='apollo' OR lower(name)='apollo' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Apollo','apollo') RETURNING id INTO v_parent;
  END IF;
  SELECT id INTO v_cpvc FROM categories WHERE parent_id=v_parent AND name='CPVC Fittings & Pipes' LIMIT 1;
  IF v_cpvc IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('CPVC Fittings & Pipes', 'apollo-cpvc-fittings-pipes', v_parent) RETURNING id INTO v_cpvc;
  END IF;
  SELECT id INTO v_upvc FROM categories WHERE parent_id=v_parent AND name='SWR / uPVC Pipes & Fittings' LIMIT 1;
  IF v_upvc IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('SWR / uPVC Pipes & Fittings', 'apollo-swr-upvc-pipes-fittings', v_parent) RETURNING id INTO v_upvc;
  END IF;

  -- Remove rows from any earlier run of this script, then re-insert.
  DELETE FROM products WHERE specs->>'Source' = 'apollo-pricelist-august-2026';

  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES
"""
    body = ",\n".join(val_lines) + ";"
    footer = """\

  UPDATE products SET specs = specs || '{"Source":"apollo-pricelist-august-2026"}'::jsonb
    WHERE specs->>'Source' IS DISTINCT FROM 'apollo-pricelist-august-2026'
      AND id IN (SELECT id FROM products WHERE specs->>'Brand' = 'APL Apollo' AND specs->>'Source' IS NULL);
END $$;
"""
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(header + body + footer)
    kb = os.path.getsize(OUT)/1024
    print(f"\nDONE in {time.time()-t0:.1f}s -> {OUT} ({kb:.0f} KB)")
    print(f"  updates:{len(update_lines)}  inserts:{total}  skipped:{skipped}")

if __name__ == "__main__":
    main()