import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { User, Package, LogOut, Clock, CheckCircle, Truck, Settings, Save, X } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import { toast } from 'sonner';
import { formatRupees } from '@/lib/money';
import { formatDiscountPercent } from '@/lib/discounts';
import { getPaymentMethod, getPaymentMethodLabel, isUpiOnDeliveryOrder, UPI_ON_DELIVERY_DESCRIPTION } from '@/lib/paymentMethods';

interface OrderItemRow {
  id: string;
  quantity: number;
  price: number | string;
  variant_label?: string | null;
  product_name_snapshot?: string | null;
  product_image_snapshot?: string | null;
  products?: { name?: string | null; image_url?: string | null } | null;
}

// Columns added by the 2026-10-05 checkout migration are optional: older
// orders (and databases before the migration) simply don't have them.
interface OrderRow {
  id: string;
  created_at: string;
  status: string;
  total_amount: number | string;
  inventory_issue?: boolean | null;
  payment_method?: string | null;
  payment_provider?: string | null;
  subtotal_amount?: number | string | null;
  discount_percent?: number | string | null;
  discount_amount?: number | string | null;
  shipping_amount?: number | string | null;
  order_items?: OrderItemRow[] | null;
}

const toAmount = (value: unknown): number | null => {
  if (value === null || value === undefined || value === '') return null;
  const amount = Number(value);
  return Number.isFinite(amount) ? amount : null;
};

