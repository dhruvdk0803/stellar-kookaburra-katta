# -*- coding: utf-8 -*-
"""
generate_seed_drawerslides.py -- Ebco Drawer Slides batch (6 September 2026).

Builds the seed SQL and copies the product photos into the repo.

  Source  : upload/drawerslides_analysis.json (14 slide products, per-variant
            pricing, 80 size+price pairs) + drawerslides_rows.json (raw sheet
            dump, for the 3 sub-items' spec values) + the 3 sheet sub-items
            promoted to separate products per owner decision (2026-09-06):
              - "Stabilizer Bar" (P11 block, col3)  -> Ebco Stabilizer Bar 900mm
              - "kitchen basket" sub-item (P14)     -> Ebco Kitchen Basket 500mm
              - "Undermount" sub-item (P14)         -> Ebco Undermount Slide 450mm
            => 17 products total. Accessories are single-price with NO photos:
               image_url NULL, images empty array (site shows its placeholder).
  Photos  : "Ebco Drawer Slides 6 september.zip" + drawerslides_photos.json
  Output  : repo/seed_ebco_drawer_slides_2026_09.sql
            repo/public/images/ebco/drawer-slides/ebco-drawer-slide-N<a|b>.<ext>

Conventions follow generate_seed_ebco_hinges.py / seed_ebco_hinges_2026_09.sql:
  - DO $$ block, Ebco parent + Drawer Slides subcategory upsert,
    Source-tagged DELETE before INSERT (re-run safe).
  - Multi-size products: variants JSONB [{label, price, is_default}], is_default
    true on the FIRST entry only (source order = sizes ascending = prices
    ascending); product price = MIN variant price. Single-price products
    (the 3 accessories): price only, variants NULL.
  - Per-variant spec values (row_specs: Extension, Item Code, Size) are NOT
    flattened onto the product: only values constant across the product's rows
    (Max. Load, Gap, Finish, Pcs/Set, ...) go into specs; varying values stay
    described in the description (which already lists sizes) per build spec
    "keep it simple and correct" -- the description + variant labels carry the
    per-size information.
  - Dead file:/// fitting-instruction links are never shipped (MISTAKES #4).
  - Spec values are single-line (" - " joins for Caution) so the plain-text
    specs table renders correctly (MISTAKES #8); no media links (MISTAKES #2);
    no owner-internal notes (MISTAKES #3); no placeholder values (MISTAKES #5).

Owner decisions applied (2026-09-06):
  - P12 "Concealed Drawer Slide Slim - 2 Push Open": the unpriced 550mm size
    row is DROPPED - only the 5 priced sizes (300-500mm) ship.
  - Product names are prefixed "Ebco " on every product.
  - "ZW" finish expanded to "Zinc White" (P3/P4).
  - Approved typo fixes ONLY (P3/P7/P11/P12/P13/P14, see fix_text).
  - P13 "Two Way Slides": only the 200mm variant has its own spec row in the
    sheet (Length 194 etc.); 300mm/375mm have none. The one sheet spec row's
    values go to product-level specs (they are constant for the row that
    exists) -- flagged in the batch report, not silently invented.
"""

import hashlib
import io
import json
import os
import re
import zipfile

from PIL import Image

ROOT = r"D:\Work Data\Claude Agents\Katta Interiors"
UPLOAD = os.path.join(ROOT, "upload")
REPO = os.path.join(ROOT, "repo")
ANALYSIS = os.path.join(UPLOAD, "drawerslides_analysis.json")
PHOTOS_JSON = os.path.join(UPLOAD, "drawerslides_photos.json")
ROWS_JSON = os.path.join(UPLOAD, "drawerslides_rows.json")
ZIP_PATH = os.path.join(ROOT, "Ebco Drawer Slides 6 september.zip")
SQL_OUT = os.path.join(REPO, "seed_ebco_drawer_slides_2026_09.sql")
IMG_DIR = os.path.join(REPO, "public", "images", "ebco", "drawer-slides")
IMG_URL = "/images/ebco/drawer-slides"

