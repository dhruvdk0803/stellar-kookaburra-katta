import assert from 'node:assert/strict';
import test from 'node:test';
import {
  BULK_IMPORT_LIMITS,
  buildCsvTemplate,
  buildImportReport,
  buildReportCsv,
  checkCsvFile,
  checkImageUrl,
  neutraliseFormula,
  normaliseHeader,
  parseCsv,
  parseImageCell,
  parsePriceCell,
  parseSpecificationsCell,
  parseStatusCell,
  parseStockCell,
  runBatchedImport,
  validateBulkCsv,
} from '../src/lib/bulkImport.ts';

const brands = [
  { id: 'b-dorset', name: 'Dorset', slug: 'dorset' },
  { id: 'b-ebco', name: 'Ebco', slug: 'ebco' },
];
const categories = [
  { id: 'c-hinges', name: 'Hinges', slug: 'hinges', parent_id: null },
  { id: 'c-handles', name: 'Handles', slug: 'handles', parent_id: null },
];
const ctx = (overrides = {}) => ({ brands, categories, existingProducts: [], status: 'draft', ...overrides });
const errorsFor = (result, row) => result.messages.filter((m) => m.row === row && m.level === 'error').map((m) => m.message);
const warningsFor = (result, row) => result.messages.filter((m) => m.row === row && m.level === 'warning').map((m) => m.message);
const NEW_HEADER = 'name,brand_slug,category_slug,price,stock,images,specifications,status';

// --- CSV parser ---------------------------------------------------------------

test('parser handles quotes, escaped quotes, commas and line breaks inside quotes', () => {
  const records = parseCsv('a,b,c\r\n"x, y","say ""hi""","line1\nline2"\r\nplain,12" hinge,\r\n');
  assert.equal(records.length, 3);
  assert.deepEqual(records[1].cells, ['x, y', 'say "hi"', 'line1\nline2']);
  assert.deepEqual(records[2].cells, ['plain', '12" hinge', '']);
  assert.equal(records[2].index, 2);
});

test('parser strips a UTF-8 BOM and accepts LF, CRLF and CR line endings', () => {
  const records = parseCsv('\uFEFFname,price\r\nA,1\nB,2\rC,3');
  assert.deepEqual(records.map((r) => r.cells), [['name', 'price'], ['A', '1'], ['B', '2'], ['C', '3']]);
});

test('parser reports an unclosed quote on the row where it starts', () => {
  const records = parseCsv('name,price\nA,1\n"B,2\nC,3\n');
  assert.equal(records.length, 3);
  assert.match(records[2].problem, /never closed/);
});

test('a multi-line quoted value still counts as one spreadsheet row', () => {
  const csv = `${NEW_HEADER}\n"Hinge A",dorset,hinges,100,1,,,\n"Hinge\nB",dorset,hinges,abc,1,,,\n`;
  const result = validateBulkCsv(csv, ctx());
  assert.deepEqual(errorsFor(result, 3), ['invalid price "abc" (use a number such as 1499 or 1,499.50)']);
});

test('ragged rows are row errors, trailing empty cells are tolerated', () => {
  const csv = 'name,brand_slug,category_slug,price\nShort,dorset,hinges\nLong,dorset,hinges,10,extra\nTrailing,dorset,hinges,10,,\n';
  const result = validateBulkCsv(csv, ctx());
  assert.match(errorsFor(result, 2)[0], /has 3 values but the header has 4 columns/);
  assert.match(errorsFor(result, 3)[0], /has 5 values but the header has only 4 columns/);
  assert.deepEqual(result.valid.map((r) => r.row), [4]);
  assert.equal(result.invalidRows, 2);
});

test('header names are normalised (case, spaces, hyphens, decorations)', () => {
  assert.equal(normaliseHeader(' Brand Slug '), 'brand_slug');
  assert.equal(normaliseHeader('CATEGORY-SLUG'), 'category_slug');
  assert.equal(normaliseHeader('Price (₹)'), 'price');
  assert.equal(normaliseHeader('Return Policy'), 'return_policy');
  const result = validateBulkCsv('Name,Brand Slug,Category Slug,PRICE\nHinge,dorset,hinges,10\n', ctx());
  assert.deepEqual(result.fileErrors, []);
  assert.equal(result.valid.length, 1);
});

