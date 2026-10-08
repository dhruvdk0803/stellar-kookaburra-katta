import assert from 'node:assert/strict';
import test from 'node:test';
import {
  cleanContactPhone,
  countsAsRevenue,
  formatOrderAmount,
  formatOrderDiscount,
  getOrderStatusOptions,
  getPaymentStatusInfo,
} from '../src/lib/adminOrders.ts';

const razorpay = (status, payment_status, extra = {}) => ({
  status,
  payment_provider: 'razorpay',
  payment_method: 'razorpay',
  payment_status,
  ...extra,
});
const upi = (status, extra = {}) => ({
  status,
  payment_provider: 'upi_on_delivery',
  payment_method: 'upi_on_delivery',
  payment_status: 'pending',
  ...extra,
});

test('UPI on Delivery orders progress pending -> delivered without a captured payment', () => {
  assert.deepEqual(getOrderStatusOptions(upi('pending')), ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled']);
  for (const status of ['confirmed', 'processing', 'shipped', 'delivered']) {
    assert.ok(getOrderStatusOptions(upi(status)).includes('delivered'), `${status} can still reach delivered`);
  }
});

test('Razorpay orders offer fulfilment only after capture, and never cancel', () => {
  assert.deepEqual(getOrderStatusOptions(razorpay('pending', 'created')), ['pending']);
  const captured = getOrderStatusOptions(razorpay('confirmed', 'captured', { payment_id: 'pay_1' }));
  assert.deepEqual(captured, ['confirmed', 'processing', 'shipped', 'delivered']);
  assert.ok(!captured.includes('cancelled'));
  assert.ok(!captured.includes('pending'), 'a paid order cannot return to pending');
});

test('payment_method alone marks a Razorpay order, as the database guard does', () => {
  const order = { status: 'pending', payment_method: 'razorpay', payment_provider: null, payment_status: 'created' };
  assert.deepEqual(getOrderStatusOptions(order), ['pending']);
  assert.equal(countsAsRevenue({ ...order, status: 'confirmed' }), false);
});

test('a cancelled order stays cancelled; the current status is always listed', () => {
  assert.deepEqual(getOrderStatusOptions(upi('cancelled')), ['cancelled']);
  assert.deepEqual(getOrderStatusOptions({ status: 'weird' }), ['weird', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled']);
});

test('revenue: Razorpay counts only when captured and being fulfilled', () => {
  assert.equal(countsAsRevenue(razorpay('confirmed', 'captured')), true);
  assert.equal(countsAsRevenue(razorpay('delivered', 'captured')), true);
  assert.equal(countsAsRevenue(razorpay('confirmed', 'created')), false);
  assert.equal(countsAsRevenue(razorpay('pending', 'captured')), false);
  assert.equal(countsAsRevenue(razorpay('cancelled', 'captured')), false);
});

test('revenue: UPI on Delivery counts only once delivered', () => {
  for (const status of ['pending', 'confirmed', 'processing', 'shipped', 'cancelled']) {
    assert.equal(countsAsRevenue(upi(status)), false, status);
  }
  assert.equal(countsAsRevenue(upi('delivered')), true);
  // The UPI rule keys off payment_method too, for rows where the provider is empty.
  assert.equal(countsAsRevenue({ status: 'delivered', payment_method: 'upi_on_delivery' }), true);
  assert.equal(countsAsRevenue({ status: 'shipped', payment_method: 'upi_on_delivery' }), false);
});

test('revenue: legacy orders without payment_method keep the old rules', () => {
  // pre-migration Razorpay order (payment_method column absent)
  assert.equal(countsAsRevenue({ status: 'confirmed', payment_provider: 'razorpay', payment_status: 'captured' }), true);
  assert.equal(countsAsRevenue({ status: 'confirmed', payment_provider: 'razorpay', payment_status: 'created' }), false);
  // ancient orders with no payment info at all
  assert.equal(countsAsRevenue({ status: 'delivered' }), true);
  assert.equal(countsAsRevenue({ status: 'shipped', payment_provider: null, payment_status: null }), true);
  assert.equal(countsAsRevenue({ status: 'pending' }), false);
  assert.equal(countsAsRevenue({ status: 'cancelled' }), false);
});

test('discount text uses Automatic Random Discount wording with the saved amount', () => {
  assert.equal(formatOrderDiscount({ discount_percent: 1.4, discount_amount: 42 }), '1.4% Automatic Random Discount - saved ₹42');
  assert.equal(formatOrderDiscount({ discount_percent: '1', discount_amount: '20.50' }), '1% Automatic Random Discount - saved ₹20.50');
  assert.equal(formatOrderDiscount({ discount_percent: 2.37, discount_amount: 71.1 }), '2.37% Automatic Random Discount - saved ₹71.10');
  assert.equal(formatOrderDiscount({ discount_percent: 1.7, discount_amount: 1234.5 }), '1.7% Automatic Random Discount - saved ₹1,234.50');
  for (const text of [formatOrderDiscount({ discount_percent: 1.4, discount_amount: 42 })]) {
    assert.ok(!/coupon|surprise/i.test(text));
  }
});

test('discount text copes with legacy and partial rows', () => {
  assert.equal(formatOrderDiscount({}), null);
  assert.equal(formatOrderDiscount({ discount_percent: 0, discount_amount: 0 }), null);
  assert.equal(formatOrderDiscount({ discount_percent: null }), null);
  assert.equal(formatOrderDiscount({ discount_percent: 'abc' }), null);
  // percent known, amount missing: worked out from the subtotal when possible, else percent only
  assert.equal(formatOrderDiscount({ discount_percent: 1.4, subtotal_amount: 3000 }), '1.4% Automatic Random Discount - saved ₹42');
  assert.equal(formatOrderDiscount({ discount_percent: 1.4, discount_amount: null }), '1.4% Automatic Random Discount');
});

test('payment status wording', () => {
  assert.deepEqual(getPaymentStatusInfo(upi('pending')), { label: 'Payable on delivery', tone: 'warn' });
  assert.deepEqual(getPaymentStatusInfo(upi('delivered')), { label: 'Collected at delivery', tone: 'good' });
  assert.deepEqual(getPaymentStatusInfo(upi('cancelled')), { label: 'Not collected (cancelled)', tone: 'bad' });
  assert.deepEqual(getPaymentStatusInfo(razorpay('confirmed', 'captured')), { label: 'Paid (captured)', tone: 'good' });
  assert.deepEqual(getPaymentStatusInfo(razorpay('pending', 'created')), { label: 'Awaiting payment', tone: 'warn' });
  assert.deepEqual(getPaymentStatusInfo({ status: 'delivered' }), { label: 'Not recorded', tone: 'neutral' });
  assert.equal(getPaymentStatusInfo({ status: 'x', payment_status: 'authorized' }).label, 'Authorized');
});

test('amount and phone helpers return null for empty values', () => {
  assert.equal(formatOrderAmount(null), null);
  assert.equal(formatOrderAmount(undefined), null);
  assert.equal(formatOrderAmount(''), null);
  assert.equal(formatOrderAmount('x'), null);
  assert.equal(formatOrderAmount(100), '₹100');
  assert.equal(formatOrderAmount('2958.00'), '₹2,958');
  assert.equal(formatOrderAmount(2958.5), '₹2,958.50');
  assert.equal(cleanContactPhone(null), null);
  assert.equal(cleanContactPhone('  '), null);
  assert.equal(cleanContactPhone(' 9876543210 '), '9876543210');
});