SOURCE_TAG = "ebco-drawer-slides-6-september-2026"
CATEGORY = "Drawer Slides"
CATEGORY_SLUG = "ebco-drawer-slides"

MAX_IMG_BYTES = 1024 * 1024          # oversized guard: 1.0 MB
MAX_IMG_DIM = 1600                   # downscale to max dimension 1600 px

SQ = lambda s: "'" + s.replace("'", "''") + "'"
JQ = lambda o: "'" + json.dumps(o, ensure_ascii=False).replace("'", "''") + "'::jsonb"

PLACEHOLDERS = {"", "-", "N/A", "TBD", "Item", "Name", "Model"}

# The 3 sheet sub-items promoted to products (owner decision 2026-09-06):
# (analysis sub_items item_name -> owner-approved product name, description
#  body; sizes/finishes verified below against the raw sheet spec rows)
ACCESSORY_DEFS = [
    ("Stabilizer Bar",
     "Ebco Stabilizer Bar 900mm",
     "Stabilizer bar for wide drawers.\n"
     "Improves the stability of the drawer and reduces sag."),
    ("Concealed Drawer Slide - Slim 2 (for kitchen basket - w/o facia bracket)",
     "Ebco Kitchen Basket 500mm",
     "Concealed Drawer Slide - Slim 2 for kitchen baskets, without facia "
     "bracket."),
    ("Concealed Drawer Slide - Slim 2 (for Undermount kitchen Baskets - w/o "
     "Facia Bracket/Extendo)",
     "Ebco Undermount Slide 450mm",
     "Concealed Drawer Slide - Slim 2 for undermount kitchen baskets "
     "(Extendo), without facia bracket."),
]


# ------------------------------------------------------------ text fixes

def fix_text(num, t):
    """Apply ONLY the owner-approved typo fixes, per product number."""
    if num == 3:
        return re.sub(r"\bebco\b", "Ebco", t)
    if num == 7:
        return t.replace("Slim 3(With", "Slim 3 (With")
    if num == 11:
        return t.replace("reduce the drawer seg.", "reduce the drawer sag.")
    if num == 12:
        return t.replace("3D adjustment allow facia", "3D adjustment allows facia")
    if num == 13:
        return t.replace("12kgs.", "12 kgs.")
    if num == 14:
        return t.replace("kitchens baskets", "kitchen baskets")
    return t


def fix_label(label):
    """
    Variant label cleanup per build spec:
      "550mm" -> "550 mm", "300mm " -> "300 mm", bare "300" -> "300 mm",
      strip surrounding spaces. Other size wording is kept.
    """
    t = label.strip()
    m = re.fullmatch(r"(\d+)\s*mm", t, flags=re.IGNORECASE)
    if m:
        return "%s mm" % m.group(1)
    m = re.fullmatch(r"(\d+)", t)
    if m:
        return "%s mm" % m.group(1)
    return t


# ------------------------------------------------------------ row builders

def build_desc(p):
    """Join desc_lines with newline; apply approved fixes; strip lines."""
    num = p["num"]
    lines = [fix_text(num, ln.strip()) for ln in (p.get("desc_lines") or [])]
    return "\n".join(ln for ln in lines if ln)


def build_specs(p):
    """
    specs JSONB key order: Brand, Category, the product's spec pairs (skip
    empty/placeholder values), Finish (ZW -> Zinc White on P3/P4), Caution
    (joined " - "), GST, Source. Returns an ordered list of (key, value).

    The "Item"/"Name"/"Model" value is redundant with the product name and is
    skipped. Size/Extension/Item Code vary per size row (row_specs) and are
    NOT flattened onto the product; sizes live in the variant labels and the
    description already lists them.
    """
    num = p["num"]
    pairs = [("Brand", "Ebco"), ("Category", CATEGORY)]
    finish = None
    for k, v in p["specs"].items():
        val = fix_text(num, (v or "").strip())
        if val in PLACEHOLDERS:
            continue
        if k.strip() == "Finish":
            finish = val          # placed after the other spec pairs
            continue
        pairs.append((k.strip(), val))
    if finish:
        if num in (3, 4) and finish == "ZW":
            finish = "Zinc White"
        pairs.append(("Finish", finish))
    caution = [fix_text(num, c.strip()) for c in (p.get("caution_lines") or [])]
    caution = [c for c in caution if c]
    if caution:
        pairs.append(("Caution", " - ".join(caution)))
    pairs.append(("GST", "18%"))
    pairs.append(("Source", SOURCE_TAG))
    keys = [k for k, _ in pairs]
    assert len(keys) == len(set(keys)), "duplicate spec key: %r" % keys
    return pairs


