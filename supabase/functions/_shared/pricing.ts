// Shared checkout pricing for the order edge functions.
//
// PURE TypeScript: no Deno globals and no URL/npm imports, so the edge
// functions and the Node tests (`node --experimental-strip-types`) run exactly
// the same code. Prices always come from database rows, never the browser.
//
// Discount rule (the server is the source of truth): the HIGHEST active tier
// whose min_subtotal is <= the cart subtotal applies its percentage to the
// WHOLE subtotal (₹3,000 at 1.4% saves ₹42; tiers are never stacked or
// marginal). Shipping is a flat fee that is never discounted.
//
// The discount algorithm is duplicated in src/lib/discounts.ts for the
// storefront; tests/pricing.test.mjs proves the two agree. Change both together.

export const SHIPPING_PAISE = 0; // shipping is free on every order
export const MAX_CART_LINES = 50;
export const MIN_LINE_QUANTITY = 1;
export const MAX_LINE_QUANTITY = 100;
/** discount_tiers.discount_percent is numeric(5,2) with CHECK (> 0 AND <= 50). */
export const MAX_DISCOUNT_PERCENT_HUNDREDTHS = 5_000;

export const STALE_TOTAL_MESSAGE =
  "Your order total has changed. Please review the updated total and try again.";

export type CartRequestItem = {
  product_id?: unknown;
  quantity?: unknown;
};

export type ProductRow = {
  id: string;
  price: unknown;
  variants?: unknown;
  is_active: boolean | null;
  stock: unknown;
};

/** A discount_tiers row as read from the database (numeric columns may arrive as strings). */
export type DiscountTierRow = {
  min_subtotal: unknown;
  discount_percent: unknown;
  is_active?: unknown;
};

/** A valid tier in rupees / percent (e.g. { min_subtotal: 3000, discount_percent: 1.4 }). */
export type PricedTier = {
  min_subtotal: number;
  discount_percent: number;
};

export type OrderItemDraft = {
  product_id: string;
  quantity: number;
  price: number;
  variant_label: string | null;
};

export type PricingFailure = {
  ok: false;
  status: 400 | 409;
  error: string;
};

export type PricedCart = {
  ok: true;
  orderItems: OrderItemDraft[];
  subtotalPaise: number;
  /** Percent applied, e.g. 1.4 (0 when no tier applies). */
  discountPercent: number;
  discountPaise: number;
  shippingPaise: number;
  totalPaise: number;
  tier: PricedTier | null;
};

export type CartLine = {
  productId: string;
  variantIndex: number | null;
  quantity: unknown;
};

const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
// Cart ids may carry a variant suffix ("<product-id>:v<index>") when the
// shopper picked a size on the product page.
const VARIANT_ID_PATTERN = /^([0-9a-f-]{36}):v(\d+)$/i;

const fail = (status: 400 | 409, error: string): PricingFailure => ({ ok: false, status, error });

/**
 * Validate the raw `items` array of a checkout request and list the base
 * product ids to load. Every id must be "<uuid>" or "<uuid>:v<index>".
 */
export function parseCartItems(
  items: unknown,
): PricingFailure | { ok: true; lines: CartLine[]; productIds: string[] } {
  if (!Array.isArray(items) || items.length === 0) return fail(400, "Cart is empty");
  if (items.length > MAX_CART_LINES) return fail(400, "Too many cart items");

  const lines: CartLine[] = [];
  for (const item of items as unknown[]) {
    if (!item || typeof item !== "object") return fail(400, "Invalid cart item");
    const { product_id: rawId, quantity } = item as CartRequestItem;
    if (typeof rawId !== "string") return fail(400, "Invalid cart item");
    const variantMatch = rawId.match(VARIANT_ID_PATTERN);
    const baseId = variantMatch ? variantMatch[1] : rawId;
    if (!UUID_PATTERN.test(baseId)) return fail(400, "Invalid cart item");
    lines.push({
      productId: baseId.toLowerCase(),
      variantIndex: variantMatch ? parseInt(variantMatch[2], 10) : null,
      quantity,
    });
  }
  return { ok: true, lines, productIds: [...new Set(lines.map((line) => line.productId))] };
}

// ---------------------------------------------------------------------------
// Discount tiers (keep identical to src/lib/discounts.ts)
// ---------------------------------------------------------------------------

type TierUnits = { minPaise: number; percentHundredths: number };

/** Rupees -> paise or percent -> hundredths; null when not a finite number. */
const toHundredths = (value: unknown): number | null => {
  const n = typeof value === "number"
    ? value
    : typeof value === "string" && value.trim() !== ""
    ? Number(value)
    : NaN;
  if (!Number.isFinite(n)) return null;
  return Math.round(n * 100);
};

/** Drop inactive/invalid rows, keep the best percent per threshold, sort ascending. */
const normalizeTierUnits = (rows: readonly unknown[] | null | undefined): TierUnits[] => {
  const bestByMin = new Map<number, number>();
  for (const row of rows ?? []) {
    if (!row || typeof row !== "object") continue;
    const tier = row as DiscountTierRow;
    if (tier.is_active === false) continue;
    const minPaise = toHundredths(tier.min_subtotal);
    const percentHundredths = toHundredths(tier.discount_percent);
    if (minPaise === null || minPaise <= 0 || !Number.isSafeInteger(minPaise)) continue;
    if (
      percentHundredths === null || percentHundredths <= 0 ||
      percentHundredths > MAX_DISCOUNT_PERCENT_HUNDREDTHS
    ) continue;
    const existing = bestByMin.get(minPaise);
    if (existing === undefined || percentHundredths > existing) bestByMin.set(minPaise, percentHundredths);
  }
  return [...bestByMin.entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([minPaise, percentHundredths]) => ({ minPaise, percentHundredths }));
};

