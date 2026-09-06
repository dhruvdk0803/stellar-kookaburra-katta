# -*- coding: utf-8 -*-
"""
generate_seed_ebco_hinges.py — Ebco Hinges batch (SeptemberBatch2).

Builds the seed SQL and copies the product photos into the repo:

  Source  : upload/hinges_analysis.json   (28 products, per-variant pricing)
  Photos  : upload/hinges_photos.json -> "Ebco Hinges SeptemberBatch2/<subfolder>/<name>"
  Output  : repo/seed_ebco_hinges_2026_09.sql
            repo/public/images/ebco/hinges/ebco-hinge-<n><letter>.<ext>

Follows the conventions of generate_seed_ebco.py (Ebco Digital Locks, v2):
  - DO $$ block, parent/subcategory upsert, Source-tagged DELETE before INSERT.
  - Multi-line spec values flattened with " - " (the site renders spec values
    as plain text, so newlines would collapse together).
  - Photos copied under hyphenated names; full gallery in images TEXT[].
  - Dead local file:/// fitting-instruction PDF links (column 11) dropped
    entirely.

Hinges-specific rules:
  - Pricing is PER VARIANT. Products with exactly one variant get the price
    only (variants NULL -> no selector on the site). Multi-variant products
    get a JSONB array of {label, price, is_default}; the product price is the
    cheapest variant (what the listing cards show) and is_default marks the
    first entry.
  - Variant order = source order when that is the logical reading order
    (crank 0/8/16, door thickness 35/40/45, equal prices) and price-ascending
    otherwise. Only product 12 (Shower Hinges) needed re-sorting.
  - Glyph normalization everywhere: º ˚ ⁰ -> ° ; ⌀ -> ø ; "180 °" -> "180°" ;
    "MAx." -> "Max.". Existing ø and Ø are kept as-is.
  - Product 12 (Shower Hinges) has no description in the source; a generic
    one is generated from its variant labels.
  - Product 14's description repeats "SS 304" on consecutive lines; the
    duplicate is collapsed (only consecutive identical lines are affected).
"""
import filecmp
import json
import os
import re
import shutil
import sys
import time

ROOT = r"D:\Work Data\Claude Agents\Katta Interiors"
REPO = os.path.join(ROOT, "repo")
OUT = os.path.join(REPO, "seed_ebco_hinges_2026_09.sql")
ANALYSIS = os.path.join(ROOT, "upload", "hinges_analysis.json")
PHOTOS_JSON = os.path.join(ROOT, "upload", "hinges_photos.json")
PHOTO_ROOT = os.path.join(ROOT, "Ebco Hinges SeptemberBatch2")
IMG_DIR = os.path.join(REPO, "public", "images", "ebco", "hinges")
IMG_URL = "/images/ebco/hinges"

SOURCE_TAG = "ebco-hinges-septemberbatch2"
CATEGORY = "Hinges"
CATEGORY_SLUG = "ebco-hinges"

SQ = lambda s: "'" + s.replace("'", "''") + "'"
JQ = lambda o: "'" + json.dumps(o, ensure_ascii=False).replace("'", "''") + "'::jsonb"

# Product 12 "Shower Hinges" has no description lines in the source; its
# variant labels are: 90° Wall to Glass (T/L Type), 135°/180°/90° Glass to
# Glass, in Brushed or Polished Steel.
SHOWER_HINGES_DESC = [
    "Premium Ebco shower hinges for frameless glass shower doors and enclosures.",
    "Available in wall-to-glass (T Type and L Type) and glass-to-glass mounting "
    "configurations, with 90°, 135° and 180° opening angles.",
    "Choice of brushed steel or polished steel finish (see variants for pricing).",
    "Corrosion-resistant construction for bathroom use. Fitting instructions "
    "available on request.",
]

PHOTO_NAME_RE = re.compile(r"^ebco hinge (\d+)([a-z])\.(jpg|jpeg|png)$", re.IGNORECASE)


