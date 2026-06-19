import React, { useEffect, useRef, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { CheckCircle2, XCircle, Loader2 } from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import { useCart } from '@/contexts/CartContext';

type Status = 'checking' | 'success' | 'failed' | 'pending';

const PaymentStatus = () => {
  const [searchParams] = useSearchParams();
  const orderId = searchParams.get('order');
  const { clearCart } = useCart();
  const [status, setStatus] = useState<Status>('checking');
  const polled = useRef(false);

  useEffect(() => {
    if (!orderId || polled.current) return;
    polled.current = true;

    let attempts = 0;
    const maxAttempts = 5;

    const check = async (): Promise<void> => {
      attempts += 1;
      try {
        const { data, error } = await supabase.functions.invoke('phonepe-status', {
          body: { order: orderId },
        });
        if (error) throw error;

        if (data?.success) {
          clearCart();
          setStatus('success');
          return;
        }
        // PhonePe may still be processing — retry a few times before giving up.
        if (data?.code === 'PAYMENT_PENDING' && attempts < maxAttempts) {
          setStatus('pending');
          setTimeout(check, 3000);
          return;
        }
        setStatus(attempts < maxAttempts && data?.state === 'PENDING' ? 'pending' : 'failed');
        if (attempts < maxAttempts && data?.state === 'PENDING') setTimeout(check, 3000);
      } catch {
        setStatus(attempts < maxAttempts ? 'pending' : 'failed');
        if (attempts < maxAttempts) setTimeout(check, 3000);
      }
    };

    check();
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
                Your payment could not be confirmed. If money was deducted it will be refunded automatically.
                You can try again from your cart.
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
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default PaymentStatus;