test('blank lines are skipped but keep row numbers aligned with the spreadsheet', () => {
  const result = validateBulkCsv('name,brand_slug,category_slug,price\n\n,,,\nHinge,dorset,hinges,0\n', ctx());
  assert.equal(result.totalRows, 1);
  assert.match(errorsFor(result, 4)[0], /greater than zero/);
});

// --- File-level checks -------------------------------------------------------

test('file checks: .csv only, not empty, at most 5 MB', () => {
  assert.equal(checkCsvFile({ name: 'products.CSV', size: 100 }), null);
  assert.match(checkCsvFile({ name: 'products.xlsx', size: 100 }), /\.csv/);
  assert.match(checkCsvFile({ name: 'products.csv', size: 0 }), /empty/);
  assert.match(checkCsvFile({ name: 'products.csv', size: BULK_IMPORT_LIMITS.maxFileBytes + 1 }), /5 MB/);
});

test('missing columns, duplicate columns, empty files and semicolon files block the import', () => {
  assert.match(validateBulkCsv('', ctx()).fileErrors[0], /empty/);
  assert.match(validateBulkCsv('name,price\nA,1\n', ctx()).fileErrors[0], /brand_slug, category_slug \(or category_id\)/);
  assert.match(validateBulkCsv('name,name,brand_slug,category_slug,price\n', ctx()).fileErrors[0], /appears more than once/);
  assert.match(validateBulkCsv('name,brand_slug,category_slug,price\n', ctx()).fileErrors[0], /no products/);
  assert.match(validateBulkCsv('name;brand_slug;category_slug;price\nA;dorset;hinges;1\n', ctx()).fileErrors[0], /semicolons/);
});

test('more than 2,000 product rows are rejected as a whole', () => {
  const lines = ['name,brand_slug,category_slug,price'];
  for (let i = 0; i < BULK_IMPORT_LIMITS.maxRows + 1; i++) lines.push(`Hinge ${i},dorset,hinges,10`);
  const result = validateBulkCsv(lines.join('\n'), ctx());
  assert.match(result.fileErrors[0], /limit is 2,000/);
  assert.equal(result.valid.length, 0);
  lines.pop();
  assert.equal(validateBulkCsv(lines.join('\n'), ctx()).valid.length, BULK_IMPORT_LIMITS.maxRows);
});

test('unknown columns warn once; slug and sku are accepted but not stored', () => {
  const result = validateBulkCsv('name,brand_slug,category_slug,price,slug,sku,colour\nHinge,dorset,hinges,10,hinge,SKU-1,red\n', ctx());
  const header = warningsFor(result, 1);
  assert.equal(header.length, 2);
  assert.ok(header.some((m) => /"colour" not recognised/.test(m)));
  assert.ok(header.some((m) => /slug and sku columns are accepted but not saved/.test(m)));
  assert.equal(result.valid.length, 1);
  assert.ok(!('slug' in result.valid[0].product) && !('sku' in result.valid[0].product));
});

// --- Legacy and new formats ---------------------------------------------------

test('legacy files (name, brand_slug, price, description, category_id, stock, images) still import', () => {
  const csv = [
    'name, brand_slug, price, description, category_id, stock, images',
    'Soft Close Hinge,dorset,450,"Clip-on, 3D adjustable",c-hinges,25,https://cdn.example.com/a.jpg;https://cdn.example.com/b.jpg',
    'Dorset Cabinet Handle,Dorset,"₹1,299.50",,c-handles,,',
  ].join('\n');
  const result = validateBulkCsv(csv, ctx());
  assert.deepEqual(result.fileErrors, []);
  assert.equal(result.invalidRows, 0);
  assert.deepEqual(result.valid[0].product, {
    name: 'Dorset Soft Close Hinge',
    brand_id: 'b-dorset',
    category_id: 'c-hinges',
    price: 450,
    stock: 25,
    description: 'Clip-on, 3D adjustable',
    images: ['https://cdn.example.com/a.jpg', 'https://cdn.example.com/b.jpg'],
    image_url: 'https://cdn.example.com/a.jpg',
    specs: {},
    variants: [],
    is_active: false,
  });
  // Brand prefix is not doubled, blank stock is 0 and blank images mean no images.
  assert.equal(result.valid[1].product.name, 'Dorset Cabinet Handle');
  assert.equal(result.valid[1].product.price, 1299.5);
  assert.equal(result.valid[1].product.stock, 0);
  assert.deepEqual(result.valid[1].product.images, []);
  assert.equal(result.valid[1].product.image_url, null);
  assert.deepEqual(result.messages, []);
});