const Account = () => {
  const { user, profile, signOut, isLoading } = useAuth();
  const navigate = useNavigate();
  const [orders, setOrders] = useState<OrderRow[]>([]);
  const [loadingOrders, setLoadingOrders] = useState(true);
  
  // Profile Edit States
  const [isEditing, setIsEditing] = useState(false);
  const [editName, setEditName] = useState('');
  const [editPhone, setEditPhone] = useState('');
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    if (!isLoading && !user) {
      navigate('/login');
    }
  }, [user, isLoading, navigate]);

  useEffect(() => {
    if (profile) {
      setEditName(profile.name || '');
      setEditPhone(profile.phone || '');
    }
  }, [profile]);

  useEffect(() => {
    const fetchOrders = async () => {
      if (user) {
        const { data } = await supabase
          .from('orders')
          .select('*, order_items(*, products(name, image_url))')
          .eq('user_id', user.id)
          .order('created_at', { ascending: false });
        
        if (data) setOrders(data);
        setLoadingOrders(false);
      }
    };
    fetchOrders();
  }, [user]);

  if (isLoading || !user) {
    return <div className="min-h-screen flex items-center justify-center">Loading...</div>;
  }

  const handleSignOut = async () => {
    await signOut();
    navigate('/');
  };

  const handleSaveProfile = async () => {
    setIsSaving(true);
    const { error } = await supabase
      .from('profiles')
      .update({ name: editName, phone: editPhone })
      .eq('id', user.id);
      
    setIsSaving(false);
    
    if (error) {
      toast.error(error.message);
    } else {
      toast.success('Profile updated successfully!');
      setIsEditing(false);
      // Reload to refresh context
      window.location.reload();
    }
  };

  const getStatusIcon = (status: string) => {
    switch(status.toLowerCase()) {
      case 'delivered': return <CheckCircle className="h-5 w-5 text-green-500" />;
      case 'shipped': return <Truck className="h-5 w-5 text-blue-500" />;
      default: return <Clock className="h-5 w-5 text-orange-500" />;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-5xl mx-auto">
          <div className="flex flex-wrap justify-between items-center gap-4 mb-8">
            <h1 className="text-3xl font-playfair font-bold text-gray-900">My Account</h1>
            {profile?.role === 'admin' && <Button asChild variant="outline"><Link to="/admin">Admin Dashboard</Link></Button>}
          </div>
          
          {/* Profile Card */}
          <Card className="mb-8 border-0 shadow-sm">
            <CardContent className="p-6">
              <div className="flex flex-col sm:flex-row items-center sm:items-start justify-between gap-4">
                <div className="flex items-center space-x-4 w-full sm:w-auto">
                  <div className="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                    <User className="h-8 w-8 text-primary" />
                  </div>
                  
                  {isEditing ? (
                    <div className="space-y-3 w-full sm:w-64">
                      <Input 
                        placeholder="Full Name" 
                        value={editName} 
                        onChange={(e) => setEditName(e.target.value)} 
                      />
                      <Input 
                        placeholder="Phone Number" 
                        value={editPhone} 
                        onChange={(e) => setEditPhone(e.target.value)} 
                      />
                      <div className="flex space-x-2">
                        <Button size="sm" onClick={handleSaveProfile} disabled={isSaving} className="rounded-full">
                          <Save className="w-4 h-4 mr-2" /> Save
                        </Button>
                        <Button size="sm" variant="outline" onClick={() => setIsEditing(false)} className="rounded-full">
                          <X className="w-4 h-4 mr-2" /> Cancel
                        </Button>
                      </div>
                    </div>
                  ) : (
                    <div>
                      <h2 className="text-xl font-semibold text-gray-900">{profile?.name || 'User'}</h2>
                      <p className="text-gray-500">{user.email}</p>
                      {profile?.phone && <p className="text-gray-500 text-sm mt-1">{profile.phone}</p>}
                      <p className="text-xs text-primary mt-2 uppercase tracking-wider font-semibold bg-primary/10 inline-block px-2 py-1 rounded-md">{profile?.role}</p>
                    </div>
                  )}
                </div>
                
                <div className="flex flex-col sm:flex-row gap-3 w-full sm:w-auto">
                  {!isEditing && (
                    <Button variant="outline" onClick={() => setIsEditing(true)} className="rounded-full">
                      <Settings className="w-4 h-4 mr-2" />
                      Edit Profile
                    </Button>
                  )}
                  <Button variant="outline" onClick={handleSignOut} className="text-red-600 hover:text-red-700 hover:bg-red-50 border-red-100 rounded-full">
                    <LogOut className="w-4 h-4 mr-2" />
                    Sign Out
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Order History */}
          <Card className="border-0 shadow-sm">
            <CardContent className="p-6">
              <div className="flex items-center space-x-2 mb-6 border-b border-gray-100 pb-4">
                <Package className="h-6 w-6 text-gray-700" />
                <h2 className="text-2xl font-playfair font-bold text-gray-900">Order History</h2>
              </div>
              
              {loadingOrders ? (
                <p className="text-center text-gray-500 py-8">Loading orders...</p>
              ) : orders.length === 0 ? (
                <div className="text-center py-12">
                  <Package className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-500 mb-4">You haven't placed any orders yet.</p>
                  <Button onClick={() => navigate('/shop')} className="rounded-full">Start Shopping</Button>
                </div>
              ) : (
                <div className="space-y-6">
                  {orders.map((order) => {
                    const hasPaymentMethod = getPaymentMethod(order) !== null;
                    const awaitingUpiPayment = isUpiOnDeliveryOrder(order) && !['cancelled', 'delivered'].includes(String(order.status).toLowerCase());
                    const subtotal = toAmount(order.subtotal_amount);
                    const shipping = toAmount(order.shipping_amount);
                    const discount = toAmount(order.discount_amount);
                    const discountPercent = toAmount(order.discount_percent);
                    const total = toAmount(order.total_amount) ?? 0;
                    return (
                    <div key={order.id} className="border border-gray-100 rounded-2xl p-4 sm:p-6 bg-white hover:shadow-md transition-shadow">
                      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4 gap-4">
                        <div className="min-w-0">
                          <p className="text-sm text-gray-500">Order ID: <span className="font-mono text-gray-900">{order.id.slice(0, 8)}</span></p>
                          <p className="text-sm text-gray-500">Placed on: {new Date(order.created_at).toLocaleDateString()}</p>
                          {hasPaymentMethod && (
                            <p className="text-sm text-gray-500">Payment: <span className="text-gray-900">{getPaymentMethodLabel(order)}</span></p>
                          )}
                          {awaitingUpiPayment && <p className="mt-1 text-xs text-gray-500">{UPI_ON_DELIVERY_DESCRIPTION}</p>}
                        </div>
                        <div className="flex items-center space-x-2 bg-gray-50 px-3 py-1.5 rounded-full">
                          {getStatusIcon(order.status)}
                          <span className="text-sm font-medium capitalize text-gray-700">{order.status}</span>
                        </div>
                      </div>
                      {order.inventory_issue && (
                        <p className="mb-4 rounded-lg bg-amber-50 p-3 text-sm text-amber-800">
                          We are checking availability for part of this order and will contact you with an update.
                        </p>
                      )}
                      
                      <div className="divide-y divide-gray-50">
                        {order.order_items?.map((item) => (
                          <div key={item.id} className="py-3 flex items-center justify-between gap-3">
                            <div className="flex min-w-0 items-center space-x-4">
                              <img 
                                src={item.product_image_snapshot || item.products?.image_url || '/placeholder.svg'}
                                alt={item.product_name_snapshot || item.products?.name || 'Ordered product'}
                                className="w-12 h-12 shrink-0 rounded-md object-cover border border-gray-100"
                              />
                              <div className="min-w-0">
                                <p className="break-words font-medium text-gray-900">
                                  {item.product_name_snapshot || item.products?.name || 'Unknown Product'}
                                  {item.variant_label ? ` (${item.variant_label})` : ''}
                                </p>
                                <p className="text-sm text-gray-500">Qty: {item.quantity}</p>
                              </div>
                            </div>
                            <p className="shrink-0 font-medium text-gray-900">₹{formatRupees(Number(item.price) * item.quantity)}</p>
                          </div>
                        ))}
                      </div>

                      <div className="mt-4 pt-4 border-t border-gray-100 space-y-2">
                        {/* Breakdown only for orders that stored one (placed after the checkout migration). */}
                        {subtotal !== null && (
                          <div className="flex justify-between gap-4 text-sm text-gray-600">
                            <span>Subtotal</span>
                            <span className="whitespace-nowrap">₹{formatRupees(subtotal, true)}</span>
                          </div>
                        )}
                        {discount !== null && discount > 0 && (
                          <div className="flex justify-between gap-4 text-sm font-medium text-emerald-700">
                            <span>Automatic Random Discount{discountPercent ? ` (${formatDiscountPercent(discountPercent)})` : ''}</span>
                            <span className="whitespace-nowrap">−₹{formatRupees(discount, true)}</span>
                          </div>
                        )}
                        {subtotal !== null && shipping !== null && (
                          <div className="flex justify-between gap-4 text-sm text-gray-600">
                            <span>Shipping</span>
                            <span className="whitespace-nowrap">{shipping > 0 ? `₹${formatRupees(shipping, true)}` : 'Free'}</span>
                          </div>
                        )}
                        <div className="flex justify-between items-center gap-4">
                          <span className="text-gray-600">Total Amount</span>
                          <span className="whitespace-nowrap text-xl font-bold text-primary">₹{formatRupees(total, true)}</span>
                        </div>
                      </div>
                    </div>
                    );
                  })}
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Account;
