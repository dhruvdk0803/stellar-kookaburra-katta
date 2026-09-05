# -*- coding: utf-8 -*-
"""
generate_seed_jivanjor.py — Jivanjor Adhesives batch (5 September 2026).

Builds the seed SQL and extracts the product photos into the repo:

  Source  : upload/jivanjor_analysis.json    (12 products, per-variant pricing, 36 prices)
  Photos  : upload/jivanjor_photos.json -> "Jivanjor Adhesive/<product folder>/<one image>",
            extracted IN-MEMORY from "Jivanjor Adhesive 5 september.zip" (never unpacked to disk)
  Output  : repo/seed_jivanjor_adhesives_2026_09.sql
            repo/public/images/jivanjor/jivanjor-<product>.<ext>

Follows the conventions of generate_seed_ebco_hinges.py (Ebco Hinges, SeptemberBatch2)
and the variants JSONB shape of seed_apollo_web_additions.sql:
  - DO $$ block, parent/subcategory upsert, Source-tagged DELETE before INSERT,
    ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB.
  - Per-variant pricing: single-variant products get the price only (variants
    NULL -> no selector on the site); multi-variant products get a JSONB array
    of {label, price, is_default} in source order with is_default true on the
    first entry only, and the product price is the cheapest variant.
  - Multi-line spec values flattened with " - " (the site renders spec values
    as plain text, so newlines would collapse into a run-on line).

Owner decisions applied (2026-09-05):
  - P5 'Jivanjor Lamino Advance' shipped with empty description / tech specs /
    USP / Applications cells (the source cells said "same as lamino"). The owner
    approved copying P4 'Jivanjor Lamino' desc_lines, tech_specs, usp_lines and
    application_lines onto P5. P5 keeps its own name, variants and prices, and
    its description is byte-identical to P4's (validated below).
  - USP and Applications ARE customer-facing. Each description renders as:
    all description lines, a blank line, "Key Features:" followed by one
    "- "-prefixed line per USP, a blank line, "Applications:" followed by one
    "- "-prefixed line per Application. (The site renders the description with
    whitespace-pre-wrap, so these lists display cleanly.)
  - Owner-approved data-typo fixes in customer-facing text ONLY (nothing else
    is altered): Techonology, Formaldelhyde, "resists mositure", Specilist,
    demandsuperior, resitance, mordern, venner, Interor, contactadhesive,
    "helps resists", plus broken comma spacing ("board , MDF" -> "board, MDF").
    Deliberately NOT touched (not on the owner's list): the stray "m" in
    "wallpaper, m carpet manufacturing" (P1) and the "300 cos" viscosity
    wording (P8) — both flagged for the owner instead.
  - Variant label cleanup: trailing spaces stripped, "1liter" -> "1 liter";
    all other size wording kept exactly as the source has it.
"""
import hashlib
import json
import os
import re
import sys
import time
import zipfile
from collections import Counter

ROOT = r"D:\Work Data\Claude Agents\Katta Interiors"
REPO = os.path.join(ROOT, "repo")
OUT = os.path.join(REPO, "seed_jivanjor_adhesives_2026_09.sql")
ANALYSIS = os.path.join(ROOT, "upload", "jivanjor_analysis.json")
PHOTOS_JSON = os.path.join(ROOT, "upload", "jivanjor_photos.json")
CSV_PATH = os.path.join(ROOT, "Jivanjor Adhesive 5 September.csv")
ZIP_PATH = os.path.join(ROOT, "Jivanjor Adhesive 5 september.zip")
IMG_DIR = os.path.join(REPO, "public", "images", "jivanjor")
IMG_URL = "/images/jivanjor"

BRAND = "Jivanjor"
PARENT = "Jivanjor"
PARENT_SLUG = "jivanjor"
CATEGORY = "Adhesives"
CATEGORY_SLUG = "jivanjor-adhesives"
CAT_VAR = "v_adhesives"
SOURCE_TAG = "jivanjor-adhesives-5-september-2026"
N_PRODUCTS = 12
N_VARIANT_PRICES = 36

SQ = lambda s: "'" + s.replace("'", "''") + "'"
JQ = lambda o: "'" + json.dumps(o, ensure_ascii=False).replace("'", "''") + "'::jsonb"