def glyph(s):
    """Normalize degree/diameter glyphs and the 'MAx.' typo. ø/Ø are kept."""
    if not s:
        return s
    s = s.replace("º", "°").replace("˚", "°").replace("⁰", "°")
    s = s.replace("⌀", "ø")
    s = re.sub(r"\s+°", "°", s)  # "180 °" -> "180°"
    s = s.replace("MAx.", "Max.")
    return s


def flat(s):
    """Flatten a (possibly multi-line) spec value with ' - '."""
    return " - ".join(p.strip() for p in s.split("\n") if p.strip())


def source_order_is_logical(vs):
    """Keep the analysis order for crank/thickness runs and equal prices."""
    prices = [v["price"] for v in vs]
    if all(prices[i] <= prices[i + 1] for i in range(len(prices) - 1)):
        return True  # already price-ascending (or all equal) -> identical either way
    labels = " | ".join(v["label"] for v in vs)
    return "crank" in labels or "minimum Door thickness" in labels


def ordered_variants(p):
    """[{label, price}] in display order (glyph-normalized, trimmed labels)."""
    vs = [{"label": glyph(v["label"].strip()), "price": v["price"]} for v in p["variants"]]
    if not source_order_is_logical(vs):
        vs = sorted(vs, key=lambda v: v["price"])  # stable: ties keep source order
    return vs


def build_description(p):
    lines = p.get("desc_lines") or []
    if not lines:  # product 12 only
        lines = SHOWER_HINGES_DESC
    out = []
    for line in lines:
        line = glyph(line.strip())
        if line and (not out or line != out[-1]):
            out.append(line)
    return "\n".join(out)


def build_specs(p):
    s = {"Brand": "Ebco", "Category": CATEGORY}
    raw = p.get("specs") or {}
    if (raw.get("Item Code") or "").strip():
        s["Item Code"] = glyph(raw["Item Code"].strip())
    if (raw.get("Finish") or "").strip():
        s["Finish"] = glyph(raw["Finish"].strip())
    for k, v in raw.items():
        if k in ("Item Code", "Finish"):
            continue
        val = glyph(flat(v))
        if val and val != "-":  # skip empty / "-" placeholder values
            s[glyph(k.strip())] = val
    if p.get("caution_lines"):
        s["Caution"] = glyph(" - ".join(l.strip() for l in p["caution_lines"] if l.strip()))
    # Owner decision (2026-09-03): no "Demo Video" spec — video links stay out
    # of the specs table. (YouTube URLs otherwise left unused.)
    s["GST"] = "18%"
    s["Source"] = SOURCE_TAG
    return s


def photo_entries(num, groups):
    """[(letter, src_path, repo_filename)] for product N, in letter order a..e."""
    g = groups.get(str(num))
    if not g or not g.get("files"):
        raise SystemExit("FATAL: no photo group for product %d" % num)
    entries = []
    for f in g["files"]:
        m = PHOTO_NAME_RE.match(f["name"])
        if not m or int(m.group(1)) != num:
            raise SystemExit("FATAL: unexpected photo name %r for product %d" % (f["name"], num))
        src = os.path.join(PHOTO_ROOT, f["subfolder"], f["name"])
        if not os.path.isfile(src):
            raise SystemExit("FATAL: missing source photo %s" % src)
        if os.path.getsize(src) != f.get("bytes"):
            raise SystemExit("FATAL: byte-size mismatch for %s" % src)
        entries.append((m.group(2).lower(), src, f["name"].replace(" ", "-").lower()))
    entries.sort(key=lambda e: e[0])
    return entries


