// Shared checkout pricing for the order edge functions.
//
// PURE TypeScript: no Deno globals and no URL/npm imports, so the edge
// functions and the Node tests (`node --experimental-strip-types`) run exactly
// the same code. Prices always come from database rows, never the browser.
//
// Discount rule (the server is the source of truth): a RANDOM percentage
// between discount_settings.min_percent and max_percent (never above 5%) is
// derived by the SQL function get_cart_discount_percent() from a server-held
// secret and the cart contents, so it changes whenever the cart changes but is
// the same for an identical cart. The edge functions call that RPC and pass the
// result in as `discountPercent`; it applies to the WHOLE subtotal, with no
// minimum order and no tiers. Shipping is free (SHIPPING_PAISE = 0).
//
// The browser never chooses the percent: priceCart() only reads product_id and
// quantity from the request items.

export const SHIPPING_PAISE = 0; // shipping is free on every order
export const MAX_CART_LINES = 50;
export const MIN_LINE_QUANTITY = 1;
export const MAX_LINE_QUANTITY = 100;
/** The random cart discount never exceeds this percent (discount_settings CHECK). */
export const MAX_DISCOUNT_PERCENT = 5;

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

export type OrderItemDraft = {
  product_id: string;
  quantity: number;
  price: number;
  variant_label: string | null;
};

export type PricingFailure = {
  ok: false;
  status: 400 | 409 | 500;
  error: string;
};

export type PricedCart = {
  ok: true;
  orderItems: OrderItemDraft[];
  subtotalPaise: number;
  /** Percent applied, e.g. 2.37 (0 when the discount is off). */
  discountPercent: number;
  discountPaise: number;
  shippingPaise: number;
  totalPaise: number;
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

const fail = (status: 400 | 409 | 500, error: string): PricingFailure => ({ ok: false, status, error });

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
// Random cart discount
// ---------------------------------------------------------------------------

/**
 * Validate a percent returned by get_cart_discount_percent() (PostgREST sends
 * numeric as a number, but accept a numeric string too). Returns the percent
 * rounded to 2 decimals, or null when it is not a finite number in 0..5.
 */
export function normalizeDiscountPercent(value: unknown): number | null {
  const n = typeof value === "number"
    ? value
    : typeof value === "string" && value.trim() !== ""
    ? Number(value)
    : NaN;
  if (!Number.isFinite(n) || n < 0 || n > MAX_DISCOUNT_PERCENT) return null;
  const hundredths = Math.round(n * 100);
  if (Math.abs(n * 100 - hundredths) > 0.000001) return null;
  return hundredths / 100;
}

/** The discount for a subtotal in paise: integer maths on hundredths of a percent, half-up. */
export function calculateDiscountPaise(subtotalPaise: number, discountPercent: number): number {
  const percent = normalizeDiscountPercent(discountPercent);
  if (percent === null || !Number.isSafeInteger(subtotalPaise) || subtotalPaise <= 0) return 0;
  return Math.round(subtotalPaise * Math.round(percent * 100) / 10_000);
}

// ---------------------------------------------------------------------------
// Cart pricing
// ---------------------------------------------------------------------------

/**
 * Price a cart from authoritative product rows and the server-decided discount percent.
 * Any client-side discount or price is ignored by construction: only
 * `product_id` and `quantity` are read from the request items.
 */
export function priceCart({
  items,
  products,
  discountPercent: rawDiscountPercent,
}: {
  items: unknown;
  products: readonly ProductRow[] | null | undefined;
  /** Percent from get_cart_discount_percent() (0..5, <= 2 decimals); never from the browser. */
  discountPercent: unknown;
}): PricingFailure | PricedCart {
  const parsed = parseCartItems(items);
  if (!parsed.ok) return parsed;
  const discountPercent = normalizeDiscountPercent(rawDiscountPercent);
  if (discountPercent === null) return fail(500, "Could not calculate your discount");

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

  const discountPaise = calculateDiscountPaise(subtotalPaise, discountPercent);
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