# Owner-approved data typos (customer-facing text only; order matters:
# "resists mositure" must run before "helps resists").
TYPO_FIXES = [
    ("Techonology", "Technology"),
    ("Formaldelhyde", "Formaldehyde"),
    ("resists mositure", "resist moisture"),
    ("Specilist", "Specialist"),
    ("demandsuperior", "demand superior"),
    ("resitance", "resistance"),
    ("mordern", "modern"),
    ("venner", "veneer"),
    ("Interor", "Interior"),
    ("contactadhesive", "contact adhesive"),
    ("helps resists", "helps resist"),
]
TYPO_COUNTS = Counter()


def fix_typos(s):
    for bad, good in TYPO_FIXES:
        if bad in s:
            TYPO_COUNTS[bad] += s.count(bad)
            s = s.replace(bad, good)
    return s


def fix_commas(s):
    """'board , MDF' -> 'board, MDF'; 'bond,smooth' -> 'bond, smooth'."""
    s = re.sub(r"\s+,", ",", s)       # no space before a comma
    s = re.sub(r",(?=\S)", ", ", s)   # exactly one space after a comma
    return s


def fix_line(s):
    """One source text line -> shipped text (strip, typos, comma spacing)."""
    return fix_commas(fix_typos(s.strip()))


def flatten_spec(v):
    """Multi-line spec value -> single line joined with ' - ' (MISTAKES #8)."""
    return fix_commas(fix_typos(" - ".join(p.strip() for p in str(v).split("\n") if p.strip())))


def clean_label(label):
    """Trim + '1liter' -> '1 liter'; every other size wording kept verbatim."""
    s = label.strip()
    return re.sub(r"^(\d+)\s*liter$", r"\1 liter", s)


def build_description(src):
    """desc_lines + 'Key Features:' (USP lines) + 'Applications:' (application lines)."""
    descs = [fix_line(l) for l in src["desc_lines"]]
    usps = [fix_line(l) for l in src["usp_lines"]]
    apps = [fix_line(l) for l in src["application_lines"]]
    if not (descs and usps and apps):
        raise SystemExit("FATAL: empty desc/usp/application lines for %r" % src.get("name"))
    return "\n\n".join([
        "\n".join(descs),
        "Key Features:\n" + "\n".join("- " + u for u in usps),
        "Applications:\n" + "\n".join("- " + a for a in apps),
    ])


def build_specs(src):
    """Brand, Category, source tech specs, GST, Source — in exactly that order."""
    s = {"Brand": BRAND, "Category": CATEGORY}
    for k, v in src["tech_specs"].items():
        key = k.strip()
        val = flatten_spec(v)
        if not val or val == "-" or val == key:  # placeholder guard (MISTAKES #1/#5)
            raise SystemExit("FATAL: bad spec %r: %r" % (key, val))
        s[key] = val
    s["GST"] = "18%"
    s["Source"] = SOURCE_TAG
    return s


def content_sources(products):
    """num -> the product whose text/spec content ships on it.

    OWNER DECISION (2026-09-05): P5 'Jivanjor Lamino Advance' had empty shipping
    fields and 'same as lamino' placeholders; the owner approved copying P4
    'Jivanjor Lamino' desc_lines / tech_specs / usp_lines / application_lines
    onto P5 (P5 keeps its own name, variants and prices).
    """
    by_num = {p["num"]: p for p in products}
    p4, p5 = by_num[4], by_num[5]
    if p4["name"] != "Jivanjor Lamino" or p5["name"] != "Jivanjor Lamino Advance":
        raise SystemExit("FATAL: P4/P5 names not as expected")
    if p5["tech_specs"] or p5["desc_lines"] or p5["usp_lines"] or p5["application_lines"]:
        raise SystemExit("FATAL: P5 unexpectedly carries its own content")
    return {p["num"]: (p4 if p["num"] == 5 else p) for p in products}