test('the legacy brand column accepts a brand name; without a stock column stock is left to the database', () => {
  const result = validateBulkCsv('name,brand,category_id,price\nTower Bolt,Ebco,c-hinges,99\n', ctx());
  assert.equal(result.valid[0].product.brand_id, 'b-ebco');
  assert.equal(result.valid[0].product.name, 'Ebco Tower Bolt');
  assert.ok(!('stock' in result.valid[0].product));
});

test('new-format file with specifications, policies and status', () => {
  const csv = [
    'name,brand_slug,category_slug,price,stock,description,images,specifications,return_policy,replacement_policy,status',
    'Soft Close Hinge,dorset,hinges,450,100,Line one,https://cdn.example.com/a.jpg,Material:Stainless Steel|Finish:Matte Black|Thickness:1.2mm,"  7 days, unused  ",,draft',
  ].join('\r\n');
  const result = validateBulkCsv(csv, ctx());
  assert.deepEqual(result.messages, []);
  const { product } = result.valid[0];
  assert.deepEqual(product.specs, { Material: 'Stainless Steel', Finish: 'Matte Black', Thickness: '1.2mm' });
  assert.equal(product.return_policy, '7 days, unused');
  assert.ok(!('replacement_policy' in product), 'empty policy is not sent (stored as null)');
  assert.equal(product.is_active, false);
});

test('brand and category validation', () => {
  const csv = [
    'name,brand_slug,category_slug,category_id,price',
    'A,,hinges,,10',
    'B,nope,hinges,,10',
    'C,dorset,,,10',
    'D,dorset,doors,,10',
    'E,dorset,,c-missing,10',
    'F,dorset,hinges,c-handles,10',
    'G,dorset,HINGES,c-hinges,10',
  ].join('\n');
  const result = validateBulkCsv(csv, ctx());
  assert.deepEqual(errorsFor(result, 2), ['brand_slug is empty']);
  assert.match(errorsFor(result, 3)[0], /brand "nope" not found/);
  assert.deepEqual(errorsFor(result, 4), ['category is empty (fill category_slug)']);
  assert.match(errorsFor(result, 5)[0], /category "doors" not found/);
  assert.match(errorsFor(result, 6)[0], /category_id "c-missing" not found/);
  assert.match(errorsFor(result, 7)[0], /point to different categories/);
  assert.deepEqual(result.valid.map((r) => [r.row, r.product.category_id]), [[8, 'c-hinges']]);
});

test('a row lists every problem at once', () => {
  const result = validateBulkCsv('name,brand_slug,category_slug,price,stock\n,nope,doors,abc,-1\n', ctx());
  assert.equal(errorsFor(result, 2).length, 5);
});

// --- Price, stock, lengths ---------------------------------------------------

test('price parsing', () => {
  assert.equal(parsePriceCell('₹1,499.50').value, 1499.5);
  assert.equal(parsePriceCell('Rs. 1,00,000/-').value, 100000);
  assert.equal(parsePriceCell(' 450 ').value, 450);
  assert.equal(parsePriceCell('12.500').value, 12.5);
  assert.match(parsePriceCell('').error, /empty/);
  assert.match(parsePriceCell('0').error, /greater than zero/);
  assert.match(parsePriceCell('-5').error, /greater than zero/);
  assert.match(parsePriceCell('12,50').error, /ambiguous/);
  assert.match(parsePriceCell('1.234').error, /2 decimal places/);
  assert.match(parsePriceCell('abc').error, /invalid price/);
  assert.match(parsePriceCell('=1+1').error, /invalid price/);
  assert.match(parsePriceCell('99999999').error, /limit/);
});

