import React, { useState } from 'react';
import { useCart } from '@/contexts/CartContext';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { Smartphone, ShieldCheck, Loader2, AlertCircle } from 'lucide-react';
import { Link } from 'react-router-dom';
import { toast } from 'sonner';
import { MIN_ORDER_VALUE } from '@/lib/constants';

const Checkout = () => {
  const { cart, clearCart } = useCart();
  const { user, isLoading } = useAuth();
  const [formData, setFormData] = useState({
    name: '', phone: '', address: '', city: '', state: '', zip: '',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);

  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const shipping = 100;
  const total = subtotal + shipping; // GST removed
  // Minimum order value is checked on the cart subtotal, excluding shipping.
  const meetsMinimum = subtotal >= MIN_ORDER_VALUE;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) {
      toast.error("You must be logged in to place an order.");
      return;
    }
    if (!meetsMinimum) {
      toast.error(`Minimum order value is ₹${MIN_ORDER_VALUE.toLocaleString('en-IN')}. Please add more items to your cart.`);
      return;
    }

    setIsSubmitting(true);

    try {
      // Hand the order off to PhonePe. The Edge Function recomputes the total
      // from DB prices, creates the order, and returns the hosted checkout URL.
      const fullAddress = `${formData.address}, ${formData.city}, ${formData.state} ${formData.zip}`;
      const { data, error } = await supabase.functions.invoke('phonepe-pay', {
        body: {
          items: cart.map((item) => ({ product_id: item.id, quantity: item.quantity })),
          address: fullAddress,
          phone: formData.phone,
        },
      });

      if (error) throw error;
      if (data?.error || !data?.redirectUrl) {
        throw new Error(data?.error || 'Could not start PhonePe payment.');
      }

      // Keep the cart until payment succeeds (cleared on the status page).
      window.location.href = data.redirectUrl;
    } catch (error: any) {
      console.error('Checkout error:', error);
      toast.error(error?.message || 'Failed to start payment. Please try again.');
      setIsSubmitting(false);
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

  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-8">Checkout</h1>
          <form onSubmit={handleSubmit}>
            {/* Contact Info */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
              <Input
                placeholder="Full Name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
                className="bg-white"
              />
              <Input
                type="tel"
                placeholder="Phone Number"
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                required
                className="bg-white"
              />
            </div>

            {/* Shipping Address */}
            <div className="space-y-4 mb-8">
              <h3 className="font-semibold text-gray-900">Shipping Address</h3>
              <Input
                placeholder="Street Address"
                value={formData.address}
                onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                required
                className="bg-white"
              />
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <Input
                  placeholder="City"
                  value={formData.city}
                  onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                  required
                  className="bg-white"
                />
                <Input
                  placeholder="State"
                  value={formData.state}
                  onChange={(e) => setFormData({ ...formData, state: e.target.value })}
                  required
                  className="bg-white"
                />
                <Input
                  placeholder="ZIP Code"
                  value={formData.zip}
                  onChange={(e) => setFormData({ ...formData, zip: e.target.value })}
                  required
                  className="bg-white"
                />
              </div>
            </div>

            {/* Payment Method */}
            <div className="mb-8">
              <h3 className="font-semibold text-gray-900 mb-4">Payment Method</h3>
              <Card className="border-primary/30 bg-primary/5">
                <CardContent className="p-4 flex items-center gap-3">
                  <div className="h-10 w-10 rounded-full bg-[#5f259f] flex items-center justify-center flex-shrink-0">
                    <Smartphone className="h-5 w-5 text-white" />
                  </div>
                  <div className="flex-1">
                    <p className="font-medium text-gray-900">PhonePe</p>
                    <p className="text-sm text-gray-500">Pay securely via UPI, cards, wallets &amp; net banking</p>
                  </div>
                </CardContent>
              </Card>
              <p className="text-xs text-gray-400 mt-2 flex items-center gap-1">
                <ShieldCheck className="h-3.5 w-3.5" />
                You'll be redirected to PhonePe's secure checkout to complete payment.
              </p>
            </div>

            {/* Order Summary */}
            <Card className="mb-8 border-gray-200">
              <CardContent className="p-6">
                <h3 className="font-semibold mb-4">Order Summary</h3>
                <div className="space-y-3 mb-6">
                  {cart.map((item) => (
                    <div key={item.id} className="flex justify-between text-sm items-center">
                      <div className="flex items-center gap-3">
                        <img src={item.image} alt={item.name} className="w-10 h-10 rounded object-cover" />
                        <span>{item.name} <span className="text-gray-500">x{item.quantity}</span></span>
                      </div>
                      <span className="font-medium">₹{item.price * item.quantity}</span>
                    </div>
                  ))}
                </div>
                <div className="space-y-2 text-sm border-t border-gray-100 pt-4">
                  <div className="flex justify-between text-gray-600"><span>Subtotal (Incl. taxes):</span> <span>₹{subtotal}</span></div>
                  <div className="flex justify-between text-gray-600"><span>Shipping:</span> <span>₹{shipping}</span></div>
                  <div className="flex justify-between font-bold text-lg pt-2 text-gray-900">
                    <span>Total:</span> <span>₹{total.toFixed(2)}</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            {!meetsMinimum && (
              <div className="mb-6 flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4">
                <AlertCircle className="h-5 w-5 text-amber-600 flex-shrink-0 mt-0.5" />
                <div className="text-sm text-amber-800">
                  <p className="font-semibold">Minimum order value is ₹{MIN_ORDER_VALUE.toLocaleString('en-IN')}</p>
                  <p className="mt-1">
                    Your cart subtotal is ₹{subtotal.toFixed(2)}. Add ₹{(MIN_ORDER_VALUE - subtotal).toFixed(2)} more to place this order.{' '}
                    <Link to="/shop" className="underline font-medium">Continue shopping</Link>
                  </p>
                </div>
              </div>
            )}

            <Button 
              type="submit" 
              disabled={isSubmitting || cart.length === 0 || !meetsMinimum}
              className="w-full rounded-full bg-primary hover:bg-primary/90 text-primary-foreground text-lg py-6 shadow-lg"
            >
              {isSubmitting ? <Loader2 className="h-5 w-5 animate-spin" /> : `Pay ₹${total.toFixed(2)}`}
            </Button>
          </form>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Checkout;