const toPricedTier = (tier: TierUnits): PricedTier => ({
  min_subtotal: tier.minPaise / 100,
  discount_percent: tier.percentHundredths / 100,
});

/** Valid active tiers in ascending order of min_subtotal. */
export function normalizeDiscountTiers(rows: readonly unknown[] | null | undefined): PricedTier[] {
  return normalizeTierUnits(rows).map(toPricedTier);
}

/** The tier discount for a subtotal in paise (integer paise maths, half-up rounding). */
export function calculateTierDiscount(
  subtotalPaise: number,
  rows: readonly unknown[] | null | undefined,
): { tier: PricedTier | null; discountPercent: number; discountPaise: number } {
  if (!Number.isSafeInteger(subtotalPaise) || subtotalPaise <= 0) {
    return { tier: null, discountPercent: 0, discountPaise: 0 };
  }
  let active: TierUnits | null = null;
  for (const tier of normalizeTierUnits(rows)) {
    if (tier.minPaise > subtotalPaise) break;
    active = tier;
  }
  if (!active) return { tier: null, discountPercent: 0, discountPaise: 0 };
  return {
    tier: toPricedTier(active),
    discountPercent: active.percentHundredths / 100,
    discountPaise: Math.round(subtotalPaise * active.percentHundredths / 10_000),
  };
}

// ---------------------------------------------------------------------------
// Cart pricing
// ---------------------------------------------------------------------------

/**
 * Price a cart from authoritative product rows and active discount tiers.
 * Any client-side discount or price is ignored by construction: only
 * `product_id` and `quantity` are read from the request items.
 */
export function priceCart({
  items,
  products,
  tiers,
}: {
  items: unknown;
  products: readonly ProductRow[] | null | undefined;
  tiers: readonly unknown[] | null | undefined;
}): PricingFailure | PricedCart {
  const parsed = parseCartItems(items);
  if (!parsed.ok) return parsed;

  const productMap = new Map(
    (products ?? []).map((product) => [String(product.id).toLowerCase(), product]),
  );
  let subtotalPaise = 0;
  const quantitiesByProduct = new Map<string, number>();
  const orderItems: OrderItemDraft[] = [];

  for (const line of parsed.lines) {
    const pid = line.productId;
    const product = productMap.get(pid);
    if (!product || !product.is_active) return fail(400, `Unavailable product: ${pid}`);

    // Price comes from the DB variant when one was selected, never the client.
    let price = Number(product.price);
    let variantLabel: string | null = null;
    if (line.variantIndex !== null) {
      const variants = Array.isArray(product.variants) ? product.variants : [];
      const variant = variants[line.variantIndex] as { label?: unknown; price?: unknown } | undefined;
      if (!variant) return fail(400, `Invalid variant for ${pid}`);
      price = Number(variant.price ?? product.price);
      variantLabel = typeof variant.label === "string" ? variant.label : null;
    }
    if (!Number.isFinite(price) || price <= 0) return fail(400, `Invalid price for ${pid}`);

    const qty = Number(line.quantity);
    if (!Number.isInteger(qty) || qty < MIN_LINE_QUANTITY || qty > MAX_LINE_QUANTITY) {
      return fail(400, `Invalid quantity for ${pid}`);
    }
    const pricePaise = Math.round(price * 100);
    if (Math.abs(price * 100 - pricePaise) > 0.000001) {
      return fail(400, `Invalid price precision for ${pid}`);
    }

    subtotalPaise += pricePaise * qty;
    quantitiesByProduct.set(pid, (quantitiesByProduct.get(pid) || 0) + qty);
    orderItems.push({ product_id: pid, quantity: qty, price, variant_label: variantLabel });
  }

  for (const [pid, quantity] of quantitiesByProduct) {
    const stock = Number(productMap.get(pid)?.stock);
    if (!Number.isInteger(stock) || stock < quantity) {
      return fail(409, `Insufficient stock for ${pid}`);
    }
  }

  const { tier, discountPercent, discountPaise } = calculateTierDiscount(subtotalPaise, tiers);
  const totalPaise = subtotalPaise - discountPaise + SHIPPING_PAISE;
  if (!Number.isSafeInteger(totalPaise) || totalPaise <= 0) return fail(400, "Invalid order total");

  return {
    ok: true,
    orderItems,
    subtotalPaise,
    discountPercent,
    discountPaise,
    shippingPaise: SHIPPING_PAISE,
    totalPaise,
    tier,
  };
}

/** Rupee amounts returned to the browser and stored on the order. */
export function orderSummary(priced: PricedCart) {
  return {
    subtotal: priced.subtotalPaise / 100,
    discountPercent: priced.discountPercent,
    discountAmount: priced.discountPaise / 100,
    shipping: priced.shippingPaise / 100,
    total: priced.totalPaise / 100,
  };
}

/** The browser must send the total it showed; anything else is a stale cart. */
export function matchesExpectedTotal(expectedTotalPaise: unknown, priced: PricedCart): boolean {
  return Number(expectedTotalPaise) === priced.totalPaise;
}

/** HTTP 409 body for a stale total so the UI can refresh prices/discount. */
export function staleTotalBody(priced: PricedCart) {
  return {
    error: STALE_TOTAL_MESSAGE,
    serverTotalPaise: priced.totalPaise,
    discountPercent: priced.discountPercent,
    discountAmount: priced.discountPaise / 100,
  };
}
