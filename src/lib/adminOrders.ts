// Order rules used by the Admin dashboard: which statuses an admin may pick, what
// counts as revenue and how an order's payment and discount are described.
//
// Everything here must work for legacy orders, whose newer columns (payment_method,
// subtotal_amount, discount_amount, ...) are NULL or missing entirely.
// Tested by tests/adminOrders.test.mjs (explicit .ts specifiers so Node can load it).

import { getPaymentMethod, isUpiOnDeliveryOrder } from './paymentMethods.ts';
import { formatDiscountPercent } from './discounts.ts';
import { formatRupees } from './money.ts';

export interface AdminOrderFields {
  status: string;
  payment_id?: string | null;
  payment_provider?: string | null;
  payment_method?: string | null;
  payment_status?: string | null;
}

const FULFILMENT_STATUSES = ['confirmed', 'processing', 'shipped', 'delivered'];

/**
 * Same test as the database guard (guard_order_fulfilment): an order is a
 * Razorpay order when EITHER column says so, whichever one is set.
 */
export const isPaidOnlineOrder = (order: Pick<AdminOrderFields, 'payment_provider' | 'payment_method'>): boolean =>
  order.payment_provider === 'razorpay' || order.payment_method === 'razorpay';

/**
 * Statuses an admin may pick. Mirrors the DB trigger on orders: a paid order can
 * not return to pending, a cancelled order can not be reopened, a Razorpay order
 * can not be cancelled here or fulfilled before payment capture. UPI on Delivery
 * orders (and legacy non-Razorpay orders) move pending -> confirmed -> processing
 * -> shipped -> delivered without a captured payment, because the money is
 * collected at the door. The current status is always listed so the select never
 * renders blank.
 */
export const getOrderStatusOptions = (order: AdminOrderFields): string[] => {
  if (order.status === 'cancelled') return ['cancelled'];
  const paidOnline = isPaidOnlineOrder(order);
  const options: string[] = [];
  if (!order.payment_id && order.payment_status !== 'captured') options.push('pending');
  if (!paidOnline || order.payment_status === 'captured') options.push(...FULFILMENT_STATUSES);
  if (!paidOnline) options.push('cancelled');
  if (!options.includes(order.status)) options.unshift(order.status);
  return options;
};

/**
 * Whether an order's total is counted as revenue (dashboard total and chart).
 *  - Razorpay: only once the payment is captured and the order is being fulfilled.
 *  - UPI on Delivery: only once delivered (the customer pays by UPI at handover).
 *  - Legacy orders: any fulfilled status, unchanged from before.
 */
export const countsAsRevenue = (order: AdminOrderFields): boolean => {
  if (!FULFILMENT_STATUSES.includes(order.status)) return false;
  if (isPaidOnlineOrder(order)) return order.payment_status === 'captured';
  if (isUpiOnDeliveryOrder(order)) return order.status === 'delivered';
  return true;
};

export interface PaymentStatusInfo {
  label: string;
  tone: 'good' | 'warn' | 'bad' | 'neutral';
}

const capitalise = (text: string) => text.charAt(0).toUpperCase() + text.slice(1).toLowerCase();

/** Short human wording for an order's payment state. Never throws, never empty. */
export const getPaymentStatusInfo = (order: AdminOrderFields): PaymentStatusInfo => {
  const method = getPaymentMethod(order);
  const raw = typeof order.payment_status === 'string' ? order.payment_status.trim().toLowerCase() : '';

  if (method === 'upi_on_delivery') {
    if (order.status === 'delivered') return { label: 'Collected at delivery', tone: 'good' };
    if (order.status === 'cancelled') return { label: 'Not collected (cancelled)', tone: 'bad' };
    return { label: 'Payable on delivery', tone: 'warn' };
  }
  if (raw === 'captured') return { label: 'Paid (captured)', tone: 'good' };
  if (raw === 'created' || raw === 'pending') return { label: 'Awaiting payment', tone: 'warn' };
  if (raw === 'failed' || raw === 'refunded') return { label: capitalise(raw), tone: 'bad' };
  if (raw) return { label: capitalise(raw), tone: 'neutral' };
  return { label: 'Not recorded', tone: 'neutral' };
};

const formatRupeeAmount = (amount: number): string =>
  `₹${formatRupees(amount, !Number.isInteger(Math.round(amount * 100) / 100))}`;

/** A saved amount as ₹ text, or null when the column is empty or not a number. */
export const formatOrderAmount = (value: unknown): string | null => {
  if (value === null || value === undefined || value === '') return null;
  const amount = Number(value);
  return Number.isFinite(amount) ? formatRupeeAmount(amount) : null;
};

/**
 * "1.4% Automatic Random Discount - saved ₹42", or null when the order had no
 * discount. The amount is stored on the order; when an old order has only the
 * percent, the saving is worked out from its subtotal when that is known.
 */
export const formatOrderDiscount = (order: {
  discount_percent?: number | string | null;
  discount_amount?: number | string | null;
  subtotal_amount?: number | string | null;
}): string | null => {
  const percent = Number(order.discount_percent);
  if (!Number.isFinite(percent) || percent <= 0) return null;
  const stored = order.discount_amount === null || order.discount_amount === undefined || order.discount_amount === ''
    ? NaN
    : Number(order.discount_amount);
  const subtotal = Number(order.subtotal_amount);
  const saved = Number.isFinite(stored)
    ? stored
    : Number.isFinite(subtotal) && subtotal > 0
      ? Math.round(subtotal * percent) / 100
      : null;
  const label = `${formatDiscountPercent(percent)} Automatic Random Discount`;
  return saved === null ? label : `${label} - saved ${formatRupeeAmount(saved)}`;
};

/** A saved phone number trimmed, or null. */
export const cleanContactPhone = (value: unknown): string | null => {
  if (typeof value !== 'string') return null;
  const phone = value.trim();
  return phone === '' ? null : phone;
};
