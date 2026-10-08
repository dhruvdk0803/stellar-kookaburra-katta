import React, { useRef, useState } from 'react';
import { useCart } from '@/contexts/CartContext';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import LocationPicker from '@/components/LocationPicker';
import DiscountProgress from '@/components/checkout/DiscountProgress';
import OrderTotals from '@/components/checkout/OrderTotals';
import PaymentMethodSelector from '@/components/checkout/PaymentMethodSelector';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent } from '@/components/ui/card';
import { ShieldCheck, Loader2, QrCode } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';
import { formatRupees } from '@/lib/money';
import { calculateOrderTotals } from '@/lib/discounts';
import {
  ADDRESS_FIELD_MAX_LENGTH,
  buildCheckoutPayload,
  buildShippingAddress,
  classifyCheckoutFailure,
  EMPTY_CHECKOUT_FORM,
  getCartSubtotal,
  isValidPin,
  STALE_TOTAL_TOAST,
  validateCheckoutForm,
  type CheckoutFailure,
  type CheckoutFormFields,
  type CheckoutPayload,
} from '@/lib/checkout';
import type { DeliveryLocation } from '@/lib/location';
import type { PaymentMethod } from '@/lib/paymentMethods';
import { CART_DISCOUNT_QUERY_KEY, useCartDiscount } from '@/hooks/useCartDiscount';

declare global {
  interface RazorpayPaymentResponse {
    razorpay_order_id: string;
    razorpay_payment_id: string;
    razorpay_signature: string;
  }

  interface RazorpayOptions {
    key: string;
    amount: number;
    currency: string;
    name: string;
    description: string;
    order_id: string;
    handler: (response: RazorpayPaymentResponse) => void | Promise<void>;
    modal?: { ondismiss?: () => void };
    prefill?: { name?: string; contact?: string };
    notes?: Record<string, string>;
    theme?: { color: string };
  }

  interface RazorpayInstance {
    open: () => void;
    on: (event: 'payment.failed', callback: (response: { error?: { description?: string } }) => void) => void;
  }

  interface Window {
    Razorpay?: new (options: RazorpayOptions) => RazorpayInstance;
  }
}

let razorpayScriptPromise: Promise<void> | null = null;

const ensureRazorpayScript = () => {
  if (window.Razorpay) return Promise.resolve();
  if (razorpayScriptPromise) return razorpayScriptPromise;

  razorpayScriptPromise = new Promise<void>((resolve, reject) => {
    const script = document.createElement('script');
    script.src = 'https://checkout.razorpay.com/v1/checkout.js';
    script.async = true;
    script.onload = () => {
      if (window.Razorpay) resolve();
      else {
        razorpayScriptPromise = null;
        script.remove();
        reject(new Error('The Razorpay payment form could not load. Please try again.'));
      }
    };
    script.onerror = () => {
      razorpayScriptPromise = null;
      script.remove();
      reject(new Error('The Razorpay payment form could not load. Check your connection and try again.'));
    };
    document.head.appendChild(script);
  });

  return razorpayScriptPromise;
};

/**
 * Classify a failed supabase.functions.invoke call. A FunctionsHttpError
 * carries the Response, whose status + JSON body tell a stale total (409 with
 * serverTotalPaise) apart from every other error.
 */
const describeFunctionError = async (error: unknown, fallback?: string): Promise<CheckoutFailure> => {
  const message = fallback ?? (error instanceof Error && error.message ? error.message : 'Payment service is unavailable.');
  const context = error && typeof error === 'object' && 'context' in error ? error.context : null;
  if (!(context instanceof Response)) return classifyCheckoutFailure(null, null, message);
  let body: unknown = null;
  try {
    body = await context.json();
  } catch { /* Use the fallback message when the response is not JSON. */ }
  return classifyCheckoutFailure(context.status, body, message);
};

