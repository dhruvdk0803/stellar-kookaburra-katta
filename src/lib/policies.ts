// Per-product return and replacement policies: cleaning what Admin saves, and
// choosing what the product page shows. Plain text only — the page renders it as
// text with line breaks kept, never as HTML.

export const POLICY_MAX_LENGTH = 4000;

// Store-wide wording, taken from the Returns page (src/pages/Returns.tsx).
// Shown for products that have no return policy of their own.
export const DEFAULT_RETURN_POLICY = [
  'Eligible items can be returned within 2 days of delivery if they are unused, in their original condition, and in their original packaging. Doorskins, wall panels, laminates, and digital locks are excluded from this return policy.',
  'Contact us within the 2-day window to request a return. Return shipping costs are deducted from an approved refund.',
  'The refunded amount will be automatically credited to your account within 5-7 business days.',
].join('\n\n');

// Shown for products without a replacement policy of their own. Promises
// nothing beyond what the Returns page already says.
export const DEFAULT_REPLACEMENT_NOTE =
  'No separate replacement policy is listed for this product. If an item arrives damaged, defective, or incorrect, email kattainterior@gmail.com with your order number and a photo of the item’s condition.';

// NUL and other control characters (tab and newline are kept). Postgres rejects
// NUL in text, and none of them belong in a policy.
// eslint-disable-next-line no-control-regex
const CONTROL_CHARACTERS = /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]/g;

/**
 * Cleans policy text before it is saved: line endings unified, trailing spaces
 * removed, runs of blank lines collapsed to one, surrounding whitespace trimmed
 * and the text cut to POLICY_MAX_LENGTH. Empty text becomes null so the product
 * falls back to the store-wide wording.
 */
export const normalizePolicyForSave = (text: string | null | undefined): string | null => {
  if (typeof text !== 'string') return null;
  let cleaned = text
    .replace(/\r\n?/g, '\n')
    .replace(CONTROL_CHARACTERS, '')
    .replace(/[ \t]+$/gm, '')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
  if (cleaned.length > POLICY_MAX_LENGTH) {
    cleaned = cleaned.slice(0, POLICY_MAX_LENGTH);
    // Never leave half of a surrogate pair (emoji etc.) at the cut.
    if (/[\uD800-\uDBFF]$/.test(cleaned)) cleaned = cleaned.slice(0, -1);
    cleaned = cleaned.trimEnd();
  }
  return cleaned === '' ? null : cleaned;
};

export interface ProductPolicyFields {
  return_policy?: string | null;
  replacement_policy?: string | null;
}

export interface ProductPolicies {
  /** Text to show: the product's own return policy, else the store-wide wording. */
  returnPolicy: string;
  /** Text to show: the product's own replacement policy, else a short neutral note. */
  replacementPolicy: string;
  hasProductSpecificReturn: boolean;
  hasProductSpecificReplacement: boolean;
}

// A product row from a database where the columns do not exist yet (or hold
// something unexpected) simply has no policy of its own.
const savedPolicy = (value: unknown): string | null => (typeof value === 'string' ? normalizePolicyForSave(value) : null);

/** What the product page shows. Never throws and never returns empty text. */
export const getProductPolicies = (product: ProductPolicyFields | null | undefined): ProductPolicies => {
  const ownReturn = savedPolicy(product?.return_policy);
  const ownReplacement = savedPolicy(product?.replacement_policy);
  return {
    returnPolicy: ownReturn ?? DEFAULT_RETURN_POLICY,
    replacementPolicy: ownReplacement ?? DEFAULT_REPLACEMENT_NOTE,
    hasProductSpecificReturn: ownReturn !== null,
    hasProductSpecificReplacement: ownReplacement !== null,
  };
};

/**
 * The policy columns to send when saving a product from Admin. A column is sent
 * when it has text, or when it must be cleared because the loaded product had
 * text in it. Nothing is sent otherwise, so a product can still be saved before
 * the policy columns exist in the database (they cannot be written to then).
 */
export const buildPolicyPayload = (
  edited: { returnPolicy: string; replacementPolicy: string },
  original?: ProductPolicyFields | null,
): { return_policy?: string | null; replacement_policy?: string | null } => {
  const payload: { return_policy?: string | null; replacement_policy?: string | null } = {};
  const returnPolicy = normalizePolicyForSave(edited.returnPolicy);
  if (returnPolicy !== null || savedPolicy(original?.return_policy) !== null) payload.return_policy = returnPolicy;
  const replacementPolicy = normalizePolicyForSave(edited.replacementPolicy);
  if (replacementPolicy !== null || savedPolicy(original?.replacement_policy) !== null) payload.replacement_policy = replacementPolicy;
  return payload;
};
