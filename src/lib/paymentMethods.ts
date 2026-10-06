// Payment methods an order can be placed with. Stored on orders.payment_method;
// orders placed before that column existed only carry payment_provider.
export type PaymentMethod = 'razorpay' | 'upi_on_delivery';

export const PAYMENT_METHOD_LABELS: Record<PaymentMethod, string> = {
  razorpay: 'Online payment (Razorpay)',
  upi_on_delivery: 'UPI on Delivery',
};

export const UPI_ON_DELIVERY_DESCRIPTION = 'Pay via UPI when your order is delivered.';

interface PaymentFields {
  payment_method?: string | null;
  payment_provider?: string | null;
}

export const getPaymentMethod = (order: PaymentFields): PaymentMethod | null => {
  const value = order.payment_method || order.payment_provider;
  return value === 'razorpay' || value === 'upi_on_delivery' ? value : null;
};

export const getPaymentMethodLabel = (order: PaymentFields): string => {
  const method = getPaymentMethod(order);
  return method ? PAYMENT_METHOD_LABELS[method] : 'Not recorded';
};

export const isUpiOnDeliveryOrder = (order: PaymentFields): boolean => getPaymentMethod(order) === 'upi_on_delivery';