def build(products, groups):
    """Returns (rows, report, copied_count)."""
    os.makedirs(IMG_DIR, exist_ok=True)
    rows, report, copied = [], [], 0
    for p in products:
        num = p["num"]
        name = glyph(p["name"].strip())
        if not name:
            raise SystemExit("FATAL: product %d has no name" % num)

        vs = ordered_variants(p)
        if not vs:
            raise SystemExit("FATAL: product %d has no variants" % num)
        for v in vs:
            if not isinstance(v["price"], (int, float)):
                raise SystemExit("FATAL: product %d variant %r has no price" % (num, v["label"]))
        if len(vs) == 1:
            price, variants_sql = vs[0]["price"], "NULL"
        else:
            price = min(v["price"] for v in vs)
            variants_sql = JQ([{"label": v["label"], "price": v["price"],
                                "is_default": i == 0} for i, v in enumerate(vs)])

        desc = build_description(p)
        if not desc:
            raise SystemExit("FATAL: product %d has an empty description" % num)
        specs = build_specs(p)

        entries = photo_entries(num, groups)
        for _, src, dst in entries:
            shutil.copy2(src, os.path.join(IMG_DIR, dst))
            copied += 1
        rels = [IMG_URL + "/" + dst for _, _, dst in entries]

        rows.append(
            "  (%s, %s, %s, %s, ARRAY[%s], %s, %s, v_ebco, 100, true)"
            % (SQ(name), SQ(desc), price, SQ(rels[0]),
               ", ".join(SQ(r) for r in rels), JQ(specs), variants_sql)
        )
        prices = [v["price"] for v in vs]
        report.append({
            "num": num, "name": name, "n": len(vs),
            "min": min(prices), "max": max(prices), "imgs": len(rels),
        })
    return rows, report, copied


def emit(products, rows, copied):
    n_multi = sum(1 for p in products if len(p["variants"]) > 1)
    n_single = len(products) - n_multi
    n_variant_prices = sum(len(p["variants"]) for p in products)
    header = (
        "-- Ebco Hinges (SeptemberBatch2) - from owner-provided CSV + product photos.\n"
        "-- %d products inserted: %d single-price (variants NULL, no selector) and %d with variant selectors.\n"
        "-- %d variant prices in the source; the product price is the cheapest variant.\n"
        "-- %d images in /public/images/ebco/hinges/ - deploy with the frontend.\n"
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
        "  SELECT id INTO v_ebco FROM categories WHERE parent_id=v_parent AND name='%s' LIMIT 1;\n"
        "  IF v_ebco IS NULL THEN\n"
        "    INSERT INTO categories (name, slug, parent_id) VALUES ('%s', '%s', v_parent) RETURNING id INTO v_ebco;\n"
        "  END IF;\n\n"
        "  -- Remove rows from any earlier run of this script, then re-insert.\n"
        "  DELETE FROM products WHERE specs->>'Source' = '%s';\n\n"
        "  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES\n"
    ) % (len(products), n_single, n_multi, n_variant_prices, copied,
         SOURCE_TAG, CATEGORY, CATEGORY, CATEGORY_SLUG, SOURCE_TAG)
    body = ",\n".join(rows) + ";"
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(header + body + "\nEND $$;\n")


