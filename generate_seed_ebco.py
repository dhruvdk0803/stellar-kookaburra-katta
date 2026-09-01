# -*- coding: utf-8 -*-
"""
generate_seed_ebco.py — Ebco Digital Locks batch (September 2026), v2.

v2 fixes vs the first attempt:
- The sheet is multi-row-per-product: the first row of each block holds LABELS
  (Item / Item Code / Size / Finish) and the real values live in the following
  rows. v1 read the label row as values ("Item": "Item"). v2 parses blocks.
- Keeps every description line (column C), not just the first.
- Captures real item codes + finishes, including the second model row of
  dual-model products (CR02|CR03, IM07|IM08, IM05|IM06, IM01|IM02).
- Drops the dead local file:/// PDF links and the tracking-junk YouTube URLs
  (video kept as a clean https://youtu.be/<id> spec).
- Flattens multi-line spec values with " - " (the site renders spec values as
  plain text; newlines would collapse together).
- Keeps the owner's Special Mention notes (column M).
- Photos are copied with hyphenated names (ebco-1a.jpg), matching the repo
  image convention; the old spaced copies in the repo are removed.

Source : upload/xlsx_rows.json (lossless dump of Ebco Digital Locks SeptemberBatch.xlsx)
Photos : Ebco Digital Lock Photos SeptemberBatch/  (ebco N[a-e].jpg/png, N = product row)
Output : repo/seed_ebco_digital_locks_2026_09.sql  (paste into Supabase SQL editor)
"""
import json
import os
import re
import shutil
import time

ROOT = r"D:\Work Data\Claude Agents\Katta Interiors"
REPO = os.path.join(ROOT, "repo")
OUT = os.path.join(REPO, "seed_ebco_digital_locks_2026_09.sql")
ROWS = os.path.join(ROOT, "upload", "xlsx_rows.json")
PHOTOS = os.path.join(ROOT, "Ebco Digital Lock Photos SeptemberBatch")
IMG_DIR = os.path.join(REPO, "public", "images", "ebco")

SOURCE_TAG = "ebco-digital-locks-september-2026"

SQ = lambda s: "'" + s.replace("'", "''") + "'"
JQ = lambda o: "'" + json.dumps(o, ensure_ascii=False).replace("'", "''") + "'::jsonb"

# I/J "Additional Information" fields worth showing on the product page.
# Dropped on purpose: Brand (we set it), Manufacturer, Address, Customer
# Support, Item Quantity / Net Quantity (always 1), Dimensions in cm (duplicate
# of the mm figures) and the local fitting-instruction PDFs (dead links).
KEEP_ADDINFO = {
    "Country of Origin": "Country of Origin",
    "Item Weight (in kg)": "Item Weight",
    "Material": "Material",
    "Package Contents": "Package Contents",
    "Warranty Details": "Warranty",
}


def flat(s):
    """Collapse newlines to ' - ' (spec values render as plain text on the site)."""
    parts = [p.strip().replace("Plam", "Palm") for p in s.split("\n") if p.strip()]
    return " - ".join(parts)


def parse_blocks():
    """Group the sheet rows into product blocks. A row with column A set starts one."""
    rows = json.load(open(ROWS, encoding="utf-8"))
    products = []
    cur = None
    for row in rows:
        c = row.get("cells", {})
        if c.get("A"):
            cur = {
                "num": int(float(c["A"])),
                "name": c.get("B", "").strip(),
                "price": c.get("L", "").strip(),
                "video": c.get("K", "").strip(),
                "desc": [],
                "notes": [],
                "models": [],
                "specs": {},
                "addinfo": {},
            }
            products.append(cur)
        if cur is None:
            continue
        if c.get("C", "").strip():
            cur["desc"].append(c["C"].strip())
        if c.get("M", "").strip():
            cur["notes"].append(c["M"].strip().replace("assisstance", "assistance"))
        d = c.get("D", "").strip()
        e = c.get("E", "").strip()
        g = c.get("G", "").strip()
        if g and d and e and d != "Item":
            # model row: D = model name, E = item code, G = finish
            cur["models"].append((d, e, g))
        elif d and d not in ("", ".", "Item") and e:
            # spec label -> value row (Users, Door Thickness, Backset, ...)
            cur["specs"][d] = flat(e)
        i = c.get("I", "").strip()
        j = c.get("J", "").strip()
        if i and j and i in KEEP_ADDINFO:
            cur["addinfo"][KEEP_ADDINFO[i]] = j
    return products


def photo_files(num):
    """[(suffix, source_name, repo_name)] for product row N, sorted a..z."""
    found = []
    for fn in os.listdir(PHOTOS):
        m = re.match(r"^ebco (\d+)([a-z])\.(\w+)$", fn)
        if m and int(m.group(1)) == num:
            found.append((m.group(2), fn, "ebco-%d%s.%s" % (num, m.group(2), m.group(3))))
    return sorted(found)