const getFunctionErrorMessage = async (error: unknown): Promise<string> => (await describeFunctionError(error)).message;

const UPI_ORDER_FALLBACK = 'Could not place your order. Please try again.';

interface FieldProps {
  id: string;
  label: string;
  optional?: boolean;
  className?: string;
  children: React.ReactNode;
  after?: React.ReactNode;
}

// Module-level (not defined inside Checkout) so inputs keep focus across re-renders.
const Field = ({ id, label, optional = false, className, children, after }: FieldProps) => (
  <div className={cn('min-w-0 space-y-1.5', className)}>
    <Label htmlFor={id} className="block leading-snug text-gray-700">
      {label}
      {optional && <span className="font-normal text-gray-400"> (optional)</span>}
    </Label>
    {children}
    {after}
  </div>
);

const Checkout = () => {
  const { cart, clearCart } = useCart();
  const { user, isLoading } = useAuth();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const [form, setForm] = useState<CheckoutFormFields>(EMPTY_CHECKOUT_FORM);
  const [pinTouched, setPinTouched] = useState(false);
  const [location, setLocation] = useState<DeliveryLocation | null>(null);
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod>('razorpay');
  const [isSubmitting, setIsSubmitting] = useState(false);
  // Synchronous guard: a fast double click can fire twice before React re-renders the disabled button.
  const submittingRef = useRef(false);

  // The server decides the random discount percent for this exact cart; the
  // rupee maths mirrors the server (whole paise, free shipping) and the edge
  // function recomputes everything, rejecting a mismatch with HTTP 409.
  const { percent: discountPercent, isLoading: discountLoading } = useCartDiscount(cart);
  const subtotal = getCartSubtotal(cart);
  const totals = calculateOrderTotals(subtotal, discountPercent);
  const isUpiOnDelivery = paymentMethod === 'upi_on_delivery';
  const pinInvalid = pinTouched && form.pin !== '' && !isValidPin(form.pin);

  const setField = (field: keyof CheckoutFormFields) => (e: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const unlockSubmit = () => {
    submittingRef.current = false;
    setIsSubmitting(false);
  };

  const handleStaleTotal = () => {
    toast.error(STALE_TOTAL_TOAST);
    // Refetch the discount so the summary (and the next attempt) shows the server's figures.
    void queryClient.invalidateQueries({ queryKey: CART_DISCOUNT_QUERY_KEY });
  };

  /** Returns true once the Razorpay window owns the flow (it unlocks the button itself on dismiss/failure). */
  const startRazorpayPayment = async (payload: CheckoutPayload): Promise<boolean> => {
    await ensureRazorpayScript();
    // Create the Razorpay order server-side. The Edge Function recomputes the
    // total from DB prices and the server-decided random discount, creates the pending
    // order, and returns the Razorpay key id + order id needed to open checkout.
    const { data, error } = await supabase.functions.invoke('razorpay-create-order', { body: payload });

    if (error) {
      const failure = await describeFunctionError(error);
      if (failure.kind === 'stale_total') {
        handleStaleTotal();
        return false;
      }
      throw new Error(failure.message);
    }
    if (data?.error || !data?.rzpOrderId) {
      throw new Error(data?.error || 'Could not start Razorpay payment.');
    }
    const dbOrderId = data.dbOrderId;
    const rzp = new window.Razorpay({
      key: data.keyId,
      amount: data.amount,
      currency: data.currency,
      name: 'Katta Interiors',
      description: 'Order payment',
      order_id: data.rzpOrderId,
      handler: async (response) => {
        // Verify the payment signature server-side, then confirm.
        try {
          const { data: verification, error: verifyError } = await supabase.functions.invoke('razorpay-verify', {
            body: {
              order: dbOrderId,
              razorpay_order_id: response.razorpay_order_id,
              razorpay_payment_id: response.razorpay_payment_id,
              razorpay_signature: response.razorpay_signature,
            },
          });
          if (verifyError) throw new Error(await getFunctionErrorMessage(verifyError));
          // With automatic capture enabled this is normally already
          // confirmed. A short authorised-to-captured delay is handled by
          // the status page and its signed webhook fallback.
          if (verification?.pending) {
            window.location.href = `/payment-status?order=${dbOrderId}`;
            return;
          }
          if (!verification?.verified) {
            throw new Error(verification?.error || 'Payment could not be verified.');
          }
          // Keep the cart until payment succeeds (cleared on the status page).
          window.location.href = `/payment-status?order=${dbOrderId}`;
        } catch (verifyError: unknown) {
          // Razorpay only calls this handler after the shopper has paid, so a
          // verification hiccup must not leave a live Pay button (double charge).
          // The status page keeps polling and the signed webhook can still confirm.
          console.error('Verification error:', verifyError);
          window.location.href = `/payment-status?order=${dbOrderId}`;
        }
      },
      modal: {
        ondismiss: unlockSubmit,
      },
      prefill: {
        name: form.name.trim(),
        contact: payload.phone,
      },
      notes: {
        address: payload.address,
      },
      theme: { color: '#1f2937' },
    });
    rzp.on('payment.failed', (response) => {
      toast.error(response.error?.description || 'Payment was not completed. Please try again.');
      unlockSubmit();
    });
    rzp.open();
    return true;
  };

  /** Returns true once the order is placed and we are leaving the page. */
  const placeUpiOnDeliveryOrder = async (payload: CheckoutPayload): Promise<boolean> => {
    const { data, error } = await supabase.functions.invoke('place-upi-order', { body: payload });

    if (error) {
      const failure = await describeFunctionError(error, UPI_ORDER_FALLBACK);
      if (failure.kind === 'stale_total') {
        handleStaleTotal();
        return false;
      }
      throw new Error(failure.message);
    }
    const dbOrderId = typeof data?.dbOrderId === 'string' ? data.dbOrderId : '';
    if (!dbOrderId) throw new Error(data?.error || UPI_ORDER_FALLBACK);

    // No payment page will clear the cart for a UPI on Delivery order, so do it here.
    clearCart();
    navigate(`/payment-status?order=${encodeURIComponent(dbOrderId)}`, { replace: true });
    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (submittingRef.current) return;
    if (!user) {
      toast.error('You must be logged in to place an order.');
      return;
    }
    if (cart.length === 0) {
      toast.error('Your cart is empty.');
      return;
    }
    if (discountLoading) return;

    const problem = validateCheckoutForm(form);
    if (problem) {
      if (!isValidPin(form.pin)) setPinTouched(true);
      toast.error(problem);
      return;
    }

    const payload = buildCheckoutPayload({
      cart,
      expectedTotalPaise: totals.totalPaise,
      address: buildShippingAddress(form),
      phone: form.phone,
      location,
    });

    submittingRef.current = true;
    setIsSubmitting(true);
    let keepLocked = false;
    try {
      keepLocked = isUpiOnDelivery
        ? await placeUpiOnDeliveryOrder(payload)
        : await startRazorpayPayment(payload);
    } catch (error: unknown) {
      console.error('Checkout error:', error);
      const fallback = isUpiOnDelivery ? UPI_ORDER_FALLBACK : 'Failed to start payment. Please try again.';
      toast.error(error instanceof Error && error.message ? error.message : fallback);
    } finally {
      if (!keepLocked) unlockSubmit();
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!user) {
    return (
      <div className="min-h-screen bg-gray-50 font-poppins flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center py-20 px-4">
          <div className="text-center bg-white p-10 rounded-3xl shadow-sm max-w-md w-full border border-gray-100">
            <h2 className="text-2xl font-playfair font-bold text-gray-900 mb-3">Login Required</h2>
            <p className="text-gray-500 mb-8">Please log in or create an account to securely place your order.</p>
            <div className="flex flex-col space-y-3">
              <Link to="/login">
                <Button className="w-full rounded-full bg-primary hover:bg-primary/90 text-primary-foreground py-6 text-lg">
                  Log In
                </Button>
              </Link>
              <Link to="/register">
                <Button variant="outline" className="w-full rounded-full py-6 text-lg">
                  Create Account
                </Button>
              </Link>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  const totalLabel = `₹${formatRupees(totals.total, true)}`;

  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-8">Checkout</h1>
          <form onSubmit={handleSubmit}>
            {/* Contact Details */}
            <section className="mb-8" aria-labelledby="checkout-contact-heading">
              <h3 id="checkout-contact-heading" className="font-semibold text-gray-900 mb-4">Contact Details</h3>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <Field id="checkout-name" label="Full Name">
                  <Input
                    id="checkout-name"
                    autoComplete="name"
                    maxLength={ADDRESS_FIELD_MAX_LENGTH.name}
                    value={form.name}
                    onChange={setField('name')}
                    disabled={isSubmitting}
                    required
                    className="bg-white"
                  />
                </Field>
                <Field id="checkout-phone" label="Phone Number">
                  <Input
                    id="checkout-phone"
                    type="tel"
                    inputMode="tel"
                    autoComplete="tel"
                    maxLength={16}
                    placeholder="10-digit mobile number"
                    value={form.phone}
                    onChange={setField('phone')}
                    disabled={isSubmitting}
                    required
                    className="bg-white"
                  />
                </Field>
              </div>
            </section>

            {/* Shipping Address */}
            <section className="mb-8" aria-labelledby="checkout-address-heading">
              <h3 id="checkout-address-heading" className="font-semibold text-gray-900 mb-4">Shipping Address</h3>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <Field id="checkout-house" label="House / Flat / Shop No.">
                  <Input
                    id="checkout-house"
                    autoComplete="address-line1"
                    maxLength={ADDRESS_FIELD_MAX_LENGTH.houseNo}
                    value={form.houseNo}
                    onChange={setField('houseNo')}
                    disabled={isSubmitting}
                    required
                    className="bg-white"
                  />
                </Field>
                <Field id="checkout-street" label="Street / Area">
                  <Input
                    id="checkout-street"
                    autoComplete="address-line2"
                    maxLength={ADDRESS_FIELD_MAX_LENGTH.street}
                    value={form.street}
                    onChange={setField('street')}
                    disabled={isSubmitting}
                    required
                    className="bg-white"
                  />
                </Field>
                <Field id="checkout-landmark" label="Landmark" optional className="sm:col-span-2">
                  <Input
                    id="checkout-landmark"
                    autoComplete="off"
                    maxLength={ADDRESS_FIELD_MAX_LENGTH.landmark}
                    placeholder="e.g. Opposite City Mall"
                    value={form.landmark}
                    onChange={setField('landmark')}
                    disabled={isSubmitting}
                    className="bg-white"
                  />
                </Field>
              </div>
              <div className="mt-4 grid grid-cols-1 sm:grid-cols-3 gap-4">
                <Field id="checkout-city" label="City">
                  <Input
                    id="checkout-city"
                    autoComplete="address-level2"
                    maxLength={ADDRESS_FIELD_MAX_LENGTH.city}
                    value={form.city}
                    onChange={setField('city')}
                    disabled={isSubmitting}
                    required
                    className="bg-white"
                  />
                </Field>
                <Field id="checkout-state" label="State">
                  <Input
                    id="checkout-state"
                    autoComplete="address-level1"
                    maxLength={ADDRESS_FIELD_MAX_LENGTH.state}
                    value={form.state}
                    onChange={setField('state')}
                    disabled={isSubmitting}
                    required
                    className="bg-white"
                  />
                </Field>
                <Field
                  id="checkout-pin"
                  label="PIN Code"
                  after={pinInvalid && (
                    <p id="checkout-pin-error" className="text-xs text-red-600">Enter a valid 6-digit PIN code.</p>
                  )}
                >
                  <Input
                    id="checkout-pin"
                    inputMode="numeric"
                    autoComplete="postal-code"
                    pattern="\d{6}"
                    title="6-digit PIN code"
                    maxLength={6}
                    placeholder="6-digit PIN"
                    value={form.pin}
                    onChange={(e) => {
                      const pin = e.target.value.replace(/\D/g, '').slice(0, 6);
                      setForm((prev) => ({ ...prev, pin }));
                    }}
                    onBlur={() => setPinTouched(true)}
                    aria-invalid={pinInvalid || undefined}
                    aria-describedby={pinInvalid ? 'checkout-pin-error' : undefined}
                    disabled={isSubmitting}
                    required
                    className={cn('bg-white', pinInvalid && 'border-red-400 focus-visible:ring-red-400')}
                  />
                </Field>
              </div>
            </section>

            {/* Optional map pin: never blocks checkout (denied/unavailable location just leaves it unset). */}
            <LocationPicker value={location} onChange={setLocation} disabled={isSubmitting} className="mb-8" />

            {/* Payment Method */}
            <div className="mb-8">
              <PaymentMethodSelector value={paymentMethod} onChange={setPaymentMethod} disabled={isSubmitting} />
              <p className="text-xs text-gray-500 mt-3 flex items-start gap-1.5">
                {isUpiOnDelivery ? (
                  <>
                    <QrCode className="h-3.5 w-3.5 mt-px shrink-0" aria-hidden="true" />
                    No payment is taken now. Pay the order total via UPI when your order is delivered.
                  </>
                ) : (
                  <>
                    <ShieldCheck className="h-3.5 w-3.5 mt-px shrink-0" aria-hidden="true" />
                    A secure Razorpay payment window will open to complete payment.
                  </>
                )}
              </p>
            </div>

            {/* Order Summary */}
            <Card className="mb-8 border-gray-200">
              <CardContent className="p-4 sm:p-6">
                <h3 className="font-semibold mb-4">Order Summary</h3>
                <div className="space-y-3 mb-6">
                  {cart.map((item) => (
                    <div key={item.id} className="flex items-center justify-between gap-2 text-sm">
                      <div className="flex min-w-0 flex-1 items-center gap-3">
                        <img src={item.image} alt={item.name} className="h-10 w-10 shrink-0 rounded object-cover" />
                        <span className="min-w-0 break-words">{item.name} <span className="text-gray-500">x{item.quantity}</span></span>
                      </div>
                      <span className="shrink-0 font-medium">₹{formatRupees(item.price * item.quantity)}</span>
                    </div>
                  ))}
                </div>
                <div className="border-t border-gray-100 pt-4">
                  <OrderTotals totals={totals} updating={discountLoading} />
                  <DiscountProgress
                    variant="inline"
                    percent={discountPercent}
                    isLoading={discountLoading}
                    hasItems={cart.length > 0}
                    className="mt-4 rounded-lg bg-emerald-50 px-3 py-2"
                  />
                </div>
              </CardContent>
            </Card>

            <Button
              type="submit"
              disabled={isSubmitting || cart.length === 0 || discountLoading}
              aria-busy={isSubmitting || discountLoading}
              className="w-full rounded-full bg-primary hover:bg-primary/90 text-primary-foreground text-lg py-6 shadow-lg"
            >
              {isSubmitting ? (
                <>
                  <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />
                  <span className="sr-only">{isUpiOnDelivery ? 'Placing your order' : 'Processing payment'}</span>
                </>
              ) : discountLoading ? (
                <>
                  <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />
                  Updating total…
                </>
              ) : isUpiOnDelivery ? (
                `Place Order ${totalLabel}`
              ) : (
                `Pay ${totalLabel}`
              )}
            </Button>
          </form>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Checkout;