def validate(products, groups):
    """Re-reads the emitted SQL and checks it against the analysis."""
    print("\n=== VALIDATION ===")
    results = []

    def check(cond, msg):
        results.append(bool(cond))
        print("  [%s] %s" % ("PASS" if cond else "FAIL", msg))

    sql = open(OUT, encoding="utf-8").read()

    # 1. row + variant counts ------------------------------------------------
    n_rows = len(re.findall(r"v_ebco, 100, true\)", sql))
    check(n_rows == 28, "28 product rows in the INSERT (found %d)" % n_rows)

    spec_blocks = re.findall(r"'(\{.*?\})'::jsonb", sql, re.DOTALL)
    # NB: anchored on [{ ... }] so the empty '[]'::jsonb of the ALTER TABLE
    # (column default) is not picked up as a variant block.
    var_blocks = re.findall(r"'(\[\{.*?\}\])'::jsonb", sql, re.DOTALL)
    n_null = len(re.findall(r"NULL, v_ebco, 100, true\)", sql))
    specs = [json.loads(b.replace("''", "'")) for b in spec_blocks]
    vars_ = [json.loads(b.replace("''", "'")) for b in var_blocks]

    total_src = sum(len(p["variants"]) for p in products)
    in_jsonb = sum(len(v) for v in vars_)
    check(len(specs) == 28, "28 specs JSONB blocks extracted and parsed (found %d)" % len(specs))
    check(len(vars_) + n_null == 28,
          "variant blocks (%d) + NULL-variant rows (%d) = 28 products" % (len(vars_), n_null))
    check(in_jsonb + n_null == total_src,
          "variant total: %d in JSONB + %d collapsed singles = %d (analysis: %d)"
          % (in_jsonb, n_null, in_jsonb + n_null, total_src))

    # 2. variant block contents ---------------------------------------------
    good = True
    for v in vars_:
        if sum(1 for x in v if x.get("is_default")) != 1:
            good = False
        if v and not v[0].get("is_default"):
            good = False
        for x in v:
            if not isinstance(x.get("label"), str) or not x["label"].strip():
                good = False
            if not isinstance(x.get("price"), (int, float)):
                good = False
    check(good, "every variant object has a label+price; is_default true exactly once, on the first entry")

    # 3. prices in the SQL vs the analysis (independent re-derivation) -------
    sql_prices = re.findall(r", (\d+(?:\.\d+)?), '(/images/ebco/hinges/[^']+)'", sql)
    check(len(sql_prices) == 28, "28 (price, image_url) pairs extracted from rows (found %d)" % len(sql_prices))
    price_ok = True
    for (got_price, _), p in zip(sql_prices, products):
        expected = min(v["price"] for v in p["variants"])
        if float(got_price) != float(expected):
            price_ok = False
            print("       price mismatch on product %d: SQL=%s expected=%s" % (p["num"], got_price, expected))
    check(price_ok, "every product price = MIN variant price (single-variant: that price)")

    # variant data round-trips the analysis (multiset of label+price)
    roundtrip = True
    vi = 0
    for p in products:
        if len(p["variants"]) > 1:
            got = sorted((x["label"], x["price"]) for x in vars_[vi])
            exp = sorted((glyph(v["label"].strip()), v["price"]) for v in p["variants"])
            if got != exp:
                roundtrip = False
                print("       variant data mismatch on product %d" % p["num"])
            vi += 1
    check(roundtrip, "every variants JSONB block matches the analysis labels+prices exactly")

    # 4. specs block contents ------------------------------------------------
    ok_specs = True
    for s in specs:
        if s.get("Source") != SOURCE_TAG or s.get("Brand") != "Ebco" \
           or s.get("Category") != CATEGORY or s.get("GST") != "18%":
            ok_specs = False
        for k, v in s.items():
            if not isinstance(v, str) or not v.strip() or v.strip() == "-" or v == k:
                ok_specs = False
                print("       bad spec %r: %r" % (k, v))
    n_demo = sum(1 for s in specs if "Demo Video" in s)
    n_caution = sum(1 for s in specs if "Caution" in s)
    check(ok_specs, "no label-as-value / placeholder '-' / empty spec values; Brand+Category+GST+Source on every row")
    check(n_demo == 0, "0 Demo Video specs - removed per owner (found %d)" % n_demo)
    check(n_caution == 8, "8 Caution specs (found %d)" % n_caution)

    # 5. names ---------------------------------------------------------------
    names = [glyph(p["name"].strip()) for p in products]
    names_ok = all(SQ(n) in sql for n in names) and len(set(names)) == 28
    check(names_ok, "all 28 product names present, unique")

    # 6. images --------------------------------------------------------------
    img_pairs = re.findall(r"'(/images/ebco/hinges/[^']+)', ARRAY\[([^\]]*)\]", sql)
    check(len(img_pairs) == 28, "28 (image_url, images[]) pairs in rows (found %d)" % len(img_pairs))
    urls, first_ok = [], True
    for url, arr in img_pairs:
        entries = re.findall(r"'([^']+)'", arr)
        if not entries or entries[0] != url:
            first_ok = False
        urls.extend(entries)
    check(first_ok, "image_url is always the first images[] entry")
    check(len(urls) == 55, "55 image URLs referenced in total (found %d)" % len(urls))
    on_disk = sorted(os.listdir(IMG_DIR))
    check(len(on_disk) == 55, "55 files under repo/public/images/ebco/hinges/ (found %d)" % len(on_disk))
    missing = [u for u in urls if not os.path.isfile(os.path.join(IMG_DIR, os.path.basename(u)))]
    check(not missing, "every referenced image path exists on disk (missing: %s)" % (missing or "none"))

    cmp_ok = True
    for num, letter in ((1, "a"), (9, "b"), (28, "a")):  # jpg, jpeg, png sample
        g = groups[str(num)]
        f = next(x for x in g["files"] if x["name"] == "ebco hinge %d%s.%s" % (num, letter, x["ext"]))
        src = os.path.join(PHOTO_ROOT, f["subfolder"], f["name"])
        dst = os.path.join(IMG_DIR, f["name"].replace(" ", "-").lower())
        if not filecmp.cmp(src, dst, shallow=False):
            cmp_ok = False
    check(cmp_ok, "byte-compare sample of 3 copied files (1a jpg, 9b jpeg, 28a png) matches sources")

    # 7. hygiene -------------------------------------------------------------
    check("file:///" not in sql, "no file:/// links in the SQL")
    check(not any(c in sql for c in ("º", "˚", "⁰", "⌀")) and "MAx." not in sql,
          "no un-normalized glyphs (º ˚ ⁰ ⌀) and no 'MAx.' left")
    check(sql.index("DELETE FROM products WHERE specs->>'Source'") < sql.index("INSERT INTO products"),
          "Source-tagged DELETE runs before the INSERT (re-run safe)")
    check(sql.count("DELETE FROM products WHERE specs->>'Source' = '%s'" % SOURCE_TAG) == 1,
          "DELETE is tagged with Source='%s'" % SOURCE_TAG)

    failed = [i for i, r in enumerate(results) if not r]
    if failed:
        raise SystemExit("VALIDATION FAILED: %d check(s) failed" % len(failed))
    print("  ALL %d CHECKS PASSED" % len(results))