test('stock parsing', () => {
  assert.equal(parseStockCell('').value, 0);
  assert.equal(parseStockCell('1,200').value, 1200);
  assert.equal(parseStockCell('10.0').value, 10);
  assert.match(parseStockCell('-1').error, /negative/);
  assert.match(parseStockCell('2.5').error, /whole number/);
  assert.match(parseStockCell('lots').error, /whole number/);
});

test('length caps on name, description and policies', () => {
  const longName = 'N'.repeat(201);
  const longPolicy = 'P'.repeat(4001);
  const csv = `name,brand_slug,category_slug,price,return_policy\n${longName},dorset,hinges,10,\nOK,dorset,hinges,10,${longPolicy}\n`;
  const result = validateBulkCsv(csv, ctx());
  assert.match(errorsFor(result, 2)[0], /longer than 200/);
  assert.match(errorsFor(result, 3)[0], /return_policy is longer than 4,000/);
  const ok = validateBulkCsv(`name,brand_slug,category_slug,price,replacement_policy\nOK,dorset,hinges,10,${'P'.repeat(4000)}\n`, ctx());
  assert.equal(ok.valid[0].product.replacement_policy.length, 4000);
});

// --- Images -------------------------------------------------------------------

test('image URL checks', () => {
  assert.equal(checkImageUrl('https://cdn.example.com/a.jpg').url, 'https://cdn.example.com/a.jpg');
  assert.equal(checkImageUrl('HTTP://CDN.Example.com/A.jpg').url, 'http://cdn.example.com/A.jpg');
  for (const bad of [
    'javascript:alert(1)',
    'data:image/png;base64,AAAA',
    'file:///C:/images/a.jpg',
    'ftp://example.com/a.jpg',
    '/images/a.jpg',
    'http://localhost/a.jpg',
    'http://127.0.0.1/a.jpg',
    'http://2130706433/a.jpg',
    'http://10.0.0.5/a.jpg',
    'http://192.168.1.10/a.jpg',
    'http://172.20.0.1/a.jpg',
    'http://169.254.169.254/latest',
    'http://[::1]/a.jpg',
    'http://[fd00::1]/a.jpg',
    'http://intranet/a.jpg',
    'http://printer.local/a.jpg',
    'https://user:pass@example.com/a.jpg',
    'https://example.com/my image.jpg',
    `https://example.com/${'a'.repeat(2050)}.jpg`,
  ]) {
    assert.equal(checkImageUrl(bad).url, undefined, bad);
  }
});

test('images split on semicolons: first valid is primary, duplicates removed, bad ones warn', () => {
  const ok = parseImageCell(' https://x.com/1.jpg ; https://x.com/2.jpg;https://x.com/1.jpg;; ');
  assert.deepEqual(ok.images, ['https://x.com/1.jpg', 'https://x.com/2.jpg']);
  assert.deepEqual(ok.warnings, ['1 duplicate image URL ignored']);

  const badFirst = parseImageCell('javascript:alert(1);https://x.com/2.jpg;http://localhost/3.jpg');
  assert.deepEqual(badFirst.images, ['https://x.com/2.jpg']);
  assert.equal(badFirst.warnings.length, 2);
  assert.match(badFirst.warnings[0], /image URL 1 .* image 2 is used as the primary image instead/);
  assert.match(badFirst.warnings[1], /image URL 3 .*private network/);

  const none = parseImageCell('not a url;ftp://x.com/a.jpg');
  assert.deepEqual(none.images, []);
  assert.match(none.warnings.at(-1), /imported without images/);

  assert.deepEqual(parseImageCell(''), { images: [], warnings: [] });
  const many = parseImageCell(Array.from({ length: 52 }, (_, i) => `https://x.com/${i}.jpg`).join(';'));
  assert.equal(many.images.length, 50);
  assert.match(many.warnings[0], /2 more ignored/);
});

