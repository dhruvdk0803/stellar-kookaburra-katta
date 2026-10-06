// Admin bulk product import from CSV: parsing, validation, the batched insert
// loop and the report. Pure (no Supabase import) so `node --test` can run it;
// the admin component only wires file input, data access and rendering.
//
// Row numbers in every message are spreadsheet rows as Excel / Google Sheets
// show them: the header is row 1 and the first product is row 2. A value with
// line breaks inside quotes still counts as one row. Row 0 means "whole file".
import { ensureBrandPrefix, stripKnownBrandPrefix } from './catalog.ts';
import { isCustomerFacingSpec } from './specs.ts';

export const BULK_IMPORT_LIMITS = {
  maxFileBytes: 5 * 1024 * 1024,
  maxRows: 2000,
  maxNameLength: 200,
  maxDescriptionLength: 10000,
  maxPolicyLength: 4000,
  maxImageUrlLength: 2048,
  maxImagesPerProduct: 50,
  maxSpecs: 100,
  maxSpecKeyLength: 100,
  maxSpecValueLength: 1000,
  maxPrice: 10000000,
  maxStock: 1000000,
  batchSize: 25,
} as const;

export type ImportStatus = 'draft' | 'live';
export type MessageLevel = 'error' | 'warning';

export interface ReportMessage {
  row: number;
  level: MessageLevel;
  message: string;
}

export interface ImportReport {
  imported: number;
  failed: number;
  warnings: number;
  rows: ReportMessage[];
}

export interface BulkBrand {
  id: string;
  name: string;
  slug: string;
}

export interface BulkCategory {
  id: string;
  name: string;
  slug: string;
  parent_id?: string | null;
}

export interface ExistingProduct {
  name: string | null;
  brand_id: string | null;
}

/** Same shape the manual Add Product form writes (images[0] is the primary photo). */
export interface ProductInsert {
  name: string;
  brand_id: string;
  category_id: string;
  price: number;
  stock?: number;
  description: string;
  images: string[];
  image_url: string | null;
  specs: Record<string, string>;
  variants: unknown[];
  is_active: boolean;
  return_policy?: string;
  replacement_policy?: string;
}

export interface PreparedRow {
  row: number;
  product: ProductInsert;
}

export interface ImportContext {
  brands: BulkBrand[];
  categories: BulkCategory[];
  existingProducts: ExistingProduct[];
  status: ImportStatus;
}

export interface ValidationResult {
  /** Problems that block the whole file; nothing is imported while any exist. */
  fileErrors: string[];
  valid: PreparedRow[];
  messages: ReportMessage[];
  /** Non-blank product rows in the file. */
  totalRows: number;
  invalidRows: number;
}

const L = BULK_IMPORT_LIMITS;
const formatCount = (value: number) => value.toLocaleString('en-IN');
const preview = (text: string, max = 60) => (text.length > max ? `${text.slice(0, max - 1)}…` : text);

// ---------------------------------------------------------------------------
// Text sanitising
// ---------------------------------------------------------------------------

// C0/C1 controls, DEL, zero-width space, BOM and bidi embedding/override/isolate
// characters (which can visually reorder text) are removed. ZWJ/ZWNJ are kept:
// Indic scripts need them.
const isStrippedCode = (code: number) =>
  code < 0x20 ||
  (code >= 0x7f && code <= 0x9f) ||
  code === 0x200b ||
  (code >= 0x202a && code <= 0x202e) ||
  (code >= 0x2066 && code <= 0x2069) ||
  code === 0xfeff;

const stripControls = (text: string, keepNewlines: boolean): string => {
  let out = '';
  for (const char of String(text ?? '').replace(/\r\n?/g, '\n')) {
    const code = char.codePointAt(0) as number;
    if (code === 0x0a || code === 0x09) {
      out += keepNewlines && code === 0x0a ? '\n' : ' ';
    } else if (!isStrippedCode(code)) {
      out += char;
    }
  }
  return out;
};

/** Single-line value: controls removed, whitespace collapsed, trimmed. */
export const cleanLine = (raw: string): string => stripControls(raw, false).replace(/\s+/g, ' ').trim();