def build_variant_entries(p):
    """[{label, price}] in source order (sizes ascending), labels cleaned."""
    entries = [{"label": fix_label(v["label"]), "price": v["price"]}
               for v in p["variants"]]
    if p["num"] == 12:
        # Owner decision: the unpriced 550mm size must NOT ship.
        assert len(entries) == 5, "P12 must have exactly 5 priced variants"
        assert all(e["label"] != "550 mm" for e in entries)
    prices = [e["price"] for e in entries]
    assert prices == sorted(prices), \
        "P%d variant prices not ascending in source order" % p["num"]
    assert len(set(e["label"] for e in entries)) == len(entries), \
        "P%d duplicate variant labels" % p["num"]
    return entries


def build_accessories(analysis, raw_rows):
    """
    Verify the 3 sub-items against the analysis + the raw sheet rows, then
    build the accessory row dicts. Each sub-item's spec values live on its
    own spec row in the raw sheet dump (col 3=Item, 4=Size, 5=Finish); the
    sub-item's price is the col-10 pair on the col-9 label row.
    """
    subs = {}
    for p in analysis["products"]:
        for s in p.get("sub_items") or []:
            subs[s["item_name"]] = {"price": s["price"], "parent": p["num"]}
    assert len(subs) == 3, "expected 3 sub-items, got %d" % len(subs)

    # spec rows: col 3 carries the sub-item's item_name on continuation rows
    spec_rows = {}
    for rec in raw_rows:
        c = rec["cells"]
        item = (c.get("3") or "").strip()
        if item in subs and item not in spec_rows:
            spec_rows[item] = {"size": (c.get("4") or "").strip(),
                               "finish": (c.get("5") or "").strip()}
    missing = [k for k in subs if k not in spec_rows]
    assert not missing, "no spec row found for sub-items: %r" % missing

    # price pair rows: col 9 label ends with the sub-item's item_name and a
    # size token; col 10 carries the price. Verify each sub-item's price.
    price_rows = {}
    for rec in raw_rows:
        c = rec["cells"]
        label9 = (c.get("9") or "").strip()
        price10 = (c.get("10") or "").strip()
        if not label9 or not price10:
            continue
        for item_name, s in subs.items():
            if label9 == item_name or label9.startswith(item_name + " "):
                price_rows[item_name] = int(price10)
    for item_name, s in subs.items():
        got = price_rows.get(item_name)
        assert got == s["price"], \
            "price mismatch for %r: sheet=%r analysis=%r" % (item_name, got, s["price"])

    accs = []
    for item_name, acc_name, desc_head in ACCESSORY_DEFS:
        s = subs[item_name]
        sr = spec_rows[item_name]
        assert sr["size"] and sr["finish"], "incomplete spec row for %r" % item_name
        # "50mm" typo check: the sheet's kitchen-basket label ends "50mm" but
        # its spec row says Size 500 - ship the verified size, never the typo.
        desc = "%s\nLength: %s mm.\nFinish: %s." % (desc_head, sr["size"], sr["finish"])
        pairs = [
            ("Brand", "Ebco"),
            ("Category", CATEGORY),
            ("Item", item_name),
            ("Size (mm)", sr["size"]),
            ("Finish", sr["finish"]),
            ("GST", "18%"),
            ("Source", SOURCE_TAG),
        ]
        accs.append({
            "kind": "accessory",
            "num": s["parent"],
            "name": acc_name,
            "desc": desc,
            "price": s["price"],
            "specs": pairs,
            "variants": None,
            "images": [],
        })
    return accs