def write_images(products, photos):
    """Extracts each image from the zip in-memory, writes it under its slug
    name and byte-verifies it against the sha256 of the decompressed bytes
    recorded in jivanjor_photos.json (MISTAKES.md image-integrity rule)."""
    folder_map = photos["folder_map"]
    if len(folder_map) != N_PRODUCTS:
        raise SystemExit("FATAL: expected %d folders in the photo inventory, got %d"
                         % (N_PRODUCTS, len(folder_map)))
    if os.path.getsize(ZIP_PATH) != photos["zip_bytes_on_disk"]:
        raise SystemExit("FATAL: zip size on disk != inventory")
    os.makedirs(IMG_DIR, exist_ok=True)
    with zipfile.ZipFile(ZIP_PATH) as zf:
        if zf.testzip() is not None:
            raise SystemExit("FATAL: zip CRC test failed")
        if len([n for n in zf.namelist() if not n.endswith("/")]) != N_PRODUCTS:
            raise SystemExit("FATAL: expected %d file entries in the zip" % N_PRODUCTS)
        out = {}
        for p in products:
            folder = p["photo_folder"]
            if folder not in folder_map:
                raise SystemExit("FATAL: no photo folder %r (product %d)" % (folder, p["num"]))
            info = folder_map[folder]
            data = zf.read(info["path"])
            digest = hashlib.sha256(data).hexdigest()
            if digest != info["sha256"]:
                raise SystemExit("FATAL: sha256 mismatch for %s" % info["path"])
            if len(data) != info["bytes"]:
                raise SystemExit("FATAL: byte-size mismatch for %s" % info["path"])
            ext = info["ext"].lower()
            if ext == ".png":
                ok_magic = data[:8] == b"\x89PNG\r\n\x1a\n"
            elif ext in (".jpg", ".jpeg"):
                ok_magic = data[:3] == b"\xff\xd8\xff"
            else:
                raise SystemExit("FATAL: unexpected extension %s" % ext)
            if not ok_magic:
                raise SystemExit("FATAL: extension %s does not match magic bytes of %s"
                                % (ext, info["path"]))
            fname = "jivanjor-" + folder.strip().lower().replace(" ", "-") + ext
            with open(os.path.join(IMG_DIR, fname), "wb") as f:
                f.write(data)
            with open(os.path.join(IMG_DIR, fname), "rb") as f:  # verify what landed on disk
                if hashlib.sha256(f.read()).hexdigest() != info["sha256"]:
                    raise SystemExit("FATAL: on-disk sha256 mismatch for %s" % fname)
            out[p["num"]] = {"fname": fname, "url": IMG_URL + "/" + fname,
                            "sha256": info["sha256"], "ext": ext}
        used = {p["photo_folder"] for p in products}
        if used != set(folder_map):
            raise SystemExit("FATAL: product folders and photo folders do not cover each other")
    return out


def build(products, images):
    sources = content_sources(products)
    rows, report = [], []
    for p in products:
        src = sources[p["num"]]
        name = p["name"].strip()
        if not name.startswith(BRAND + " "):
            raise SystemExit("FATAL: product %d name %r lacks the brand prefix" % (p["num"], name))

        vs = [{"label": clean_label(v["label"]), "price": v["price"]} for v in p["variants"]]
        if not vs:
            raise SystemExit("FATAL: product %d has no variants" % p["num"])
        for v in vs:
            if not isinstance(v["price"], int) or not v["label"]:
                raise SystemExit("FATAL: product %d variant %r bad" % (p["num"], v))
        if len(vs) == 1:
            price, variants_sql = vs[0]["price"], "NULL"
        else:
            price = min(v["price"] for v in vs)
            variants_sql = JQ([{"label": v["label"], "price": v["price"],
                                "is_default": i == 0} for i, v in enumerate(vs)])

        desc = build_description(src)
        specs = build_specs(src)
        img = images[p["num"]]
        url = img["url"]

        rows.append(
            "  (%s, %s, %s, %s, ARRAY[%s], %s, %s, %s, 100, true)"
            % (SQ(name), SQ(desc), price, SQ(url), SQ(url), JQ(specs), variants_sql, CAT_VAR)
        )
        report.append({
            "num": p["num"], "name": name, "n": len(vs),
            "min": min(v["price"] for v in vs), "max": max(v["price"] for v in vs),
            "image": img["fname"],
        })
    return rows, report


