import React from 'react';
import { useCart } from '@/contexts/CartContext';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Trash2, ArrowRight, ShoppingCart } from 'lucide-react';
import { Link } from 'react-router-dom';

const Cart = () => {
  const { cart, updateQuantity, removeFromCart, clearCart } = useCart();

  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const total = subtotal; // GST removed as prices are inclusive

  if (cart.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 font-poppins flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center py-20 px-4">
          <div className="text-center bg-white p-10 rounded-3xl shadow-sm max-w-md w-full border border-gray-100">
            <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <ShoppingCart className="h-10 w-10 text-gray-400" />
            </div>
            <h2 className="text-2xl font-playfair font-bold text-gray-900 mb-3">Your Cart is Empty</h2>
            <p className="text-gray-500 mb-8">Looks like you haven't added anything yet.</p>
            <Link to="/shop">
              <Button className="w-full rounded-full bg-primary hover:bg-primary/90 text-primary-foreground py-6 text-lg">
                Start Shopping
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
      <div className="py-8 md:py-12 px-4">
        <div className="max-w-6xl mx-auto">
          <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-8">Shopping Cart</h1>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2 space-y-4">
              {cart.map((item) => (
                <div key={item.id} className="flex flex-col sm:flex-row items-start sm:items-center gap-4 p-4 bg-white border border-gray-100 rounded-2xl shadow-sm relative">
                  <img src={item.image} alt={item.name} className="w-full sm:w-24 h-40 sm:h-24 object-cover rounded-xl flex-shrink-0" />
                  
                  <div className="flex-1 w-full pr-8 sm:pr-0">
                    <h3 className="font-semibold text-gray-900 text-lg sm:text-base line-clamp-2">{item.name}</h3>
                    <p className="text-primary font-bold mt-1">₹{item.price}</p>
                  </div>
                  
                  <div className="flex items-center justify-between w-full sm:w-auto mt-2 sm:mt-0 border-t sm:border-t-0 border-gray-100 pt-4 sm:pt-0">
                    <div className="flex items-center space-x-3 bg-gray-50 rounded-lg p-1">
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 rounded-md"
                        onClick={() => updateQuantity(item.id, Math.max(1, item.quantity - 1))}
                      >
                        -
                      </Button>
                      <span className="w-8 text-center font-medium">{item.quantity}</span>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 rounded-md"
                        onClick={() => updateQuantity(item.id, item.quantity + 1)}
                      >
                        +
                      </Button>
                    </div>
                    <p className="font-bold text-lg sm:text-base ml-6 sm:ml-8 min-w-[80px] text-right">₹{item.price * item.quantity}</p>
                  </div>

                  <Button 
                    variant="ghost" 
                    size="icon" 
                    onClick={() => removeFromCart(item.id)}
                    className="absolute top-4 right-4 sm:relative sm:top-auto sm:right-auto text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-full"
                  >
                    <Trash2 className="h-5 w-5" />
                  </Button>
                </div>
              ))}
              <div className="flex justify-end pt-4">
                <Button variant="outline" onClick={clearCart} className="rounded-full text-red-600 border-red-200 hover:bg-red-50 hover:text-red-700">
                  Clear Cart
                </Button>
              </div>
            </div>

            <div className="space-y-6">
              <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 sticky top-24">
                <h2 className="text-xl font-semibold text-gray-900 mb-6">Order Summary</h2>
                <div className="space-y-4 text-sm text-gray-600">
                  <div className="flex justify-between">
                    <span>Subtotal (Incl. taxes)</span>
                    <span className="font-medium text-gray-900">₹{subtotal.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between border-t border-gray-100 pt-4 mt-4">
                    <span className="text-base font-bold text-gray-900">Total</span>
                    <span className="text-xl font-bold text-primary">₹{total.toFixed(2)}</span>
                  </div>
                </div>
                <Link to="/checkout" className="block mt-8">
                  <Button className="w-full rounded-full bg-primary hover:bg-primary/90 text-primary-foreground py-6 text-lg flex items-center justify-center gap-2 shadow-md">
                    Proceed to Checkout
                    <ArrowRight className="h-5 w-5" />
                  </Button>
                </Link>
                <p className="text-xs text-gray-500 text-center mt-4">Shipping calculated at checkout</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Cart;