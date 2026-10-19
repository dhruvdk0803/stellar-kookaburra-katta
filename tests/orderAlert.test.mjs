import assert from 'node:assert/strict';
import test from 'node:test';
import {
  buildOrderAlertParams,
  MAX_ALERT_ITEMS,
  MAX_ITEMS_TEXT,
  paymentLabel,
  toWhatsAppNumber,
} from '../supabase/functions/_shared/orderAlert.ts';

const order = {
  id: '0f1e2d3c-4b5a-6978-8091-a2b3c4d5e6f7',
  total_amount: 12345.5,
  discount_amount: '123.45',
  payment_provider: 'upi_on_delivery',
  address: '  12, MG Road,\n Jaipur  ',
  contact_phone: '9876543210',
  delivery_latitude: 26.9124,
  delivery_longitude: 75.7873,
};
const items = [
  { product_name_snapshot: 'Ebco Hinge', variant_label: 'Full Overlay', quantity: 2, price: '436' },
  { product_name_snapshot: null, variant_label: null, quantity: '1', price: 99.5 },
];

test('seven template values in template order', () => {
  assert.deepEqual(buildOrderAlertParams(order, items, 'Ramesh'), [
    '₹12,345.50 (after ₹123.45 discount)',
    'UPI on Delivery (collect payment at delivery)',
    'Ramesh',
    '9876543210',
    '2 × Ebco Hinge (Full Overlay) ₹872.00; 1 × Product ₹99.50',
    '12, MG Road, Jaipur (map: https://maps.google.com/?q=26.9124,75.7873)',
    '#0f1e2d3c',
  ]);
});

test('Meta rule: no value has new lines, tabs or 5+ spaces in a row, and none is empty', () => {
  const messy = { ...order, address: 'Line 1\n\tLine 2      end', contact_phone: null };
  for (const value of buildOrderAlertParams(messy, [{ product_name_snapshot: 'A\nB', quantity: 1, price: 1 }], '\n')) {
    assert.doesNotMatch(value, /[\n\t]| {5,}/, value);
    assert.ok(value.length > 0);
  }
});

test('missing name, phone, pin, items and discount degrade gracefully', () => {
  const p = buildOrderAlertParams(
    { id: order.id, total_amount: 500, discount_amount: 0, payment_provider: 'razorpay', delivery_latitude: null, delivery_longitude: null },
    [],
    '  ',
  );
  assert.deepEqual(p, ['₹500.00', 'Paid online (Razorpay)', '(no name)', '-', '-', '-', '#0f1e2d3c']);
  assert.equal(paymentLabel('other_gateway'), 'other_gateway');
});

test('long carts are summarised and capped', () => {
  const many = Array.from({ length: MAX_ALERT_ITEMS + 3 }, (_, i) => ({ product_name_snapshot: `P${i}`, quantity: 1, price: 1 }));
  assert.match(buildOrderAlertParams(order, many, 'x')[4], /; \+3 more$/);
  const huge = Array.from({ length: 8 }, () => ({ product_name_snapshot: 'X'.repeat(200), quantity: 1, price: 1 }));
  assert.ok(buildOrderAlertParams(order, huge, 'x')[4].length <= MAX_ITEMS_TEXT);
});

test('owner number normalised for the API', () => {
  assert.equal(toWhatsAppNumber('+91 98765-43210'), '919876543210');
  assert.equal(toWhatsAppNumber('9876543210'), '919876543210');
  assert.equal(toWhatsAppNumber('919876543210'), '919876543210');
});