test('a row with only invalid images still imports, with a warning', () => {
  const result = validateBulkCsv('name,brand_slug,category_slug,price,images\nHinge,dorset,hinges,10,file:///x.jpg\n', ctx());
  assert.equal(result.valid.length, 1);
  assert.deepEqual(result.valid[0].product.images, []);
  assert.equal(result.valid[0].product.image_url, null);
  assert.equal(warningsFor(result, 2).length, 2);
});

// --- Specifications -----------------------------------------------------------

test('pipe specifications: first colon splits, blanks dropped, empty names warn', () => {
  const { specs, warnings } = parseSpecificationsCell(' Material : Stainless Steel | Time:10:30 || Finish:- | :orphan | NoColon | Size: ');
  assert.deepEqual(specs, { Material: 'Stainless Steel', Time: '10:30' });
  assert.equal(warnings.length, 2);
  assert.match(warnings[0], /has no name \(value "orphan"\)/);
  assert.match(warnings[1], /"NoColon" has no ":"/);
});

test('JSON specifications: values become text, nested values rejected', () => {
  const { specs, warnings } = parseSpecificationsCell('{"Material":"Steel","Weight (kg)":1.5,"Rust proof":true,"Meta":{"a":1},"List":[1],"Empty":null}');
  assert.deepEqual(specs, { Material: 'Steel', 'Weight (kg)': '1.5', 'Rust proof': 'true' });
  assert.equal(warnings.length, 2);
  assert.ok(warnings.every((w) => /nested value/.test(w)));
});

test('unreadable specifications warn and are skipped without failing the row', () => {
  assert.match(parseSpecificationsCell('{"Material": Steel}').warnings[0], /could not be read/);
  assert.match(parseSpecificationsCell('["a"]').warnings[0], /not a list/);
  const csv = 'name,brand_slug,category_slug,price,specifications\nHinge,dorset,hinges,10,"{""Material"":""Steel"""\n';
  const result = validateBulkCsv(csv, ctx());
  assert.equal(result.valid.length, 1);
  assert.deepEqual(result.valid[0].product.specs, {});
  assert.equal(warningsFor(result, 2).length, 1);
});

test('reserved, GST and duplicate specification names are skipped with warnings', () => {
  const { specs, warnings } = parseSpecificationsCell('Source:batch-1|GST:18%|Warranty:GST bill needed|Finish:Matte|finish:Gloss|__proto__:x');
  assert.deepEqual(specs, { Finish: 'Matte' });
  assert.equal(warnings.length, 5);
  assert.equal(Object.getPrototypeOf(specs), Object.prototype);
});

// --- Status -------------------------------------------------------------------

test('status words are recognised case-insensitively', () => {
  for (const word of ['draft', 'DRAFT', 'inactive', 'false', '0']) assert.equal(parseStatusCell(word), 'draft', word);
  for (const word of ['Live', 'active', 'TRUE', '1']) assert.equal(parseStatusCell(word), 'live', word);
  assert.equal(parseStatusCell(''), undefined);
  assert.equal(parseStatusCell('published'), null);
});

test('the Import-as setting wins over the file status column', () => {
  const csv = 'name,brand_slug,category_slug,price,status\nA,dorset,hinges,10,live\nB,dorset,hinges,10,draft\nC,dorset,hinges,10,maybe\nD,dorset,hinges,10,\n';
  const asDraft = validateBulkCsv(csv, ctx({ status: 'draft' }));
  assert.ok(asDraft.valid.every((r) => r.product.is_active === false));
  assert.match(warningsFor(asDraft, 1)[0], /says live on 1 row \(2\).*saved as Draft/);
  assert.match(warningsFor(asDraft, 4)[0], /status "maybe" not recognised .* saved as Draft/);
  assert.deepEqual(warningsFor(asDraft, 2), []);

  const asLive = validateBulkCsv(csv, ctx({ status: 'live' }));
  assert.ok(asLive.valid.every((r) => r.product.is_active === true));
  assert.match(warningsFor(asLive, 1)[0], /says draft on 1 row \(3\).*saved as Live/);
});