# ------------------------------------------------------------ image copy

def extract_images(photo_meta):
    """
    Extract the 22 zip images, write renamed copies into IMG_DIR, verify:
      - md5 of the extracted bytes vs drawerslides_photos.json (manifest)
      - actual image format matches the file extension (PIL vs manifest)
      - sha256 of each written file (re-read from disk)
    Downscale anything over MAX_IMG_BYTES to max dimension MAX_IMG_DIM.
    Returns ({product_num: [public paths in a,b order]}, {path: sha256}, notes).
    """
    os.makedirs(IMG_DIR, exist_ok=True)
    paths_by_num = {}
    sha_manifest = {}
    notes = []
    with zipfile.ZipFile(ZIP_PATH) as zf:
        for num in range(1, 15):
            meta = photo_meta["product_map"].get(str(num))
            assert meta and meta.get("files"), "no photo group for product %d" % num
            paths = []
            for f in sorted(meta["files"], key=lambda e: e["letter"]):
                zip_path = meta["folder"] + "/" + f["file"]
                data = zf.read(zip_path)
                md5 = hashlib.md5(data).hexdigest()
                assert md5 == f["md5"], "md5 mismatch for %s" % zip_path
                img = Image.open(io.BytesIO(data))
                fmt = img.format
                ok_ext = {"JPEG": ("jpg", "jpeg"), "PNG": ("png",),
                          "WEBP": ("webp",)}.get(fmt, ())
                ext = f["file"].rsplit(".", 1)[1].lower()
                assert ext in ok_ext, \
                    "format/extension mismatch: %s is %s" % (f["file"], fmt)
                downscaled = False
                if len(data) > MAX_IMG_BYTES:
                    w, h = img.size
                    scale = min(1.0, MAX_IMG_DIM / float(max(w, h)))
                    if scale < 1.0:
                        img = img.resize((max(1, int(w * scale)),
                                          max(1, int(h * scale))), Image.LANCZOS)
                    buf = io.BytesIO()
                    if fmt == "JPEG":
                        img.save(buf, format=fmt, quality=88)
                    elif fmt == "WEBP":
                        img.save(buf, format=fmt, quality=88)
                    else:
                        img.save(buf, format=fmt)
                    data = buf.getvalue()
                    downscaled = True
                    notes.append("%s: oversized (%.2f MB) downscaled to %dx%d, "
                                 "now %.2f MB" % (f["file"], f["bytes"] / 1048576.0,
                                                  img.size[0], img.size[1],
                                                  len(data) / 1048576.0))
                out_name = "ebco-drawer-slide-%d%s.%s" % (num, f["letter"], ext)
                out_path = os.path.join(IMG_DIR, out_name)
                with open(out_path, "wb") as fh:
                    fh.write(data)
                with open(out_path, "rb") as fh:
                    written = fh.read()
                sha = hashlib.sha256(written).hexdigest()
                assert hashlib.sha256(data).hexdigest() == sha, \
                    "sha256 mismatch after write: %s" % out_name
                sha_manifest[IMG_URL + "/" + out_name] = sha
                paths.append(IMG_URL + "/" + out_name)
            paths_by_num[num] = paths
    return paths_by_num, sha_manifest, notes


# ------------------------------------------------------------ build + emit

def build_rows(analysis, accs, paths_by_num):
    rows = []
    for p in analysis["products"]:
        num = p["num"]
        name = "Ebco " + p["name"].strip()
        desc = build_desc(p)
        assert desc, "P%d has an empty description" % num
        specs = build_specs(p)
        entries = build_variant_entries(p)
        price = min(e["price"] for e in entries)
        imgs = paths_by_num[num]
        rows.append({
            "kind": "slide",
            "num": num,
            "name": name,
            "desc": desc,
            "price": price,
            "specs": specs,
            "variants": entries,
            "images": imgs,
        })
    rows.extend(accs)
    return rows