/** Multi-line value: controls removed, line breaks kept, at most one blank line in a row. */
export const cleanMultiline = (raw: string): string =>
  stripControls(raw, true)
    .split('\n')
    .map((line) => line.replace(/[ \t\u00a0]+$/, ''))
    .join('\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim();

const FORMULA_TRIGGERS = new Set(['=', '+', '@', '\uff1d', '\uff0b', '\uff20']);
const DASHES = new Set(['-', '\uff0d', '\u2212']);

/**
 * Spreadsheet-formula safety. A cell that starts with = + @ (or a dash that is
 * not the sign of a number, such as "-5mm") is run as a formula when the data
 * is later opened in Excel or Sheets. Instead of the usual leading apostrophe
 * (which would show up on the storefront) the trigger characters are removed
 * from the start of the value; the caller reports a warning. Nothing is ever
 * evaluated.
 */
export const neutraliseFormula = (text: string): { value: string; trigger?: string } => {
  let value = text;
  let trigger: string | undefined;
  for (let guard = 0; guard < 1000 && value; guard++) {
    const first = value[0];
    const isTrigger = FORMULA_TRIGGERS.has(first) || (DASHES.has(first) && !/^[0-9.]/.test(value.slice(1)));
    if (!isTrigger) break;
    if (trigger === undefined) trigger = first;
    value = value.slice(1).trimStart();
  }
  return { value, trigger };
};

const textField = (raw: string, label: string, multiline: boolean, warnings: string[]): string => {
  const cleaned = multiline ? cleanMultiline(raw) : cleanLine(raw);
  const { value, trigger } = neutraliseFormula(cleaned);
  if (trigger !== undefined) {
    warnings.push(`${label} started with "${trigger}", which spreadsheets run as a formula; the leading character was removed`);
  }
  return value;
};

// ---------------------------------------------------------------------------
// CSV parsing (RFC 4180)
// ---------------------------------------------------------------------------

export interface CsvRecord {
  /** 0-based record index; the spreadsheet row number is index + 1. */
  index: number;
  cells: string[];
  /** The record could not be read reliably (row error). */
  problem?: string;
  /** The record was read, but a quote mark sat in an unusual place (row warning). */
  note?: string;
}

/**
 * Quoted fields may contain commas, line breaks and doubled quotes; CRLF, LF
 * and CR line endings and a UTF-8 BOM are accepted. A quote inside an unquoted
 * value (12" hinge) is kept literally, as Excel does.
 */
export const parseCsv = (text: string): CsvRecord[] => {
  const source = String(text ?? '').replace(/^\ufeff/, '');
  const records: CsvRecord[] = [];
  let cells: string[] = [];
  let field = '';
  let inQuotes = false;
  let quotedField = false;
  let note: string | undefined;

  const pushField = () => {
    cells.push(field);
    field = '';
    quotedField = false;
  };
  const pushRecord = (problem?: string) => {
    pushField();
    const record: CsvRecord = { index: records.length, cells };
    if (problem) record.problem = problem;
    if (note) record.note = note;
    records.push(record);
    cells = [];
    note = undefined;
  };

  for (let i = 0; i < source.length; i++) {
    const char = source[i];
    if (inQuotes) {
      if (char === '"') {
        if (source[i + 1] === '"') {
          field += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field += char;
      }
    } else if (char === ',') {
      pushField();
    } else if (char === '\n' || char === '\r') {
      if (char === '\r' && source[i + 1] === '\n') i++;
      pushRecord();
    } else if (char === '"' && field === '' && !quotedField) {
      inQuotes = true;
      quotedField = true;
    } else {
      if (quotedField && !note) {
        note = 'a quote mark (") is followed by more text inside one value; check that this row was read correctly';
      }
      field += char;
    }
  }

  if (inQuotes) {
    pushRecord('a quoted value is never closed, so this row and everything after it could not be read (check for a missing " mark)');
  } else if (field !== '' || cells.length > 0 || quotedField) {
    pushRecord();
  }
  return records;
};

const isBlankRecord = (record: CsvRecord) => !record.problem && record.cells.every((cell) => cleanLine(cell) === '');

const csvEscape = (value: string): string =>
  /[",\r\n]/.test(value) || value !== value.trim() ? `"${value.replace(/"/g, '""')}"` : value;

export const toCsv = (rows: string[][]): string => `${rows.map((row) => row.map(csvEscape).join(',')).join('\r\n')}\r\n`;

// ---------------------------------------------------------------------------
// Columns
// ---------------------------------------------------------------------------

type ColumnKey =
  | 'name' | 'brand_slug' | 'brand' | 'category_slug' | 'category_id' | 'price' | 'stock' | 'description'
  | 'images' | 'specifications' | 'return_policy' | 'replacement_policy' | 'status' | 'slug' | 'sku';

// A Map, so a header such as "constructor" can never match an Object property.
const COLUMN_ALIASES = new Map<string, ColumnKey>([
  ['name', 'name'],
  ['product_name', 'name'],
  ['brand_slug', 'brand_slug'],
  ['brand', 'brand'], // legacy: brand slug or brand name
  ['category_slug', 'category_slug'],
  ['category_id', 'category_id'],
  ['price', 'price'],
  ['stock', 'stock'],
  ['description', 'description'],
  ['images', 'images'],
  ['image_urls', 'images'],
  ['specifications', 'specifications'],
  ['specification', 'specifications'],
  ['specs', 'specifications'],
  ['return_policy', 'return_policy'],
  ['replacement_policy', 'replacement_policy'],
  ['status', 'status'],
  ['slug', 'slug'],
  ['sku', 'sku'],
]);

export const SUPPORTED_COLUMNS = [
  'name', 'brand_slug', 'category_slug', 'category_id', 'price', 'stock', 'description', 'images',
  'specifications', 'return_policy', 'replacement_policy', 'status',
];

/** "Brand Slug", " BRAND-SLUG ", "Price (₹)" -> brand_slug, brand_slug, price. */
export const normaliseHeader = (raw: string): string =>
  cleanLine(raw)
    .toLowerCase()
    .replace(/[\s-]+/g, '_')
    .replace(/[^a-z0-9_]/g, '')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '');

// ---------------------------------------------------------------------------
// Field parsers
// ---------------------------------------------------------------------------

export const parsePriceCell = (raw: string): { value?: number; error?: string } => {
  const original = cleanLine(raw);
  if (!original) return { error: 'price is empty' };
  const text = original
    .replace(/^(₹|rs\.?|inr)\s*/i, '')
    .replace(/\s*(\/-|₹|rs\.?|inr)$/i, '')
    .trim();
  if (/^-/.test(text)) return { error: `price "${preview(original)}" must be greater than zero` };
  // "12,50" is a decimal comma, never thousands grouping (which ends in 3 digits).
  if (/,\d{1,2}$/.test(text) && !text.includes('.')) {
    return { error: `price "${preview(original)}" is ambiguous; use a dot for decimals, e.g. 12.50` };
  }
  const digits = text.replace(/[,\s]/g, '');
  if (!/^(\d+(\.\d*)?|\.\d+)$/.test(digits)) {
    return { error: `invalid price "${preview(original)}" (use a number such as 1499 or 1,499.50)` };
  }
  const decimals = (digits.split('.')[1] ?? '').replace(/0+$/, '');
  if (decimals.length > 2) return { error: `price "${preview(original)}" has more than 2 decimal places` };
  const value = Number(digits);
  if (!Number.isFinite(value) || value <= 0) return { error: `price "${preview(original)}" must be greater than zero` };
  if (value > L.maxPrice) return { error: `price "${preview(original)}" is above the ₹${formatCount(L.maxPrice)} limit` };
  return { value: Math.round(value * 100) / 100 };
};

/** Blank stock is 0, as in the previous importer. */
export const parseStockCell = (raw: string): { value?: number; error?: string } => {
  const original = cleanLine(raw);
  const text = original.replace(/[,\s]/g, '');
  if (text === '') return { value: 0 };
  if (/^-/.test(text)) return { error: `stock "${preview(original)}" cannot be negative` };
  if (!/^\d+(\.0+)?$/.test(text)) return { error: `invalid stock "${preview(original)}" (use a whole number of 0 or more)` };
  const value = Number(text);
  if (value > L.maxStock) return { error: `stock "${preview(original)}" is above the ${formatCount(L.maxStock)} limit` };
  return { value };
};

const STATUS_WORDS = new Map<string, ImportStatus>([
  ['draft', 'draft'], ['inactive', 'draft'], ['false', 'draft'], ['0', 'draft'],
  ['live', 'live'], ['active', 'live'], ['true', 'live'], ['1', 'live'],
]);

/** undefined = blank cell, null = not recognised. */
export const parseStatusCell = (raw: string): ImportStatus | null | undefined => {
  const text = cleanLine(raw).toLowerCase();
  if (!text) return undefined;
  return STATUS_WORDS.get(text) ?? null;
};

const isPrivateIpv4 = (host: string) => {
  const [a, b, c] = host.split('.').map(Number);
  return (
    a === 0 || a === 10 || a === 127 || a >= 224 ||
    (a === 100 && b >= 64 && b <= 127) ||
    (a === 169 && b === 254) ||
    (a === 172 && b >= 16 && b <= 31) ||
    (a === 192 && b === 168) ||
    (a === 192 && b === 0 && c === 0) ||
    (a === 198 && (b === 18 || b === 19))
  );
};

const isPrivateIpv6 = (host: string) =>
  host.startsWith('::') || /^f[cd]/.test(host) || /^fe[89ab]/.test(host);

/** Hosts an image URL must never point at: loopback, private ranges, local names. */
export const isPrivateHost = (hostname: string): boolean => {
  const host = hostname.toLowerCase().replace(/\.$/, '');
  if (!host) return true;
  if (host.startsWith('[')) return isPrivateIpv6(host.slice(1, -1));
  if (/^\d{1,3}(\.\d{1,3}){3}$/.test(host)) return isPrivateIpv4(host);
  if (host === 'localhost' || /\.(localhost|local|internal|lan|intranet|corp|home\.arpa)$/.test(host)) return true;
  return !host.includes('.'); // single-label names only resolve inside a private network
};

export const checkImageUrl = (raw: string): { url?: string; reason?: string } => {
  const text = raw.trim();
  if (!text) return { reason: 'empty' };
  if (text.length > L.maxImageUrlLength) return { reason: `longer than ${formatCount(L.maxImageUrlLength)} characters` };
  if (/\s/.test(text)) return { reason: 'contains spaces (replace them with %20)' };
  if (!/^https?:\/\//i.test(text)) return { reason: 'must start with http:// or https://' };
  let parsed: URL;
  try {
    parsed = new URL(text);
  } catch {
    return { reason: 'is not a valid web address' };
  }
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') return { reason: 'must start with http:// or https://' };
  if (parsed.username || parsed.password) return { reason: 'must not contain a username or password' };
  if (isPrivateHost(parsed.hostname)) return { reason: 'points to a local or private network address, not a public website' };
  return { url: parsed.href };
};

/**
 * Semicolon-separated public image URLs. The first valid one is the primary
 * image, the rest the gallery (stored together in `images`, like manual
 * products). Bad or duplicate URLs are warnings; the row still imports.
 */
export const parseImageCell = (raw: string): { images: string[]; warnings: string[] } => {
  const parts = stripControls(raw, false).split(';').map((part) => part.trim()).filter(Boolean);
  const images: string[] = [];
  const warnings: string[] = [];
  const seen = new Set<string>();
  let primaryPosition = 0;
  let duplicates = 0;
  let overflow = 0;
  const invalid: { position: number; part: string; reason: string }[] = [];

  parts.forEach((part, index) => {
    const { url, reason } = checkImageUrl(part);
    if (!url) {
      invalid.push({ position: index + 1, part, reason: reason ?? 'invalid' });
      return;
    }
    if (seen.has(url)) {
      duplicates++;
      return;
    }
    if (images.length >= L.maxImagesPerProduct) {
      overflow++;
      return;
    }
    if (!images.length) primaryPosition = index + 1;
    seen.add(url);
    images.push(url);
  });

  for (const { position, part, reason } of invalid) {
    let message = `invalid image URL ${position} (${preview(part)}) skipped: ${reason}`;
    if (position === 1 && images.length) message += `; image ${primaryPosition} is used as the primary image instead`;
    warnings.push(message);
  }
  if (parts.length && !images.length) warnings.push('no valid image URL, so the product is imported without images');
  if (duplicates) warnings.push(`${duplicates} duplicate image URL${duplicates === 1 ? '' : 's'} ignored`);
  if (overflow) warnings.push(`only the first ${L.maxImagesPerProduct} images are kept (${overflow} more ignored)`);
  return { images, warnings };
};

/**
 * "Material:Stainless Steel|Finish:Matte Black" (pairs split on |, name and
 * value on the first colon) or a JSON object {"Material":"Steel"}. Output is
 * the text-to-text object manual products store. A problem never fails the
 * row: the affected specification is skipped with a warning, so a cell that
 * cannot be read at all imports the product without specifications.
 */
export const parseSpecificationsCell = (raw: string): { specs: Record<string, string>; warnings: string[] } => {
  const text = stripControls(raw, false).trim();
  const specs: Record<string, string> = {};
  const warnings: string[] = [];
  if (!text) return { specs, warnings };

  // Entries keep the cell's order so warnings read left to right.
  const pairs: ([string, string] | { warning: string })[] = [];
  if (text.startsWith('{')) {
    let parsed: unknown;
    try {
      parsed = JSON.parse(text);
    } catch {
      warnings.push('specifications look like JSON but could not be read (check quotes and commas); specifications skipped');
      return { specs, warnings };
    }
    if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
      warnings.push('specifications must be Name:Value pairs or a JSON object; specifications skipped');
      return { specs, warnings };
    }
    for (const [key, value] of Object.entries(parsed as Record<string, unknown>)) {
      if (value === null || value === undefined) continue;
      if (typeof value === 'object') {
        pairs.push({ warning: `specification "${preview(key)}" has a nested value (only plain text is allowed); skipped` });
        continue;
      }
      pairs.push([key, String(value)]);
    }
  } else if (text.startsWith('[')) {
    warnings.push('specifications must be Name:Value pairs or a JSON object, not a list; specifications skipped');
    return { specs, warnings };
  } else {
    for (const part of text.split('|')) {
      const piece = part.trim();
      if (!piece) continue;
      const colon = piece.indexOf(':');
      if (colon < 0) {
        pairs.push({ warning: `specification "${preview(piece)}" has no ":" between its name and value; skipped` });
        continue;
      }
      pairs.push([piece.slice(0, colon), piece.slice(colon + 1)]);
    }
  }

  const seen = new Set<string>();
  let overflow = 0;
  for (const entry of pairs) {
    if (!Array.isArray(entry)) {
      warnings.push(entry.warning);
      continue;
    }
    const [rawKey, rawValue] = entry;
    const key = textField(rawKey, 'a specification name', false, warnings);
    const cleanedValue = cleanLine(rawValue);
    if (!key) {
      warnings.push(`a specification has no name${cleanedValue ? ` (value "${preview(cleanedValue)}")` : ''}; skipped`);
      continue;
    }
    // Blank and dash-only values are sheet placeholders, not specifications.
    if (!cleanedValue || /^[-–—]+$/.test(cleanedValue)) continue;
    const value = textField(cleanedValue, `specification "${preview(key)}"`, false, warnings);
    if (!value) continue;
    if (key === '__proto__') {
      warnings.push('specification name "__proto__" is not allowed; skipped');
      continue;
    }
    if (key.length > L.maxSpecKeyLength) {
      warnings.push(`specification name "${preview(key)}" is longer than ${L.maxSpecKeyLength} characters; skipped`);
      continue;
    }
    if (value.length > L.maxSpecValueLength) {
      warnings.push(`specification "${preview(key)}" is longer than ${formatCount(L.maxSpecValueLength)} characters; skipped`);
      continue;
    }
    if (!isCustomerFacingSpec(key, value)) {
      warnings.push(`specification "${preview(key)}" is reserved for internal use or mentions GST, so it is not shown to customers; skipped`);
      continue;
    }
    const normalised = key.toLowerCase();
    if (seen.has(normalised)) {
      warnings.push(`specification "${preview(key)}" is listed twice; only the first value is kept`);
      continue;
    }
    if (seen.size >= L.maxSpecs) {
      overflow++;
      continue;
    }
    seen.add(normalised);
    specs[key] = value;
  }
  if (overflow) warnings.push(`only the first ${L.maxSpecs} specifications are kept (${overflow} more ignored)`);
  return { specs, warnings };
};

// ---------------------------------------------------------------------------
// Duplicate detection
// ---------------------------------------------------------------------------

/** Name as it will be stored: same rule as the Admin form and the products_enforce_brand_prefix trigger. */
export const storedProductName = (name: string, brandName: string, brands: Pick<BulkBrand, 'name'>[]): string =>
  ensureBrandPrefix(stripKnownBrandPrefix(name, brands), brandName);

const nameKey = (brandId: string, storedName: string) =>
  `${brandId}|${storedName.normalize('NFKC').replace(/\s+/g, ' ').trim().toLowerCase()}`;

// ---------------------------------------------------------------------------
// Validation
// ---------------------------------------------------------------------------

export const checkCsvFile = (file: { name: string; size: number }): string | null => {
  if (!/\.csv$/i.test(file.name || '')) return 'Choose a .csv file (in Excel: File > Save As > CSV UTF-8 (Comma delimited)).';
  if (!file.size) return 'The file is empty.';
  if (file.size > L.maxFileBytes) {
    return `The file is ${(file.size / (1024 * 1024)).toFixed(1)} MB; the limit is 5 MB. Split it into smaller files.`;
  }
  return null;
};

const listRows = (rows: number[]) =>
  rows.length > 10 ? `${rows.slice(0, 10).join(', ')} and ${rows.length - 10} more` : rows.join(', ');

const STATUS_LABEL: Record<ImportStatus, string> = { draft: 'Draft', live: 'Live' };

export const validateBulkCsv = (text: string, ctx: ImportContext): ValidationResult => {
  const result: ValidationResult = { fileErrors: [], valid: [], messages: [], totalRows: 0, invalidRows: 0 };
  const fail = (message: string) => {
    result.fileErrors.push(message);
    return result;
  };

  const records = parseCsv(text);
  const header = records[0];
  if (!header || header.cells.every((cell) => !cleanLine(cell))) return fail('The file is empty.');
  if (header.problem) return fail(`The header row could not be read: ${header.problem}.`);
  if (header.cells.length === 1 && /[;\t]/.test(header.cells[0])) {
    return fail('The columns are separated by semicolons or tabs, not commas. In Excel use File > Save As > "CSV UTF-8 (Comma delimited)".');
  }
  if (String(text).includes('\ufffd')) {
    result.messages.push({
      row: 0,
      level: 'warning',
      message: 'some characters could not be read because the file is not UTF-8; save it as "CSV UTF-8" and check symbols such as ₹',
    });
  }

  const columns = new Map<ColumnKey, number>();
  const unknown: string[] = [];
  const duplicated: string[] = [];
  header.cells.forEach((cell, index) => {
    const key = normaliseHeader(cell);
    if (!key) return;
    const column = COLUMN_ALIASES.get(key);
    if (!column) unknown.push(preview(cleanLine(cell), 40));
    else if (columns.has(column)) duplicated.push(column);
    else columns.set(column, index);
  });
  if (duplicated.length) return fail(`Column ${duplicated.map((c) => `"${c}"`).join(', ')} appears more than once.`);
  const missing: string[] = [];
  if (!columns.has('name')) missing.push('name');
  if (!columns.has('brand_slug') && !columns.has('brand')) missing.push('brand_slug');
  if (!columns.has('category_slug') && !columns.has('category_id')) missing.push('category_slug (or category_id)');
  if (!columns.has('price')) missing.push('price');
  if (missing.length) return fail(`Missing required column${missing.length === 1 ? '' : 's'}: ${missing.join(', ')}. Download the template to see the expected columns.`);
  if (unknown.length) {
    result.messages.push({
      row: 1,
      level: 'warning',
      message: `column${unknown.length === 1 ? '' : 's'} ${unknown.map((c) => `"${c}"`).join(', ')} not recognised and ignored (supported: ${SUPPORTED_COLUMNS.join(', ')})`,
    });
  }
  const unstored = (['slug', 'sku'] as const).filter((column) => columns.has(column));
  if (unstored.length) {
    result.messages.push({
      row: 1,
      level: 'warning',
      message: `${unstored.join(' and ')} column${unstored.length === 1 ? ' is' : 's are'} accepted but not saved: products have no slug or SKU field (product pages use the product ID)`,
    });
  }

  const dataRecords = records.slice(1).filter((record) => !isBlankRecord(record));
  result.totalRows = dataRecords.length;
  if (!dataRecords.length) return fail('The file has a header row but no products.');
  if (dataRecords.length > L.maxRows) {
    return fail(`The file has ${formatCount(dataRecords.length)} products; the limit is ${formatCount(L.maxRows)} per file. Split it into smaller files.`);
  }

  const brandList = ctx.brands.filter((brand) => brand && brand.id && brand.name);
  const brandBySlug = new Map(brandList.map((brand) => [String(brand.slug ?? '').trim().toLowerCase(), brand]));
  const brandByName = new Map(brandList.map((brand) => [brand.name.trim().toLowerCase(), brand]));
  const brandNameById = new Map(brandList.map((brand) => [brand.id, brand.name]));
  const categoryById = new Map(ctx.categories.map((category) => [String(category.id).toLowerCase(), category]));
  const categoriesBySlug = new Map<string, BulkCategory[]>();
  for (const category of ctx.categories) {
    const slug = String(category.slug ?? '').trim().toLowerCase();
    if (slug) categoriesBySlug.set(slug, [...(categoriesBySlug.get(slug) ?? []), category]);
  }
  const existingKeys = new Set<string>();
  for (const product of ctx.existingProducts) {
    if (!product?.name || !product.brand_id) continue;
    const brandName = brandNameById.get(product.brand_id);
    existingKeys.add(nameKey(product.brand_id, brandName ? storedProductName(product.name, brandName, brandList) : product.name));
  }
  const fileKeys = new Map<string, number>();
  const statusConflicts: number[] = [];
  const headerWidth = header.cells.length;

  for (const record of dataRecords) {
    const row = record.index + 1;
    const errors: string[] = [];
    const warnings: string[] = [];
    const finish = (product?: ProductInsert) => {
      for (const message of errors) result.messages.push({ row, level: 'error', message });
      for (const message of warnings) result.messages.push({ row, level: 'warning', message });
      if (errors.length || !product) result.invalidRows++;
      else result.valid.push({ row, product });
    };

    if (record.problem) errors.push(record.problem);
    else if (record.cells.length < headerWidth) {
      errors.push(`has ${record.cells.length} values but the header has ${headerWidth} columns (the row is cut short, or a value with a comma is missing its quotes)`);
    } else if (record.cells.slice(headerWidth).some((cell) => cleanLine(cell))) {
      errors.push(`has ${record.cells.length} values but the header has only ${headerWidth} columns (wrap values that contain commas in double quotes)`);
    }
    if (errors.length) {
      finish();
      continue;
    }
    if (record.note) warnings.push(record.note);

    const cell = (key: ColumnKey) => {
      const index = columns.get(key);
      return index === undefined ? '' : record.cells[index] ?? '';
    };

    const name = textField(cell('name'), 'name', false, warnings);
    if (!name) errors.push('name is empty');
    else if (name.length > L.maxNameLength) errors.push(`name is longer than ${L.maxNameLength} characters (${name.length})`);

    const brandText = cleanLine(cell('brand_slug')) || cleanLine(cell('brand'));
    const brand = brandText ? brandBySlug.get(brandText.toLowerCase()) ?? brandByName.get(brandText.toLowerCase()) : undefined;
    if (!brandText) errors.push('brand_slug is empty');
    else if (!brand) errors.push(`brand "${preview(brandText)}" not found (use a brand slug from the Brands tab)`);

    const categorySlug = cleanLine(cell('category_slug'));
    const categoryIdText = cleanLine(cell('category_id'));
    const byId = categoryIdText ? categoryById.get(categoryIdText.toLowerCase()) : undefined;
    let bySlug: BulkCategory | undefined;
    if (!categorySlug && !categoryIdText) errors.push('category is empty (fill category_slug)');
    if (categorySlug) {
      const matches = categoriesBySlug.get(categorySlug.toLowerCase()) ?? [];
      if (!matches.length) errors.push(`category "${preview(categorySlug)}" not found (use a category slug from the Categories tab)`);
      else if (matches.length === 1) bySlug = matches[0];
      else if (byId && matches.some((match) => match.id === byId.id)) bySlug = byId;
      else errors.push(`category slug "${preview(categorySlug)}" matches more than one category; use category_id instead`);
    }
    if (categoryIdText && !byId) errors.push(`category_id "${preview(categoryIdText)}" not found`);
    if (bySlug && byId && bySlug.id !== byId.id) {
      errors.push(`category_slug "${preview(categorySlug)}" and category_id "${preview(categoryIdText)}" point to different categories`);
    }
    const category = byId ?? bySlug;

    const price = parsePriceCell(cell('price'));
    if (price.error) errors.push(price.error);

    let stock: number | undefined;
    if (columns.has('stock')) {
      const parsedStock = parseStockCell(cell('stock'));
      if (parsedStock.error) errors.push(parsedStock.error);
      stock = parsedStock.value;
    }

    const description = textField(cell('description'), 'description', true, warnings);
    if (description.length > L.maxDescriptionLength) {
      errors.push(`description is longer than ${formatCount(L.maxDescriptionLength)} characters (${formatCount(description.length)})`);
    }

    const policies: Partial<Record<'return_policy' | 'replacement_policy', string>> = {};
    for (const column of ['return_policy', 'replacement_policy'] as const) {
      const value = textField(cell(column), column, true, warnings);
      if (value.length > L.maxPolicyLength) {
        errors.push(`${column} is longer than ${formatCount(L.maxPolicyLength)} characters (${formatCount(value.length)})`);
      } else if (value) {
        policies[column] = value;
      }
    }

    const { images, warnings: imageWarnings } = parseImageCell(cell('images'));
    warnings.push(...imageWarnings);
    const { specs, warnings: specWarnings } = parseSpecificationsCell(cell('specifications'));
    warnings.push(...specWarnings);

    if (columns.has('status')) {
      const fileStatus = parseStatusCell(cell('status'));
      if (fileStatus === null) {
        warnings.push(`status "${preview(cleanLine(cell('status')), 30)}" not recognised (use draft or live); saved as ${STATUS_LABEL[ctx.status]}`);
      } else if (fileStatus && fileStatus !== ctx.status) {
        statusConflicts.push(row);
      }
    }

    let storedName = '';
    if (name && brand && name.length <= L.maxNameLength) {
      storedName = storedProductName(name, brand.name, brandList);
      if (storedName.toLowerCase() === brand.name.toLowerCase() || name.toLowerCase() === brand.name.toLowerCase()) {
        errors.push('name contains only the brand name');
      } else {
        const key = nameKey(brand.id, storedName);
        if (existingKeys.has(key)) {
          errors.push(`"${preview(storedName, 80)}" already exists for this brand; skipped so no duplicate is created (edit the existing product instead)`);
        } else if (fileKeys.has(key)) {
          errors.push(`duplicate of row ${fileKeys.get(key)} (same brand and product name); skipped`);
        } else if (!errors.length) {
          fileKeys.set(key, row);
        }
      }
    }

    if (errors.length || !brand || !category || price.value === undefined) {
      finish();
      continue;
    }

    const product: ProductInsert = {
      name: storedName,
      brand_id: brand.id,
      category_id: category.id,
      price: price.value,
      description,
      images,
      image_url: images[0] ?? null,
      specs,
      variants: [],
      is_active: ctx.status === 'live',
    };
    if (stock !== undefined) product.stock = stock;
    // Only sent when filled, so files without policies import even before the
    // return_policy / replacement_policy migration has run.
    if (policies.return_policy) product.return_policy = policies.return_policy;
    if (policies.replacement_policy) product.replacement_policy = policies.replacement_policy;
    finish(product);
  }

  if (statusConflicts.length) {
    const other = ctx.status === 'live' ? 'draft' : 'live';
    result.messages.push({
      row: 1,
      level: 'warning',
      message: `the status column says ${other} on ${statusConflicts.length} row${statusConflicts.length === 1 ? '' : 's'} (${listRows(statusConflicts)}); the "Import products as" setting wins, so every product is saved as ${STATUS_LABEL[ctx.status]}`,
    });
  }
  result.messages.sort(compareMessages);
  return result;
};

const compareMessages = (a: ReportMessage, b: ReportMessage) =>
  a.row - b.row || (a.level === b.level ? 0 : a.level === 'error' ? -1 : 1);

// ---------------------------------------------------------------------------
// Batched insert
// ---------------------------------------------------------------------------

export interface InsertError {
  message: string;
  code?: string;
  details?: string | null;
  hint?: string | null;
}

/** Inserts the given products in one request; resolves to the error, or null on success. */
export type InsertFn = (products: ProductInsert[]) => Promise<InsertError | null>;

export interface ImportOutcome {
  importedRows: number[];
  failures: ReportMessage[];
}

const CONSTRAINT_MESSAGES: [RegExp, string][] = [
  [/products_price_positive/, 'price must be greater than zero'],
  [/products_stock_nonnegative/, 'stock cannot be negative'],
];

export const describeInsertError = (error: InsertError): string => {
  const message = String(error.message || 'unknown error');
  let text: string;
  if (error.code === 'PGRST204') {
    const column = /'([^']+)' column/.exec(message)?.[1];
    text = column
      ? `the database has no "${column}" column yet; ask the site owner to run the latest database migration`
      : `the database is missing a column: ${message}`;
  } else if (error.code === '23514') {
    text = CONSTRAINT_MESSAGES.find(([pattern]) => pattern.test(message))?.[1] ?? `rejected by a database check: ${message}`;
  } else if (error.code === '23503') {
    text = 'the brand or category no longer exists; refresh the page and try again';
  } else if (error.code === '23505') {
    text = 'duplicates an existing record';
  } else if (error.code === '42501') {
    text = 'permission denied; sign in again with an admin account';
  } else if (!error.code) {
    text = `the connection failed (${message})`;
  } else {
    text = message;
  }
  return preview(`could not be saved: ${text}`, 300);
};

/** Permission, session and connection failures would fail every remaining row too. */
const isFatalInsertError = (error: InsertError) =>
  !error.code || error.code === '42501' || error.code.startsWith('PGRST3');

const toInsertError = (error: unknown): InsertError => ({
  message: error instanceof Error ? error.message : String(error),
});

/**
 * Inserts rows in batches. A failed batch is retried row by row so one bad row
 * cannot fail the others (a failed batch insert is atomic: none of it was
 * saved). A permission or connection failure stops the import; rows not tried
 * are reported, and re-importing the file is safe because rows that were saved
 * are then skipped as duplicates.
 */
export const runBatchedImport = async (
  rows: PreparedRow[],
  insert: InsertFn,
  options: { batchSize?: number; onProgress?: (done: number, total: number) => void } = {},
): Promise<ImportOutcome> => {
  const batchSize = Math.max(1, Math.floor(options.batchSize ?? L.batchSize));
  const outcome: ImportOutcome = { importedRows: [], failures: [] };
  const state: { stopReason: string | null } = { stopReason: null };
  let done = 0;

  const attempt = async (batch: PreparedRow[]): Promise<InsertError | null> => {
    try {
      return await insert(batch.map((entry) => entry.product));
    } catch (error) {
      return toInsertError(error);
    }
  };
  const record = (entry: PreparedRow, error: InsertError | null) => {
    if (!error) {
      outcome.importedRows.push(entry.row);
      return;
    }
    outcome.failures.push({ row: entry.row, level: 'error', message: describeInsertError(error) });
    if (isFatalInsertError(error)) state.stopReason = describeInsertError(error).replace(/^could not be saved: /, '');
  };
  const skip = (entry: PreparedRow) =>
    outcome.failures.push({ row: entry.row, level: 'error', message: `not imported: the import stopped after an earlier error (${state.stopReason})` });

  for (let start = 0; start < rows.length; start += batchSize) {
    const batch = rows.slice(start, start + batchSize);
    if (state.stopReason) {
      batch.forEach(skip);
    } else {
      const batchError = await attempt(batch);
      if (!batchError) outcome.importedRows.push(...batch.map((entry) => entry.row));
      else if (batch.length === 1 || isFatalInsertError(batchError)) batch.forEach((entry) => record(entry, batchError));
      else {
        for (const entry of batch) {
          if (state.stopReason) skip(entry);
          else record(entry, await attempt([entry]));
        }
      }
    }
    done += batch.length;
    options.onProgress?.(done, rows.length);
  }
  return outcome;
};

export const buildImportReport = (validation: ValidationResult, outcome: ImportOutcome): ImportReport => {
  const rows = [...validation.messages, ...outcome.failures].sort(compareMessages);
  const failedInsertRows = new Set(outcome.failures.map((failure) => failure.row));
  return {
    imported: outcome.importedRows.length,
    failed: validation.invalidRows + failedInsertRows.size,
    warnings: rows.filter((entry) => entry.level === 'warning').length,
    rows,
  };
};

export const formatRowLabel = (row: number) => (row === 0 ? 'File' : `Row ${row}`);

/** Downloadable copy of the report (messages are neutralised like any other cell). */
export const buildReportCsv = (report: Pick<ImportReport, 'rows'>): string =>
  toCsv([
    ['row', 'level', 'message'],
    ...report.rows.map((entry) => [entry.row === 0 ? 'file' : String(entry.row), entry.level, neutraliseFormula(entry.message).value]),
  ]);

// ---------------------------------------------------------------------------
// Template
// ---------------------------------------------------------------------------

export const TEMPLATE_HEADERS = [
  'name', 'brand_slug', 'category_slug', 'price', 'stock', 'description', 'images', 'specifications',
  'return_policy', 'replacement_policy', 'status',
];

const TEMPLATE_SAMPLE = [
  'Soft Close Concealed Hinge 35mm',
  'dorset',
  'hinges',
  '450',
  '100',
  'Full overlay soft close hinge for kitchen and wardrobe shutters. Clip-on mounting with 3D adjustment.',
  [
    'https://example.com/images/soft-close-hinge-front.jpg',
    'https://example.com/images/soft-close-hinge-side.jpg',
    'https://example.com/images/soft-close-hinge-pack.jpg',
  ].join(';'),
  'Material:Stainless Steel|Finish:Nickel Plated|Cup Diameter:35mm|Opening Angle:110 degrees|Pack Size:2 pieces',
  'Returns accepted within 7 days of delivery if the product is unused and in its original packaging.',
  'Free replacement within 7 days for manufacturing defects or transit damage. Share photos of the issue with our support team.',
  'live',
];

/** CSV text with every supported header and one realistic sample row. */
export const buildCsvTemplate = (): string => toCsv([TEMPLATE_HEADERS, TEMPLATE_SAMPLE]);