// --- Duplicates ---------------------------------------------------------------

test('duplicate rows in the file are skipped after the first', () => {
  const csv = 'name,brand_slug,category_slug,price\nSoft Close Hinge,dorset,hinges,10\ndorset  soft close HINGE,dorset,handles,12\nSoft Close Hinge,ebco,hinges,10\n';
  const result = validateBulkCsv(csv, ctx());
  assert.deepEqual(result.valid.map((r) => r.row), [2, 4]);
  assert.match(errorsFor(result, 3)[0], /duplicate of row 2/);
});

test('a product that already exists for the brand is skipped (brand prefix rule applied)', () => {
  const existingProducts = [
    { name: 'Dorset Soft Close Hinge', brand_id: 'b-dorset' },
    { name: 'Telescopic Channel', brand_id: 'b-ebco' }, // legacy row stored without the prefix
  ];
  const csv = 'name,brand_slug,category_slug,price\nsoft close hinge,dorset,hinges,10\nEbco Telescopic Channel,ebco,hinges,10\nSoft Close Hinge,ebco,hinges,10\n';
  const result = validateBulkCsv(csv, ctx({ existingProducts }));
  assert.match(errorsFor(result, 2)[0], /"Dorset soft close hinge" already exists for this brand/);
  assert.match(errorsFor(result, 3)[0], /already exists/);
  assert.deepEqual(result.valid.map((r) => r.row), [4]);
});

test('an invalid first occurrence does not block a later valid row', () => {
  const csv = 'name,brand_slug,category_slug,price\nHinge,dorset,hinges,0\nHinge,dorset,hinges,10\n';
  const result = validateBulkCsv(csv, ctx());
  assert.deepEqual(result.valid.map((r) => r.row), [3]);
});

test('a name that is only the brand is rejected', () => {
  const result = validateBulkCsv('name,brand_slug,category_slug,price\nDorset,dorset,hinges,10\n', ctx());
  assert.deepEqual(errorsFor(result, 2), ['name contains only the brand name']);
});

// --- Formula safety and sanitising ------------------------------------------

test('formula triggers are removed from the start of text values', () => {
  assert.deepEqual(neutraliseFormula('=HYPERLINK("x")'), { value: 'HYPERLINK("x")', trigger: '=' });
  assert.deepEqual(neutraliseFormula('+=@cmd'), { value: 'cmd', trigger: '+' });
  assert.deepEqual(neutraliseFormula('- Heavy duty'), { value: 'Heavy duty', trigger: '-' });
  assert.deepEqual(neutraliseFormula('-5°C rated'), { value: '-5°C rated', trigger: undefined });
  assert.deepEqual(neutraliseFormula('Hinge = good'), { value: 'Hinge = good', trigger: undefined });

  const csv = 'name,brand_slug,category_slug,price,description,specifications\n"=cmd|\' /C calc\'!A0",dorset,hinges,10,@SUM(1),=Material:+Steel\n';
  const result = validateBulkCsv(csv, ctx());
  const { product } = result.valid[0];
  assert.equal(product.name, "Dorset cmd|' /C calc'!A0");
  assert.equal(product.description, 'SUM(1)');
  assert.deepEqual(product.specs, { Material: 'Steel' });
  assert.equal(warningsFor(result, 2).length, 4);
});

test('control and bidi characters are stripped; description keeps line breaks', () => {
  const csv = 'name,brand_slug,category_slug,price,description\n"Hin\u0000ge\u202e  A",dorset,hinges,10,"Line 1\r\n\r\n\r\n\r\nLine 2\u0007"\n';
  const { product } = validateBulkCsv(csv, ctx()).valid[0];
  assert.equal(product.name, 'Dorset Hinge A');
  assert.equal(product.description, 'Line 1\n\nLine 2');
});

// --- Template -----------------------------------------------------------------

