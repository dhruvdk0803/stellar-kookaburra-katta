import React, { useState } from 'react';
import { useCart } from '@/contexts/CartContext';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import { Card, CardContent } from '@/components/ui/card';
import { CreditCard, Smartphone, Clock, Loader2 } from 'lucide-react';
import { Link } from 'react-router-dom';
import { toast } from 'sonner';

const Checkout = () => {
  const { cart, clearCart } = useCart();
  const { user, isLoading } = useAuth();
  const [formData, setFormData] = useState({
    name: '', phone: '', address: '', city: '', state: '', zip: '', payment: 'card',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [orderId, setOrderId] = useState('');

  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const shipping = 100;
  const total = subtotal + shipping; // GST removed

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) {
      toast.error("You must be logged in to place an order.");
      return;
    }

    setIsSubmitting(true);

    try {
      // 1. Create the Order
      const fullAddress = `${formData.address}, ${formData.city}, ${formData.state} ${formData.zip}`;
      const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert({
          user_id: user.id,
          total_amount: total,
          address: fullAddress,
          status: 'pending'
        })
        .select()
        .single();

      if (orderError) throw orderError;

      // 2. Create the Order Items
      const orderItems = cart.map(item => ({
        order_id: order.id,
        product_id: item.id,
        quantity: item.quantity,
        price: item.price
      }));

      const { error: itemsError } = await supabase
        .from('order_items')
        .insert(orderItems);

      if (itemsError) throw itemsError;

      // 3. Success
      setOrderId(order.id);
      clearCart();
      setSubmitted(true);
    } catch (error: any) {
      console.error('Checkout error:', error);
      toast.error("Failed to place order. Please ensure your cart contains valid products.");
    } finally {
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

  if (submitted) {
    return (
      <div className="min-h-screen bg-white font-poppins flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center py-20 px-4">
          <div className="text-center max-w-md">
            <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <Clock className="h-10 w-10 text-green-600" />
            </div>
            <h2 className="text-3xl font-playfair font-bold text-gray-900 mb-4">Order Placed Successfully!</h2>
            <p className="text-gray-600 mb-2">Thank you for your purchase.</p>
            <p className="text-sm text-gray-500 mb-8">Order ID: <span className="font-mono">{orderId.slice(0, 8)}...</span></p>
            <Link to="/account">
              <Button className="rounded-full bg-primary hover:bg-primary/90 text-primary-foreground px-8 py-6">
                View My Orders
              </Button>
            </Link>
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

            {/* Payment Methods */}
            <div className="mb-8">
              <h3 className="font-semibold text-gray-900 mb-4">Payment Method</h3>
              <RadioGroup value={formData.payment} onValueChange={(value) => setFormData({ ...formData, payment: value })}>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <Card className="border-gray-200">
                    <CardContent className="p-4 flex items-center space-x-3">
                      <RadioGroupItem value="card" id="card" />
                      <label htmlFor="card" className="cursor-pointer flex items-center space-x-2 w-full">
                        <CreditCard className="h-5 w-5 text-gray-500" />
                        <span>Credit/Debit Card</span>
                      </label>
                    </CardContent>
                  </Card>
                  <Card className="border-gray-200">
                    <CardContent className="p-4 flex items-center space-x-3">
                      <RadioGroupItem value="upi" id="upi" />
                      <label htmlFor="upi" className="cursor-pointer flex items-center space-x-2 w-full">
                        <Smartphone className="h-5 w-5 text-gray-500" />
                        <span>UPI</span>
                      </label>
                    </CardContent>
                  </Card>
                </div>
              </RadioGroup>
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

            <Button 
              type="submit" 
              disabled={isSubmitting || cart.length === 0}
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