def main():
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    t0 = time.time()

    analysis = json.load(open(ANALYSIS, encoding="utf-8"))
    photos = json.load(open(PHOTOS_JSON, encoding="utf-8"))
    groups = photos["groups"]
    products = analysis["products"]
    if len(products) != 28:
        raise SystemExit("FATAL: expected 28 products, got %d" % len(products))
    if photos.get("total_images") != 55:
        raise SystemExit("FATAL: expected 55 images in the inventory, got %r" % photos.get("total_images"))

    rows, report, copied = build(products, groups)
    if copied != 55:
        raise SystemExit("FATAL: expected to copy 55 images, copied %d" % copied)
    emit(products, rows, copied)
    validate(products, groups)

    print("\nDONE in %.1fs -> %s (%.1f KB), %d images copied to %s"
          % (time.time() - t0, OUT, os.path.getsize(OUT) / 1024.0, copied, IMG_DIR))
    print("\nnum | product                                          | vars | price      | imgs")
    print("----+--------------------------------------------------+------+------------+-----")
    for r in report:
        rng = str(r["min"]) if r["min"] == r["max"] else "%d-%d" % (r["min"], r["max"])
        print("%3d | %-48s | %4d | %-10s | %3d" % (r["num"], r["name"][:48], r["n"], rng, r["imgs"]))


if __name__ == "__main__":
    main()
