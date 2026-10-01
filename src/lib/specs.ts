// Product specifications: what customers see, what the admin edits, and what is
// shown when a product has none of its own.

// Bookkeeping keys that live inside products.specs (seed-batch tags, owner
// notes, tax). Never shown to customers, never edited in Admin, always carried
// through a save untouched.
export const INTERNAL_SPEC_KEYS = ['Source', 'Demo Video', 'Special Notes'];

type SpecsRecord = Record<string, unknown>;
export type SpecEntry = [label: string, value: string];

export interface SpecRow {
  _key: string;
  label: string;
  value: string;
}

const asRecord = (specs: unknown): SpecsRecord =>
  specs && typeof specs === 'object' && !Array.isArray(specs) ? (specs as SpecsRecord) : {};

const INTERNAL_KEYS_LOWER = INTERNAL_SPEC_KEYS.map((key) => key.toLowerCase());
const isInternalKey = (key: string) => INTERNAL_KEYS_LOWER.includes(key.trim().toLowerCase()) || /\bgst\b/i.test(key);

// Empty and dash-only values are sheet placeholders, not specifications.
const isBlank = (value: string) => value === '' || /^[-–—]+$/.test(value);

const isPlainValue = (value: unknown): value is string | number | boolean =>
  typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean';

export const isCustomerFacingSpec = (key: string, value: unknown): boolean => {
  if (isInternalKey(key) || !isPlainValue(value)) return false;
  const text = String(value).trim();
  return !isBlank(text) && !/\bgst\b/i.test(text);
};

export const getCustomerFacingSpecs = (specs: unknown): SpecEntry[] =>
  Object.entries(asRecord(specs))
    .filter(([key, value]) => isCustomerFacingSpec(key, value))
    .map(([key, value]) => [key, String(value).trim()]);

const VARIANT_SPEC_LABELS = new Map([
  ['size', 'Available Sizes'],
  ['color', 'Available Colours'],
  ['colour', 'Available Colours'],
  ['finish', 'Available Finishes'],
]);

/**
 * Specs for a product that has none saved (e.g. anything added through Admin
 * before it had a specifications field). Only facts the product already
 * carries — brand, category and its option list — never invented material or
 * quality claims.
 */
export const buildFallbackSpecs = (product: {
  brandName?: string | null;
  categoryName?: string | null;
  variants?: { label?: unknown; type?: unknown }[] | null;
}): SpecEntry[] => {
  const rows: SpecEntry[] = [];
  if (product.brandName) rows.push(['Brand', product.brandName]);
  if (product.categoryName && product.categoryName !== 'Uncategorized') rows.push(['Category', product.categoryName]);
  const variants = Array.isArray(product.variants) ? product.variants : [];
  const labels = variants.map((variant) => String(variant?.label ?? '').trim()).filter(Boolean);
  if (labels.length) {
    const type = String(variants[0]?.type ?? '').toLowerCase();
    rows.push([VARIANT_SPEC_LABELS.get(type) ?? 'Available Options', labels.join(', ')]);
  }
  return rows;
};

/**
 * Splits saved specs into rows the Admin form can edit and entries that must
 * survive a save unchanged. Only specs customers actually see are editable.
 * Internal tags, tax wording and non-text values are kept exactly as stored;
 * blank or dash-only leftovers from old imports are never shown, so they are
 * dropped rather than turned into empty rows that would block saving.
 */
export const splitSpecsForEditing = (specs: unknown, makeKey: () => string) => {
  const editable: SpecRow[] = [];
  const preserved: SpecsRecord = {};
  for (const [key, value] of Object.entries(asRecord(specs))) {
    if (typeof value !== 'string') preserved[key] = value;
    else if (isBlank(value.trim())) continue;
    else if (!isCustomerFacingSpec(key, value)) preserved[key] = value;
    else editable.push({ _key: makeKey(), label: key, value });
  }
  return { editable, preserved };
};

/**
 * Returns a message for the first problem in the edited rows, or null when they
 * can be saved. `lockedKeys` are the entries that are kept as stored (see
 * splitSpecsForEditing); a new row must not reuse their names.
 */
export const validateSpecRows = (rows: Pick<SpecRow, 'label' | 'value'>[], lockedKeys: string[] = []): string | null => {
  const locked = new Set(lockedKeys.map((key) => key.trim().toLowerCase()));
  const seen = new Set<string>();
  for (const [index, row] of rows.entries()) {
    const label = row.label.trim();
    const value = row.value.trim();
    if (!label && !value) continue;
    if (!label || isBlank(value)) return `Specification ${index + 1} needs both a name and a value — fill it in or remove the row.`;
    const normalized = label.toLowerCase();
    if (isInternalKey(label)) return `"${label}" is reserved for internal use. Choose a different specification name.`;
    if (locked.has(normalized)) return `"${label}" already exists on this product and cannot be edited here. Choose a different specification name.`;
    if (/\bgst\b/i.test(value)) return `"${label}" mentions GST, which is never shown to customers. Reword it or remove the row.`;
    if (seen.has(normalized)) return `"${label}" is listed twice. Each specification name must be unique.`;
    seen.add(normalized);
  }
  return null;
};

/** Builds the specs object to save: the edited rows plus the preserved entries. */
export const mergeSpecsForSave = (rows: Pick<SpecRow, 'label' | 'value'>[], preserved: SpecsRecord): SpecsRecord => {
  const edited: SpecsRecord = {};
  for (const row of rows) {
    const label = row.label.trim();
    const value = row.value.trim();
    if (label && !isBlank(value)) edited[label] = value;
  }
  return { ...edited, ...preserved };
};