def emit(products, rows, images):
    n_multi = sum(1 for p in products if len(p["variants"]) > 1)
    n_single = len(products) - n_multi
    header = (
        "-- Jivanjor Adhesives (5 September 2026) - from owner-provided CSV + product photos.\n"
        "-- %d products inserted: %d single-price (variants NULL, no selector) and %d with variant selectors.\n"
        "-- %d variant prices in the source; the product price is the cheapest variant.\n"
        "-- %d images in /public/images/jivanjor/ - deploy with the frontend.\n"
        "-- Owner decision: P5 Lamino Advance reuses P4 Lamino's description, tech specs,\n"
        "-- USP and Applications content - P5's own source cells were placeholder text\n"
        "-- referring to Lamino (quarantined by the analysis); P5 keeps its own name,\n"
        "-- variants and prices.\n"
        "-- 7 variant prices exceed Rs 10,000 (max Rs 20,542 on Lamino Advance 60kg): after\n"
        "-- running, verify all 12 products / 36 variants are visible on the live shop and\n"
        "-- category pages, counting with an explicit limit > 1000 (MISTAKES.md #6, #7).\n"
        "-- Safe to re-run: rows are tagged with Source='%s'\n"
        "-- and deleted before re-insert.\n\n"
        "ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;\n\n"
        "DO $$\n"
        "DECLARE\n"
        "  v_parent UUID;\n"
        "  %s UUID;\n"
        "BEGIN\n"
        "  SELECT id INTO v_parent FROM categories WHERE slug='%s' OR lower(name)='%s' LIMIT 1;\n"
        "  IF v_parent IS NULL THEN\n"
        "    INSERT INTO categories (name, slug) VALUES ('%s','%s') RETURNING id INTO v_parent;\n"
        "  END IF;\n"
        "  SELECT id INTO %s FROM categories WHERE parent_id=v_parent AND name='%s' LIMIT 1;\n"
        "  IF %s IS NULL THEN\n"
        "    INSERT INTO categories (name, slug, parent_id) VALUES ('%s', '%s', v_parent) RETURNING id INTO %s;\n"
        "  END IF;\n\n"
        "  -- Remove rows from any earlier run of this script, then re-insert.\n"
        "  DELETE FROM products WHERE specs->>'Source' = '%s';\n\n"
        "  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES\n"
    ) % (len(products), n_single, n_multi, N_VARIANT_PRICES, len(images),
         SOURCE_TAG, CAT_VAR, PARENT_SLUG, PARENT.lower(), PARENT, PARENT_SLUG,
         CAT_VAR, CATEGORY, CAT_VAR, CATEGORY, CATEGORY_SLUG, CAT_VAR, SOURCE_TAG)
    body = ",\n".join(rows) + ";"
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(header + body + "\nEND $$;\n")


# --------------------------------------------------------------------------
# Validation — re-reads the emitted SQL with a quote-aware parser and checks
# it against the source analysis and the photo inventory.
# --------------------------------------------------------------------------

def split_top_level(s):
    """Split on commas outside quotes and outside any (...) / [...] nesting."""
    parts, cur, depth, in_str, i = [], [], 0, False, 0
    while i < len(s):
        c = s[i]
        if in_str:
            cur.append(c)
            if c == "'":
                if i + 1 < len(s) and s[i + 1] == "'":
                    cur.append("'")
                    i += 1
                else:
                    in_str = False
        elif c == "'":
            in_str = True
            cur.append(c)
        elif c in "([":
            depth += 1
            cur.append(c)
        elif c in ")]":
            depth -= 1
            cur.append(c)
        elif c == "," and depth == 0:
            parts.append("".join(cur).strip())
            cur = []
        else:
            cur.append(c)
        i += 1
    parts.append("".join(cur).strip())
    return parts


def parse_insert_rows(sql):
    start = sql.index("VALUES\n") + len("VALUES\n")
    body = sql[start:sql.rindex("END $$;")].strip()
    if not body.endswith(";"):
        raise SystemExit("FATAL: INSERT body does not end with ';'")
    body = body[:-1].strip()
    rows = []
    for seg in split_top_level(body):
        if not (seg.startswith("(") and seg.endswith(")")):
            raise SystemExit("FATAL: malformed row segment: %r" % seg[:80])
        rows.append(split_top_level(seg[1:-1]))
    return rows