def build_specs(p):
    s = {"Brand": "Ebco", "Category": "Digital Locks"}
    if p["models"]:
        s["Item Code"] = " / ".join(code for _, code, _ in p["models"])
        fins = []
        for _, _, f in p["models"]:
            if f not in fins:
                fins.append(f)
        s["Finish"] = " / ".join(fins)
    for k, v in p["specs"].items():
        s[k] = v
    for k, v in p["addinfo"].items():
        s[k] = v
    m = re.search(r"v=([A-Za-z0-9_-]{6,})", p["video"])
    if m:
        s["Demo Video"] = "https://youtu.be/" + m.group(1)
    s["GST"] = "18%"
    if p["notes"]:
        s["Special Notes"] = " - ".join(p["notes"])
    s["Source"] = SOURCE_TAG
    return s


def main():
    t0 = time.time()
    products = parse_blocks()
    print("parsed products: %d" % len(products))
    if len(products) != 13:
        raise SystemExit("FATAL: expected 13 products, got %d" % len(products))

    os.makedirs(IMG_DIR, exist_ok=True)
    # remove the spaced-name copies from the v1 run, if any
    for fn in os.listdir(IMG_DIR):
        if re.match(r"^ebco \d+[a-z]\.\w+$", fn):
            os.remove(os.path.join(IMG_DIR, fn))

    val_lines = []
    report = []
    for p in products:
        if not p["name"] or not p["price"]:
            raise SystemExit("FATAL: product %r missing name/price" % p)
        photos = photo_files(p["num"])
        if not photos:
            raise SystemExit("FATAL: no photos for product %d (%s)" % (p["num"], p["name"]))
        for _, src, dst in photos:
            shutil.copy2(os.path.join(PHOTOS, src), os.path.join(IMG_DIR, dst))
        rels = ["/images/ebco/" + dst for _, _, dst in photos]

        price = float(p["price"])
        price = int(price) if price == int(price) else price
        desc = "\n".join(p["desc"])
        specs = build_specs(p)

        val_lines.append(
            "  (%s, %s, %s, %s, ARRAY[%s], %s, NULL, v_ebco, 100, true)"
            % (
                SQ(p["name"]),
                SQ(desc),
                price,
                SQ(rels[0]),
                ", ".join(SQ(r) for r in rels),
                JQ(specs),
            )
        )
        report.append((p["num"], p["name"], price, p["models"], specs))

    header = (
        "-- Ebco Digital Locks (September 2026) - from owner-provided Excel + Google-Drive photos.\n"
        "-- %d products inserted; each row carries its full photo gallery in images TEXT[].\n"
        "-- Images are in /public/images/ebco/ - deploy with the frontend.\n"
        "-- Safe to re-run: rows are tagged with Source='%s'\n"
        "-- and deleted before re-insert.\n\n"
        "ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;\n\n"
        "DO $$\n"
        "DECLARE\n"
        "  v_parent UUID;\n"
        "  v_ebco UUID;\n"
        "BEGIN\n"
        "  SELECT id INTO v_parent FROM categories WHERE slug='ebco' OR lower(name)='ebco' LIMIT 1;\n"
        "  IF v_parent IS NULL THEN\n"
        "    INSERT INTO categories (name, slug) VALUES ('Ebco','ebco') RETURNING id INTO v_parent;\n"
        "  END IF;\n"
        "  SELECT id INTO v_ebco FROM categories WHERE parent_id=v_parent AND name='Digital Locks' LIMIT 1;\n"
        "  IF v_ebco IS NULL THEN\n"
        "    INSERT INTO categories (name, slug, parent_id) VALUES ('Digital Locks', 'ebco-digital-locks', v_parent) RETURNING id INTO v_ebco;\n"
        "  END IF;\n\n"
        "  -- Remove rows from any earlier run of this script, then re-insert.\n"
        "  DELETE FROM products WHERE specs->>'Source' = '%s';\n\n"
        "  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES\n"
    ) % (len(products), SOURCE_TAG, SOURCE_TAG)
    body = ",\n".join(val_lines) + ";"
    footer = "\nEND $$;\n"

    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(header + body + footer)

    print("\nDONE in %.1fs -> %s (%.0f KB)" % (time.time() - t0, OUT, os.path.getsize(OUT) / 1024.0))
    for num, name, price, models, specs in report:
        codes = " / ".join(c for _, c, _ in models)
        print("  %2d. %-38s Rs%-7d %s" % (num, name[:38], price, codes))
        print("      specs: %s" % ", ".join(specs.keys()))


if __name__ == "__main__":
    main()
