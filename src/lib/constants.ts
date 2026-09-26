// Minimum order value (in ₹) required to place an order online.
// Applies to the cart subtotal, excluding shipping charges.
export const MIN_ORDER_VALUE = 2000;

// Each new cart receives a small surprise discount; it stays fixed while the
// shopper edits quantities so the displayed total does not change unexpectedly.
export const MIN_CART_DISCOUNT_PERCENT = 1;
export const MAX_CART_DISCOUNT_PERCENT = 5;

export const calculateCartDiscount = (subtotal: number, discountPercent: number) =>
  Math.round(Math.round(subtotal * 100) * discountPercent / 100) / 100;
