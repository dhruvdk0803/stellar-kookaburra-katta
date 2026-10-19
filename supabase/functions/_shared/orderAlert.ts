// Values for the owner's "new order" WhatsApp template. Pure (no Deno or
// network imports) so tests/orderAlert.test.mjs can load it directly in Node.
//
// The template (WhatsApp Manager, name `new_order_alert`, category Utility,
// language English) must have exactly these 7 body variables, in this order:
//
//   🛒 New order received: {{1}}
//   Payment: {{2}}
//   Customer: {{3}}, phone {{4}}
//   Items: {{5}}
//   Delivery address: {{6}}
//   Order ID: {{7}}
//   Open the admin panel to process it: https://www.kattainterior.in/admin
//
// Meta rejects variable values containing new lines, tabs or more than four
// spaces in a row, so every value here is a single cleaned line.

export interface OrderAlertOrder {
  id: string;
  total_amount: number | string;
  discount_amount?: number | string | null;
  payment_provider?: string | null;
  address?: string | null;
  contact_phone?: string | null;
  delivery_latitude?: number | string | null;
  delivery_longitude?: number | string | null;
}

export interface OrderAlertItem {
  product_name_snapshot?: string | null;
  variant_label?: string | null;
  quantity: number | string;
  price: number | string;
}

/** Items listed by name before the rest are summarised as "+N more". */
export const MAX_ALERT_ITEMS = 10;
/** Meta allows 1024 characters for the whole body; keep the item list well inside it. */
export const MAX_ITEMS_TEXT = 500;

const rupees = (value: unknown): string => {
  const n = Number(value);
  return `₹${(Number.isFinite(n) ? n : 0).toLocaleString("en-IN", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
};

/** One line, single spaces; empty for non-strings. */
const clean = (value: unknown): string =>
  typeof value === "string" ? value.replace(/\s+/g, " ").trim() : "";

export const paymentLabel = (provider: unknown): string =>
  provider === "upi_on_delivery"
    ? "UPI on Delivery (collect payment at delivery)"
    : provider === "razorpay"
      ? "Paid online (Razorpay)"
      : clean(provider) || "Unknown";

const itemsText = (items: ReadonlyArray<OrderAlertItem>): string => {
  if (items.length === 0) return "-";
  const parts = items.slice(0, MAX_ALERT_ITEMS).map((item) => {
    const name = clean(item.product_name_snapshot) || "Product";
    const variant = clean(item.variant_label);
    const qty = Number(item.quantity) || 0;
    return `${qty} × ${name}${variant ? ` (${variant})` : ""} ${rupees(Number(item.price) * qty)}`;
  });
  let text = parts.join("; ");
  if (items.length > MAX_ALERT_ITEMS) text += `; +${items.length - MAX_ALERT_ITEMS} more`;
  return text.length > MAX_ITEMS_TEXT ? `${text.slice(0, MAX_ITEMS_TEXT - 1)}…` : text;
};

/** The 7 template values, in template order. `customerName` may be empty. */
export function buildOrderAlertParams(
  order: OrderAlertOrder,
  items: ReadonlyArray<OrderAlertItem>,
  customerName: string,
): string[] {
  const discount = Number(order.discount_amount);
  const total = `${rupees(order.total_amount)}${Number.isFinite(discount) && discount > 0 ? ` (after ${rupees(discount)} discount)` : ""}`;

  const lat = Number(order.delivery_latitude);
  const lng = Number(order.delivery_longitude);
  const hasPin = order.delivery_latitude != null && order.delivery_longitude != null &&
    Number.isFinite(lat) && Number.isFinite(lng);
  const address = `${clean(order.address) || "-"}${hasPin ? ` (map: https://maps.google.com/?q=${lat},${lng})` : ""}`;

  return [
    total,
    paymentLabel(order.payment_provider),
    clean(customerName) || "(no name)",
    clean(order.contact_phone) || "-",
    itemsText(items),
    address,
    `#${order.id.slice(0, 8)}`,
  ];
}

/** "+91 98765-43210" -> "919876543210"; a bare 10-digit Indian number gets 91. */
export const toWhatsAppNumber = (raw: string): string => {
  const digits = raw.replace(/\D/g, "");
  return digits.length === 10 ? `91${digits}` : digits;
};
