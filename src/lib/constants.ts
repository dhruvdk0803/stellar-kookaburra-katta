// Minimum order value (in ₹) required to place an order online.
// Applies to the cart subtotal, excluding shipping charges.
export const MIN_ORDER_VALUE = 2000;

// A cart receives a small surprise discount whenever its contents change.
export const MIN_CART_DISCOUNT_PERCENT = 1;
export const MAX_CART_DISCOUNT_PERCENT = 5;

export const calculateCartDiscount = (subtotal: number, discountPercent: number) =>
  Math.round(subtotal * discountPercent) / 100;
