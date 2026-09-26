import React, { useEffect, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { CheckCircle2, XCircle, Loader2 } from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import { useCart } from '@/contexts/CartContext';

type Status = 'checking' | 'success' | 'failed' | 'pending' | 'unconfirmed';

const PaymentStatus = () => {
  const [searchParams] = useSearchParams();
  const orderId = searchParams.get('order');
  const { clearCart } = useCart();
  const [status, setStatus] = useState<Status>('checking');
  const [inventoryIssue, setInventoryIssue] = useState(false);

  useEffect(() => {
    if (!orderId) {
      setStatus('unconfirmed');
      return;
    }
    setStatus('checking');
    setInventoryIssue(false);
    let cancelled = false;
    let timer: number | undefined;

    let attempts = 0;
    // The Razorpay checkout handler verifies the signature server-side before
    // redirecting here; poll the order row briefly in case the DB update lands
    // just after the redirect.
    const maxAttempts = 20;

    const check = async (): Promise<void> => {
      attempts += 1;
      const retry = () => {
        if (cancelled) return;
        if (attempts < maxAttempts) {
          setStatus('pending');
          timer = window.setTimeout(check, 3000);
        } else {
          setStatus('unconfirmed');
        }
      };

      try {
        const { data, error } = await supabase
          .from('orders')
          .select('status, payment_status, inventory_issue')
          .eq('id', orderId)
          .single();
        if (error) throw error;
        if (cancelled) return;

        if (data?.payment_status === 'captured' && ['confirmed', 'processing', 'shipped', 'delivered'].includes(data.status)) {
          clearCart();
          setInventoryIssue(data.inventory_issue === true);
          setStatus('success');
          return;
        }
        if (data?.status === 'cancelled') {
          setStatus('failed');
          return;
        }
        retry();
      } catch {
        retry();
      }
    };

    check();
    return () => {
      cancelled = true;
      if (timer !== undefined) window.clearTimeout(timer);
    };
  }, [orderId, clearCart]);

  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 flex items-center justify-center py-20 px-4">
        <div className="text-center max-w-md">
          {(status === 'checking' || status === 'pending') && (
            <>
              <Loader2 className="h-14 w-14 text-primary animate-spin mx-auto mb-6" />
              <h2 className="text-2xl font-playfair font-bold text-gray-900 mb-3">
                {status === 'pending' ? 'Confirming your payment…' : 'Verifying payment…'}
              </h2>
              <p className="text-gray-500">Please don't close this window.</p>
            </>
          )}

          {status === 'success' && (
            <>
              <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <CheckCircle2 className="h-11 w-11 text-green-600" />
              </div>
              <h2 className="text-3xl font-playfair font-bold text-gray-900 mb-4">Payment Successful!</h2>
              <p className="text-gray-600 mb-2">Thank you for your order.</p>
              {inventoryIssue && <p className="mb-4 text-sm text-amber-800">We are checking availability for part of your order and will contact you with an update.</p>}
              {orderId && (
                <p className="text-sm text-gray-500 mb-8">
                  Order ID: <span className="font-mono">{orderId.slice(0, 8)}…</span>
                </p>
              )}
              <Link to="/account">
                <Button className="rounded-full bg-primary hover:bg-primary/90 text-primary-foreground px-8 py-6">
                  View My Orders
                </Button>
              </Link>
            </>
          )}

          {status === 'failed' && (
            <>
              <div className="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <XCircle className="h-11 w-11 text-red-600" />
              </div>
              <h2 className="text-3xl font-playfair font-bold text-gray-900 mb-4">Payment Not Completed</h2>
              <p className="text-gray-600 mb-8">
                This order was cancelled. If you were charged, please contact us with your order ID before trying again.
              </p>
              <div className="flex flex-col sm:flex-row gap-3 justify-center">
                <Link to="/cart">
                  <Button className="rounded-full bg-primary hover:bg-primary/90 text-primary-foreground px-8 py-6 w-full">
                    Back to Cart
                  </Button>
                </Link>
                <Link to="/shop">
                  <Button variant="outline" className="rounded-full px-8 py-6 w-full">
                    Continue Shopping
                  </Button>
                </Link>
              </div>
            </>
          )}

          {status === 'unconfirmed' && (
            <>
              <h2 className="text-2xl font-playfair font-bold text-gray-900 mb-4">Payment status still being checked</h2>
              <p className="text-gray-600 mb-6">Please check your orders before paying again. If you were charged and the order is not confirmed, contact us with your order ID.</p>
              <Link to="/account"><Button className="rounded-full">View My Orders</Button></Link>
            </>
          )}
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default PaymentStatus;