def unquote(tok):
    """'...''...' or '...'::jsonb -> the raw string ('' unescaped)."""
    if tok.endswith("::jsonb"):
        tok = tok[: -len("::jsonb")].rstrip()
    if not (tok.startswith("'") and tok.endswith("'")):
        raise SystemExit("FATAL: not a quoted SQL string: %r" % tok[:80])
    return tok[1:-1].replace("''", "'")


def validate(products, photos, images):
    print("\n=== VALIDATION ===")
    results = []

    def check(cond, msg):
        results.append(bool(cond))
        print("  [%s] %s" % ("PASS" if cond else "FAIL", msg))
        return bool(cond)

    sources = content_sources(products)
    by_num = {p["num"]: p for p in products}
    sql = open(OUT, encoding="utf-8").read()
    rows = parse_insert_rows(sql)

    # --- 1. row / variant counts ------------------------------------------
    check(len(rows) == N_PRODUCTS, "%d product rows in the INSERT (found %d)" % (N_PRODUCTS, len(rows)))
    shape_ok = all(len(r) == 10 and r[7] == CAT_VAR and r[8] == "100" and r[9] == "true"
                   for r in rows)
    check(shape_ok, "every row has 10 fields with %s, 100, true" % CAT_VAR)

    names = [unquote(r[0]) for r in rows]
    descs = [unquote(r[1]) for r in rows]
    prices = [int(r[2]) for r in rows]
    urls = [unquote(r[3]) for r in rows]
    arrays = [re.findall(r"'([^']*)'", r[4]) for r in rows]
    specs_sql = [json.loads(unquote(r[5])) for r in rows]
    variants = [json.loads(unquote(r[6])) if r[6] != "NULL" else None for r in rows]

    check(all(json.loads(unquote(r[5])) is not None for r in rows)
          and all(r[6] == "NULL" or json.loads(unquote(r[6])) is not None for r in rows),
          "all specs + variants JSONB blocks parse (json.loads after '' unescape)")

    n_multi = sum(1 for p in products if len(p["variants"]) > 1)
    n_single = N_PRODUCTS - n_multi
    n_null = sum(1 for v in variants if v is None)
    in_jsonb = sum(len(v) for v in variants if v)
    check(n_null == n_single and len([v for v in variants if v]) == n_multi,
          "%d single-variant rows (variants NULL) + %d multi-variant blocks = %d products"
          % (n_single, n_multi, N_PRODUCTS))
    check(in_jsonb + n_null == N_VARIANT_PRICES,
          "%d variant prices in total (JSONB %d + collapsed singles %d)"
          % (in_jsonb + n_null, in_jsonb, n_null))

    good = True
    for v in variants:
        if v is None:
            continue
        if sum(1 for x in v if x.get("is_default")) != 1 or not v[0].get("is_default"):
            good = False
        for x in v:
            if not isinstance(x.get("label"), str) or not x["label"].strip():
                good = False
            if not isinstance(x.get("price"), int):
                good = False
    check(good, "every variant object has a label + integer price; is_default true exactly once, on the first entry")

    # --- 2. price = min variant price -------------------------------------
    price_ok = True
    for (got, p) in zip(prices, products):
        expected = min(v["price"] for v in p["variants"])
        if got != expected:
            price_ok = False
            print("       price mismatch on product %d: SQL=%s expected=%s" % (p["num"], got, expected))
    check(price_ok, "every product price = MIN variant price (single-variant: that price)")
    # Analysis price_range 134..20542 is over VARIANT prices; the 20542 sits on
    # P5's 60kg variant, so the product-price maximum is P5's min variant 10253.
    check(min(prices) == 134 and max(prices) == 10253,
          "product prices span Rs %d - Rs %d (analysis variant range 134 - 20542)"
          % (min(prices), max(prices)))

    # variant data round-trips the analysis (order + labels + prices)
    roundtrip = True
    for (v, p) in zip(variants, products):
        expected = [{"label": clean_label(x["label"]), "price": x["price"]} for x in p["variants"]]
        got = [{"label": x["label"], "price": x["price"]} for x in (v or [])] if v else \
              [{"label": clean_label(p["variants"][0]["label"]), "price": p["variants"][0]["price"]}]
        if got != expected:
            roundtrip = False
            print("       variant data mismatch on product %d" % p["num"])
    check(roundtrip, "every variants block matches the analysis labels + prices in source order")
    check(all("1liter" not in json.dumps(v) for v in variants if v)
          and "1liter" not in sql.replace("1 liter", ""),
          "no '1liter' label survives (normalized to '1 liter')")

    # --- 3. names ----------------------------------------------------------
    check(names == [p["name"].strip() for p in products]
          and len(set(names)) == N_PRODUCTS
          and all(n.startswith(BRAND + " ") for n in names),
          "all %d names unique, in source order, uniformly 'Jivanjor <Name>'" % N_PRODUCTS)

    # --- 4. descriptions (owner decision format + P5 copy) ----------------
    fmt_ok = True
    for d, p in zip(descs, products):
        src = sources[p["num"]]
        exp = build_description(src)
        if d != exp:
            fmt_ok = False
            print("       description emit mismatch on product %d" % p["num"])
        if not d.startswith(fix_line(src["desc_lines"][0])[:20]):
            fmt_ok = False
        if d.count("Key Features:") != 1 or d.count("Applications:") != 1:
            fmt_ok = False
        if "\n\n" not in d or "\n- " not in d:
            fmt_ok = False
        for u in src["usp_lines"]:
            if "\n- " + fix_line(u) not in d and not d.endswith("- " + fix_line(u)):
                fmt_ok = False
        for a in src["application_lines"]:
            if "\n- " + fix_line(a) not in d and not d.endswith("- " + fix_line(a)):
                fmt_ok = False
    check(fmt_ok, "descriptions = desc lines + blank + 'Key Features:' USP bullets + blank + 'Applications:' bullets")
    check(descs[4] == descs[3],
          "P5 Lamino Advance description is identical to P4 Lamino's (owner-approved copy)")
    check(specs_sql[4] == {k: v for k, v in specs_sql[3].items()},
          "P5 tech specs copied from P4 (owner-approved copy)")
    check(all("same as lamino" not in d for d in descs)
          and "same as lamino" not in sql.lower(),
          "no 'same as lamino' placeholder anywhere (MISTAKES #5)")

    # --- 5. specs blocks ----------------------------------------------------
    ok_specs = True
    for s in specs_sql:
        keys = list(s.keys())
        if keys[:2] != ["Brand", "Category"] or keys[-2:] != ["GST", "Source"]:
            ok_specs = False
            print("       bad key order: %s" % keys)
        if s.get("Brand") != BRAND or s.get("Category") != CATEGORY \
           or s.get("GST") != "18%" or s.get("Source") != SOURCE_TAG:
            ok_specs = False
        for k, v in s.items():
            if not isinstance(v, str) or not v.strip() or v == k or "\n" in v:
                ok_specs = False
                print("       bad spec %r: %r" % (k, v))
            if v.strip() in ("-", "N/A", "TBD", "Item"):
                ok_specs = False
    check(ok_specs, "specs key order Brand/Category/.../GST/Source; no key-as-value, no placeholder, no multi-line values")

    tech_ok = True
    for s, p in zip(specs_sql, products):
        src = sources[p["num"]]
        expected = {k: flatten_spec(v) for k, v in src["tech_specs"].items()}
        got = {k: v for k, v in s.items() if k not in ("Brand", "Category", "GST", "Source")}
        if got != expected:
            tech_ok = False
            print("       tech specs mismatch on product %d" % p["num"])
    check(tech_ok, "tech specs round-trip the analysis (multi-line values flattened with ' - ')")

    # --- 6. hygiene (MISTAKES #2-#5) ---------------------------------------
    lower = sql.lower()
    check(not any(x in lower for x in ("demo video", "special notes", "file:///", "youtu")),
          "no 'Demo Video' / 'Special Notes' / file:/// / youtu anywhere in the SQL")
    check(not any(x in lower for x in ("n/a", "tbd")) and sql.count("'-'") == 0,
          "no placeholder values in the SQL")

    # --- 7. idempotency -----------------------------------------------------
    check(sql.index("DELETE FROM products WHERE specs->>'Source' = '%s'" % SOURCE_TAG)
          < sql.index("INSERT INTO products"),
          "Source-tagged DELETE precedes the INSERT (re-run safe)")
    check(sql.count("DELETE FROM products WHERE specs->>'Source' = '%s'" % SOURCE_TAG) == 1,
          "DELETE is tagged with Source='%s' exactly once" % SOURCE_TAG)

    # --- 8. images ----------------------------------------------------------
    check(urls == [IMG_URL + "/" + images[p["num"]]["fname"] for p in products],
          "image_url matches the extracted file for every product")
    check(all(a == [u] for a, u in zip(arrays, urls)),
          "images ARRAY is exactly the single image_url on every row")
    on_disk = sorted(os.listdir(IMG_DIR))
    check(len(on_disk) == N_PRODUCTS,
          "%d files under repo/public/images/jivanjor/ (found %d)" % (N_PRODUCTS, len(on_disk)))
    img_ok = True
    for p in products:
        info = images[p["num"]]
        path = os.path.join(IMG_DIR, info["fname"])
        if not os.path.isfile(path):
            img_ok = False
            continue
        with open(path, "rb") as f:
            data = f.read()
        if hashlib.sha256(data).hexdigest() != info["sha256"]:
            img_ok = False
            print("       sha256 mismatch on %s" % info["fname"])
        ext = info["ext"]
        magic = data[:8] == b"\x89PNG\r\n\x1a\n" if ext == ".png" else data[:3] == b"\xff\xd8\xff"
        if not magic:
            img_ok = False
            print("       extension/format mismatch on %s" % info["fname"])
    check(img_ok, "all %d images on disk: sha256 match vs the verified zip inventory, extension matches actual format" % N_PRODUCTS)

    # --- 9. source-integrity cross-checks -----------------------------------
    csv_sha = hashlib.sha256(open(CSV_PATH, "rb").read()).hexdigest()
    check(csv_sha == analysis["source_csv_sha256"],
          "source CSV sha256 matches the analysis (untouched source of truth)")
    check(analysis["product_count"] == N_PRODUCTS
          and analysis["total_variant_pairs"] == N_VARIANT_PRICES,
          "analysis header agrees: %d products, %d variant pairs" % (N_PRODUCTS, N_VARIANT_PRICES))

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

    global analysis
    analysis = json.load(open(ANALYSIS, encoding="utf-8"))
    photos = json.load(open(PHOTOS_JSON, encoding="utf-8"))
    products = analysis["products"]
    if len(products) != N_PRODUCTS:
        raise SystemExit("FATAL: expected %d products, got %d" % (N_PRODUCTS, len(products)))
    if sum(len(p["variants"]) for p in products) != N_VARIANT_PRICES:
        raise SystemExit("FATAL: expected %d variant prices" % N_VARIANT_PRICES)
    if photos.get("total_images") != N_PRODUCTS:
        raise SystemExit("FATAL: expected %d images in the inventory" % N_PRODUCTS)

    images = write_images(products, photos)
    rows, report = build(products, images)
    emit(products, rows, images)
    emit_counts = Counter(TYPO_COUNTS)  # snapshot the emit pass...
    TYPO_COUNTS.clear()                # ...then let validation re-derive freely
    validate(products, photos, images)

    print("\nDONE in %.1fs -> %s (%.1f KB), %d images written to %s"
          % (time.time() - t0, OUT, os.path.getsize(OUT) / 1024.0, len(images), IMG_DIR))

    if emit_counts:
        print("\nTypos fixed in customer-facing text (owner-approved list):")
        for bad, n in emit_counts.most_common():
            good = next(g for b, g in TYPO_FIXES if b == bad)
            print("  %3dx  %r -> %r" % (n, bad, good))
    else:
        print("\nNo typos from the owner-approved list were found (unexpected).")

    print("\nnum | product                     | vars | price range   | image")
    print("----+-----------------------------+------+---------------+----------------------------------")
    for r in report:
        rng = str(r["min"]) if r["min"] == r["max"] else "%d-%d" % (r["min"], r["max"])
        print("%3d | %-27s | %4d | %-13s | %s" % (r["num"], r["name"][:27], r["n"], rng, r["image"]))


if __name__ == "__main__":
    main()