test('the template has every column and its sample row validates cleanly', () => {
  const template = buildCsvTemplate();
  const [header, sample, ...rest] = parseCsv(template);
  assert.equal(rest.length, 0);
  assert.deepEqual(header.cells, [
    'name', 'brand_slug', 'category_slug', 'price', 'stock', 'description', 'images', 'specifications',
    'return_policy', 'replacement_policy', 'status',
  ]);
  assert.equal(sample.cells[1], 'dorset');
  assert.equal(sample.cells[2], 'hinges');
  assert.equal(sample.cells[6].split(';').length, 3);

  const result = validateBulkCsv(template, ctx({ status: 'live' }));
  assert.deepEqual(result.fileErrors, []);
  assert.deepEqual(result.messages, []);
  const { product } = result.valid[0];
  assert.equal(product.images.length, 3);
  assert.equal(product.image_url, product.images[0]);
  assert.ok(Object.keys(product.specs).length >= 3);
  assert.ok(product.return_policy && product.replacement_policy);
  assert.equal(product.is_active, true);
  // With the default Draft setting the sample's "live" status is reported, not applied.
  assert.equal(validateBulkCsv(template, ctx()).messages.length, 1);
});

// --- Batched insert and report ---------------------------------------------

const prepared = (rows) => rows.map((row) => ({ row, product: { name: `P${row}` } }));

test('a failed batch is retried row by row so one bad row does not fail the others', async () => {
  const calls = [];
  const insert = async (products) => {
    calls.push(products.map((p) => p.name));
    if (products.some((p) => p.name === 'P4')) return { message: 'new row violates check constraint "products_price_positive"', code: '23514' };
    return null;
  };
  const progress = [];
  const outcome = await runBatchedImport(prepared([2, 3, 4, 5, 6]), insert, { batchSize: 3, onProgress: (d, t) => progress.push(`${d}/${t}`) });
  assert.deepEqual(outcome.importedRows, [2, 3, 5, 6]);
  assert.deepEqual(outcome.failures, [{ row: 4, level: 'error', message: 'could not be saved: price must be greater than zero' }]);
  assert.deepEqual(calls, [['P2', 'P3', 'P4'], ['P2'], ['P3'], ['P4'], ['P5', 'P6']]);
  assert.deepEqual(progress, ['3/5', '5/5']);
});

test('a permission or connection failure stops the import and reports untried rows', async () => {
  const outcome = await runBatchedImport(prepared([2, 3, 4]), async () => ({ message: 'new row violates row-level security policy', code: '42501' }), { batchSize: 2 });
  assert.equal(outcome.importedRows.length, 0);
  assert.equal(outcome.failures.length, 3);
  assert.match(outcome.failures[0].message, /permission denied/);
  assert.match(outcome.failures[2].message, /import stopped/);

  const thrown = await runBatchedImport(prepared([2]), async () => { throw new TypeError('Failed to fetch'); });
  assert.match(thrown.failures[0].message, /connection failed/);
});

test('a missing policy column is explained', async () => {
  const outcome = await runBatchedImport(prepared([2]), async () => ({
    message: "Could not find the 'return_policy' column of 'products' in the schema cache",
    code: 'PGRST204',
  }));
  assert.match(outcome.failures[0].message, /no "return_policy" column yet/);
});

test('the report merges validation and insert results', async () => {
  const csv = 'name,brand_slug,category_slug,price,images\nA,dorset,hinges,10,javascript:x\nB,nope,hinges,10,\nC,dorset,hinges,10,\n';
  const validation = validateBulkCsv(csv, ctx());
  const outcome = await runBatchedImport(validation.valid, async (products) =>
    products.some((p) => p.name === 'Dorset C') ? { message: 'boom', code: 'XX000' } : null);
  const report = buildImportReport(validation, outcome);
  assert.equal(report.imported, 1);
  assert.equal(report.failed, 2);
  assert.equal(report.warnings, 2);
  assert.deepEqual(report.rows.map((r) => `${r.row}:${r.level}`), ['2:warning', '2:warning', '3:error', '4:error']);
  const reportCsv = buildReportCsv(report);
  assert.equal(parseCsv(reportCsv).length, 5);
});