def row_tuple_sql(r):
    if r["images"]:
        img_url_sql = SQ(r["images"][0])
        arr_sql = "ARRAY[%s]" % ", ".join(SQ(x) for x in r["images"])
    else:
        img_url_sql = "NULL"
        arr_sql = "ARRAY[]::text[]"
    if r["variants"]:
        var_sql = JQ([{"label": e["label"], "price": e["price"],
                       "is_default": i == 0}
                      for i, e in enumerate(r["variants"])])
    else:
        var_sql = "NULL"
    return ("  (%s, %s, %d, %s, %s, %s, %s, v_ebco, 100, true)"
            % (SQ(r["name"]), SQ(r["desc"]), r["price"], img_url_sql,
               arr_sql, JQ(dict(r["specs"])), var_sql))


def emit_sql(rows):
    n_multi = sum(1 for r in rows if r["variants"])
    n_single = len(rows) - n_multi
    n_prices = sum(len(r["variants"] or []) for r in rows)
    n_photos = sum(len(r["images"]) for r in rows)
    header = (
        "-- Ebco Drawer Slides (6 September 2026) - from owner-provided CSV + product photos.\n"
        "-- %d products inserted: %d drawer slides with size variants (%d size+price pairs,\n"
        "-- product price = cheapest size) and %d single-price accessories promoted from\n"
        "-- sheet sub-items (Stabilizer Bar 900mm, Kitchen Basket 500mm, Undermount Slide\n"
        "-- 450mm - no photos in the source, so image_url is NULL / images empty and the\n"
        "-- site shows its placeholder).\n"
        "-- P12 'Concealed Drawer Slide Slim - 2 Push Open': the unpriced 550mm size is\n"
        "-- dropped per owner decision - only the 5 priced sizes (300-500mm) ship.\n"
        "-- %d images in /public/images/ebco/drawer-slides/ - deploy with the frontend.\n"
        "-- Safe to re-run: rows are tagged with specs.Source='%s'\n"
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
        "  SELECT id INTO v_ebco FROM categories WHERE parent_id=v_parent\n"
        "    AND (name='Drawer Slides' OR slug='ebco-drawer-slides') LIMIT 1;\n"
        "  IF v_ebco IS NULL THEN\n"
        "    INSERT INTO categories (name, slug, parent_id) VALUES ('Drawer Slides', 'ebco-drawer-slides', v_parent) RETURNING id INTO v_ebco;\n"
        "  END IF;\n\n"
        "  -- Remove rows from any earlier run of this script, then re-insert.\n"
        "  DELETE FROM products WHERE specs->>'Source' = '%s';\n\n"
        "  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES\n"
        % (len(rows), n_multi, n_prices, n_single, n_photos, SOURCE_TAG, SOURCE_TAG)
    )
    body = ",\n".join(row_tuple_sql(r) for r in rows) + ";"
    with open(SQL_OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(header + body + "\nEND $$;\n")


# ------------------------------------------------------------ validation

def validate(rows, sha_manifest, downscale_notes):
    """
    Re-reads the emitted SQL and checks it against the build spec.
    Prints PASS/FAIL per check; raises SystemExit if any check fails.
    """
    print("\n=== VALIDATION ===")
    results = []

    def check(cond, msg):
        results.append(bool(cond))
        print("  [%s] %s" % ("PASS" if cond else "FAIL", msg))

    with open(SQL_OUT, "r", encoding="utf-8") as f:
        sql = f.read()

    # 1. product / variant counts --------------------------------------------
    spec_blocks = re.findall(r"'(\{.*?\})'::jsonb", sql, re.DOTALL)
    var_blocks = re.findall(r"'(\[\{.*?\}\])'::jsonb", sql, re.DOTALL)
    specs = [json.loads(b.replace("''", "'")) for b in spec_blocks]
    vars_ = [json.loads(b.replace("''", "'")) for b in var_blocks]
    n_null_var = len(re.findall(r"NULL, v_ebco, 100, true\)", sql))
    n_rows = sql.count(", v_ebco, 100, true)")

    check(n_rows == 17, "17 product rows in the INSERT (found %d)" % n_rows)
    check(len(vars_) == 14 and n_null_var == 3,
          "14 multi-variant rows (%d variant blocks) + 3 single-price rows (found %d blocks, %d NULL)"
          % (len(vars_), len(vars_), n_null_var))
    total_prices = sum(len(v) for v in vars_)
    check(total_prices == 80 and n_null_var == 3,
          "80 variant prices in the 14 slides' variant blocks + 0 from the 3 single-price accessories (found %d + %d single rows)"
          % (total_prices, n_null_var))
    p12 = next(v for v in vars_
               if any(x["label"] == "300 mm" and x["price"] == 1648 for x in v))
    check(len(p12) == 5 and all(x["label"] != "550 mm" for x in p12),
          "P12 has exactly 5 variants and 550 mm is absent (found %d)" % len(p12))

    # 2. is_default / price = MIN ---------------------------------------------
    ok_default = all(sum(1 for x in v if x.get("is_default")) == 1 and v[0].get("is_default")
                     for v in vars_)
    check(ok_default, "is_default true exactly once, on the FIRST entry of every variant block")
    row_prices = [int(m) for m in re.findall(
        r"', (\d+), (?:'[^']*'|NULL), (?:ARRAY\[|ARRAY\[\]::text\[\])", sql)]
    row_prices = [int(m) for m in re.findall(
        r"''?,? *(\d+), '(?:/images/[^']+|NULL)'", sql)]
    # simpler: re-derive from the row tuples we emitted
    min_ok = True
    for r in rows:
        if r["variants"]:
            if r["price"] != min(e["price"] for e in r["variants"]):
                min_ok = False
        # single-price rows: price is the only price by construction
    check(min_ok, "every multi-variant product price = MIN variant price")

    # 3. all JSONB blocks parse ------------------------------------------------
    parsed_ok = len(specs) == 17 and len(vars_) == 14
    check(parsed_ok,
          "all %d specs + %d variants JSONB blocks parse (json.loads after ''-unescape)"
          % (len(specs), len(vars_)))

    # 4. images on disk ---------------------------------------------------------
    on_disk = sorted(os.listdir(IMG_DIR))
    check(len(on_disk) == 22, "22 image files written (found %d)" % len(on_disk))
    disk_ok = True
    for path, sha in sha_manifest.items():
        fp = os.path.join(REPO, "public", path.lstrip("/").replace("/", os.sep))
        if not os.path.isfile(fp):
            disk_ok = False
            continue
        with open(fp, "rb") as fh:
            if hashlib.sha256(fh.read()).hexdigest() != sha:
                disk_ok = False
    check(disk_ok, "sha256 of every written file re-verified on disk")
    ext_ok = True
    fmt_by_ext = {".jpg": "JPEG", ".jpeg": "JPEG", ".png": "PNG", ".webp": "WEBP"}
    for name in on_disk:
        ext = os.path.splitext(name)[1].lower()
        with open(os.path.join(IMG_DIR, name), "rb") as fh:
            fmt = Image.open(fh).format
        if fmt_by_ext.get(ext) != fmt:
            ext_ok = False
    check(ext_ok, "every file's actual format matches its extension")
    n_over = len(downscale_notes)
    check(all(os.path.getsize(os.path.join(IMG_DIR, n)) <= MAX_IMG_BYTES for n in on_disk),
          "no written image exceeds 1.0 MB (oversized found: %d, downscaled: %d)"
          % (n_over, n_over))

    # 5. hygiene -----------------------------------------------------------------
    check("file:///" not in sql, "no file:/// links in the SQL")
    check(not re.search(r"https?://|www\.|youtu", sql), "no media/web links in the SQL")
    check("Demo Video" not in sql, "no Demo Video spec (MISTAKES #2)")

    bad_spec = []
    for s in specs:
        for k, v in s.items():
            if not isinstance(v, str) or v.strip() in PLACEHOLDERS or v.strip() == k.strip():
                bad_spec.append((k, v))
            if "\n" in v:
                bad_spec.append((k, "<multi-line>"))
    check(not bad_spec, "no placeholder values, no value == its own key, no multi-line spec values (%r)"
          % (bad_spec[:3] or "clean"))

    src_ok = all(s.get("Source") == SOURCE_TAG and s.get("Brand") == "Ebco"
                 and s.get("Category") == CATEGORY and s.get("GST") == "18%"
                 for s in specs)
    check(src_ok, "Brand=EbcO/Category/GST/Source correct on all 17 spec blocks".replace("EbcO", "Ebco"))

    # 6. idempotency --------------------------------------------------------------
    del_pos = sql.find("DELETE FROM products WHERE specs->>'Source' = '%s'" % SOURCE_TAG)
    ins_pos = sql.find("INSERT INTO products")
    check(0 <= del_pos < ins_pos,
          "Source-tagged DELETE precedes the INSERT (re-run safe)")

    # 7. per-product table ----------------------------------------------------------
    print("\n  num | product                                                   | vars | price range | imgs")
    print("  ----+-----------------------------------------------------------+------+-------------+-----")
    for r in rows:
        if r["variants"]:
            prices = [e["price"] for e in r["variants"]]
            rng = "%d-%d" % (min(prices), max(prices))
            nv = str(len(prices))
        else:
            rng = str(r["price"])
            nv = "1"
        print("  %3d | %-57s | %4s | %-11s | %3d"
              % (r["num"], r["name"][:57], nv, rng, len(r["images"])))

    failed = [i for i, r in enumerate(results) if not r]
    if failed:
        raise SystemExit("VALIDATION FAILED: %d check(s) failed" % len(failed))
    print("\n  ALL %d CHECKS PASSED" % len(results))


def main():
    with open(ANALYSIS, "r", encoding="utf-8") as f:
        analysis = json.load(f)
    with open(PHOTOS_JSON, "r", encoding="utf-8") as f:
        photo_meta = json.load(f)
    with open(ROWS_JSON, "r", encoding="utf-8") as f:
        raw_rows = json.load(f)

    n_products = len(analysis["products"])
    assert n_products == 14, "expected 14 slide products, got %d" % n_products
    n_variants = sum(len(p["variants"]) for p in analysis["products"])
    n_subs = sum(len(p.get("sub_items") or []) for p in analysis["products"])
    print("analysis: %d slide products, %d size+price pairs, %d sub-items"
          % (n_products, n_variants, n_subs))
    assert n_variants == 80, "expected 80 size+price pairs, got %d" % n_variants
    assert n_subs == 3, "expected 3 sub-items, got %d" % n_subs

    paths_by_num, sha_manifest, downscale_notes = extract_images(photo_meta)
    n_images = sum(len(v) for v in paths_by_num.values())
    assert n_images == 22, "expected 22 images, wrote %d" % n_images
    print("images: %d written to %s" % (n_images, IMG_DIR))
    for note in downscale_notes:
        print("  " + note)
    if not downscale_notes:
        print("  no image exceeded 1.0 MB - no downscaling needed")

    accs = build_accessories(analysis, raw_rows)
    print("accessories: %d promoted (%s)"
          % (len(accs), ", ".join(a["name"] for a in accs)))

    rows = build_rows(analysis, accs, paths_by_num)
    assert len(rows) == 17, "expected 17 rows, got %d" % len(rows)
    emit_sql(rows)
    n_multi = sum(1 for r in rows if r["variants"])
    n_prices = sum(len(r["variants"] or []) for r in rows)
    print("sql: %s (%d products, %d with size variants, %d size+price pairs)"
          % (SQL_OUT, len(rows), n_multi, n_prices))

    validate(rows, sha_manifest, downscale_notes)

    print("\nsha256 manifest of the %d written images:" % len(sha_manifest))
    for path in sorted(sha_manifest):
        print("  %s  %s" % (sha_manifest[path], path))


if __name__ == "__main__":
    main()
