import React, { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import { toast } from 'sonner';
import { Auth } from '@supabase/auth-ui-react';
import { ThemeSupa } from '@supabase/auth-ui-shared';
import { Loader2, LogOut, Package, Tags, ShoppingBag, Edit2, X, DollarSign, Activity, LayoutDashboard, ChevronDown, ChevronUp, Upload, Image as ImageIcon, FileSpreadsheet, Wrench } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';

const Admin = () => {
  const { user, profile, isLoading, signOut } = useAuth();
  const navigate = useNavigate();
  
  const [categories, setCategories] = useState<any[]>([]);
  const [products, setProducts] = useState<any[]>([]);
  const [orders, setOrders] = useState<any[]>([]);
  const [expandedOrderId, setExpandedOrderId] = useState<string | null>(null);

  // Category Form States
  const [catName, setCatName] = useState('');
  const [catSlug, setCatSlug] = useState('');
  const [catParentId, setCatParentId] = useState('');
  
  // Product Form States
  const [editingProductId, setEditingProductId] = useState<string | null>(null);
  const [prodName, setProdName] = useState('');
  const [prodPrice, setProdPrice] = useState('');
  const [prodDesc, setProdDesc] = useState('');
  const [prodCat, setProdCat] = useState('');
  const [prodStock, setProdStock] = useState('100');
  const [prodImages, setProdImages] = useState<string[]>([]);
  const [isUploadingImages, setIsUploadingImages] = useState(false);
  const [isUploadingBulk, setIsUploadingBulk] = useState(false);
  const [isFixingDescriptions, setIsFixingDescriptions] = useState(false);

  useEffect(() => {
    if (profile?.role === 'admin') {
      fetchData();
    }
  }, [profile]);

  const fetchData = async () => {
    const [catRes, prodRes, ordRes] = await Promise.all([
      supabase.from('categories').select('*, parent:parent_id(name)').order('created_at', { ascending: false }),
      supabase.from('products').select('*, categories(name)').order('created_at', { ascending: false }),
      supabase.from('orders').select('*, profiles(name), order_items(*, products(name, image_url, images))').order('created_at', { ascending: false })
    ]);
    if (catRes.data) setCategories(catRes.data);
    if (prodRes.data) setProducts(prodRes.data);
    if (ordRes.data) setOrders(ordRes.data);
  };

  // --- Chart Data Processing ---
  const chartData = useMemo(() => {
    if (!orders.length) return [];
    
    // Get last 7 days
    const days = [...Array(7)].map((_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - i);
      return d.toISOString().split('T')[0];
    }).reverse();

    return days.map(date => {
      const dayOrders = orders.filter(o => o.created_at.startsWith(date) && o.status !== 'cancelled');
      return {
        date: new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
        revenue: dayOrders.reduce((sum, o) => sum + o.total_amount, 0),
        orders: dayOrders.length
      };
    });
  }, [orders]);

  // --- Category Actions ---
  const handleAddCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    const newCat: any = { name: catName, slug: catSlug };
    if (catParentId) newCat.parent_id = catParentId;

    const { error } = await supabase.from('categories').insert([newCat]);
    if (error) toast.error(error.message);
    else { toast.success('Category added!'); setCatName(''); setCatSlug(''); setCatParentId(''); fetchData(); }
  };

  const handleDeleteCategory = async (id: string) => {
    if (!confirm('Delete this category? Products linked to it might be affected.')) return;
    const { error } = await supabase.from('categories').delete().eq('id', id);
    if (error) toast.error(error.message);
    else { toast.success('Category deleted'); fetchData(); }
  };

  // --- Product Actions ---
  const resetProductForm = () => {
    setProdName(''); setProdPrice(''); setProdDesc(''); setProdCat(''); setProdStock('100'); setProdImages([]);
    setEditingProductId(null);
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    if (!files.length) return;
    
    if (prodImages.length + files.length > 50) {
      toast.error("You can only upload up to 50 images per product.");
      return;
    }

    setIsUploadingImages(true);
    const newImageUrls: string[] = [];

    for (const file of files) {
      const fileExt = file.name.split('.').pop();
      const fileName = `${Math.random().toString(36).substring(2, 15)}.${fileExt}`;
      const filePath = `${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('product-images')
        .upload(filePath, file);

      if (uploadError) {
        toast.error(`Failed to upload ${file.name}: ${uploadError.message}`);
        continue;
      }

      const { data } = supabase.storage.from('product-images').getPublicUrl(filePath);
      newImageUrls.push(data.publicUrl);
    }

    setProdImages(prev => [...prev, ...newImageUrls]);
    setIsUploadingImages(false);
    e.target.value = '';
  };

  const removeImage = (indexToRemove: number) => {
    setProdImages(prev => prev.filter((_, index) => index !== indexToRemove));
  };

  const handleSaveProduct = async (e: React.FormEvent) => {
    e.preventDefault();
    const productData = {
      name: prodName, 
      price: parseFloat(prodPrice), 
      description: prodDesc,
      category_id: prodCat, 
      stock: parseInt(prodStock),
      images: prodImages,
      image_url: prodImages.length > 0 ? prodImages[0] : null
    };

    if (editingProductId) {
      const { error } = await supabase.from('products').update(productData).eq('id', editingProductId);
      if (error) toast.error(error.message);
      else { toast.success('Product updated!'); resetProductForm(); fetchData(); }
    } else {
      const { error } = await supabase.from('products').insert([productData]);
      if (error) toast.error(error.message);
      else { toast.success('Product added!'); resetProductForm(); fetchData(); }
    }
  };

  const handleEditClick = (product: any) => {
    setEditingProductId(product.id);
    setProdName(product.name);
    setProdPrice(product.price.toString());
    setProdDesc(product.description || '');
    setProdCat(product.category_id || '');
    setProdStock(product.stock?.toString() || '0');
    
    let imgs = product.images || [];
    if (imgs.length === 0 && product.image_url) imgs = [product.image_url];
    setProdImages(imgs);
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleDeleteProduct = async (id: string) => {
    if (!confirm('Are you sure you want to delete this product?')) return;
    const { error } = await supabase.from('products').delete().eq('id', id);
    if (error) toast.error(error.message);
    else { toast.success('Product deleted'); fetchData(); }
  };

  // --- Bulk Upload ---
  const handleBulkUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setIsUploadingBulk(true);
    try {
      const text = await file.text();
      const lines = text.split('\n');
      const headers = lines[0].toLowerCase().split(',').map(h => h.trim());
      
      const productsToInsert = [];
      
      for (let i = 1; i < lines.length; i++) {
        if (!lines[i].trim()) continue;
        const values = lines[i].split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/).map(v => v.replace(/^"|"$/g, '').trim());
        
        const product: any = {};
        headers.forEach((header, index) => {
          if (header === 'price' || header === 'stock') {
            product[header] = parseFloat(values[index]) || 0;
          } else if (header === 'images') {
            const urls = values[index] ? values[index].split(';').map(url => url.trim()) : [];
            product['images'] = urls;
            if (urls.length > 0) product['image_url'] = urls[0];
          } else {
            product[header] = values[index];
          }
        });
        
        product.is_active = true;
        productsToInsert.push(product);
      }

      if (productsToInsert.length > 0) {
        const { error } = await supabase.from('products').insert(productsToInsert);
        if (error) throw error;
        toast.success(`Successfully uploaded ${productsToInsert.length} products!`);
        fetchData();
      }
    } catch (error: any) {
      toast.error(`Bulk upload failed: ${error.message}`);
    } finally {
      setIsUploadingBulk(false);
      e.target.value = '';
    }
  };

  // --- Quick Fixes ---
  const handleFixDescriptions = async () => {
    setIsFixingDescriptions(true);
    try {
      const { data, error } = await supabase
        .from('products')
        .select('id, description')
        .ilike('description', '%Acrylic sheets are positioned%');
        
      if (error) throw error;
      
      if (data && data.length > 0) {
        let count = 0;
        for (const product of data) {
          if (product.description) {
            // Remove the specific line and any extra whitespace
            const newDesc = product.description
              .replace('👉 Acrylic sheets are positioned as more premium than Sunmica — highlight this clearly.', '')
              .replace('👉 Acrylic sheets are positioned as more premium than Sunmica - highlight this clearly.', '')
              .trim();
              
            await supabase.from('products').update({ description: newDesc }).eq('id', product.id);
            count++;
          }
        }
        toast.success(`Fixed descriptions for ${count} products!`);
        fetchData();
      } else {
        toast.info('No products found with that description line.');
      }
    } catch (error: any) {
      toast.error(`Failed to fix descriptions: ${error.message}`);
    } finally {
      setIsFixingDescriptions(false);
    }
  };

  // --- Order Actions ---
  const handleUpdateOrderStatus = async (id: string, status: string) => {
    const { error } = await supabase.from('orders').update({ status }).eq('id', id);
    if (error) toast.error(error.message);
    else { toast.success('Order status updated'); fetchData(); }
  };

  const toggleOrderDetails = (id: string) => {
    setExpandedOrderId(expandedOrderId === id ? null : id);
  };

  const handleSignOut = async () => {
    await signOut();
    navigate('/');
  };

  if (isLoading) return <div className="min-h-screen flex items-center justify-center"><Loader2 className="h-8 w-8 animate-spin text-primary" /></div>;

  if (!user || (profile && profile.role !== 'admin')) {
    return (
      <div className="min-h-screen bg-gray-50 flex flex-col font-poppins">
        <Navigation />
        <div className="flex-1 flex items-center justify-center py-12 px-4">
          <div className="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100 text-center">
            <h1 className="text-3xl font-playfair font-bold text-red-600 mb-4">Access Denied</h1>
            <p className="text-gray-600 mb-8">You do not have administrator privileges.</p>
            <Button onClick={() => navigate('/')} className="w-full rounded-full">Return to Home</Button>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  const totalRevenue = orders.filter(o => o.status !== 'cancelled').reduce((sum, o) => sum + o.total_amount, 0);

  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4 max-w-7xl mx-auto">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-playfair font-bold text-gray-900">Admin Dashboard</h1>
          <Button variant="outline" onClick={handleSignOut} className="text-red-600 hover:text-red-700 hover:bg-red-50 rounded-full">
            <LogOut className="w-4 h-4 mr-2" /> Sign Out
          </Button>
        </div>
        
        <Tabs defaultValue="overview" className="w-full">
          <TabsList className="grid w-full grid-cols-4 mb-8 bg-white p-1 rounded-xl shadow-sm border border-gray-100">
            <TabsTrigger value="overview" className="rounded-lg py-3"><LayoutDashboard className="w-4 h-4 mr-2 hidden sm:block" /> Overview</TabsTrigger>
            <TabsTrigger value="orders" className="rounded-lg py-3"><ShoppingBag className="w-4 h-4 mr-2 hidden sm:block" /> Orders</TabsTrigger>
            <TabsTrigger value="products" className="rounded-lg py-3"><Package className="w-4 h-4 mr-2 hidden sm:block" /> Products</TabsTrigger>
            <TabsTrigger value="categories" className="rounded-lg py-3"><Tags className="w-4 h-4 mr-2 hidden sm:block" /> Categories</TabsTrigger>
          </TabsList>

          {/* OVERVIEW TAB */}
          <TabsContent value="overview" className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <Card className="border-0 shadow-sm"><CardContent className="p-6 flex items-center space-x-4"><div className="p-4 bg-green-100 rounded-full"><DollarSign className="h-8 w-8 text-green-600" /></div><div><p className="text-sm font-medium text-gray-500">Total Revenue</p><h3 className="text-2xl font-bold text-gray-900">₹{totalRevenue.toLocaleString()}</h3></div></CardContent></Card>
              <Card className="border-0 shadow-sm"><CardContent className="p-6 flex items-center space-x-4"><div className="p-4 bg-blue-100 rounded-full"><ShoppingBag className="h-8 w-8 text-blue-600" /></div><div><p className="text-sm font-medium text-gray-500">Total Orders</p><h3 className="text-2xl font-bold text-gray-900">{orders.length}</h3></div></CardContent></Card>
              <Card className="border-0 shadow-sm"><CardContent className="p-6 flex items-center space-x-4"><div className="p-4 bg-purple-100 rounded-full"><Package className="h-8 w-8 text-purple-600" /></div><div><p className="text-sm font-medium text-gray-500">Active Products</p><h3 className="text-2xl font-bold text-gray-900">{products.length}</h3></div></CardContent></Card>
            </div>

            {/* Charts Section */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card className="border-0 shadow-sm">
                <CardHeader>
                  <CardTitle className="text-lg font-semibold text-gray-800">Revenue (Last 7 Days)</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="h-[300px] w-full">
                    <ResponsiveContainer width="100%" height="100%">
                      <AreaChart data={chartData} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                        <defs>
                          <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="5%" stopColor="#0d9488" stopOpacity={0.3}/>
                            <stop offset="95%" stopColor="#0d9488" stopOpacity={0}/>
                          </linearGradient>
                        </defs>
                        <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                        <XAxis dataKey="date" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dy={10} />
                        <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} tickFormatter={(value) => `₹${value}`} />
                        <Tooltip 
                          contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                          formatter={(value: number) => [`₹${value.toLocaleString()}`, 'Revenue']}
                        />
                        <Area type="monotone" dataKey="revenue" stroke="#0d9488" strokeWidth={3} fillOpacity={1} fill="url(#colorRevenue)" />
                      </AreaChart>
                    </ResponsiveContainer>
                  </div>
                </CardContent>
              </Card>

              <Card className="border-0 shadow-sm">
                <CardHeader>
                  <CardTitle className="text-lg font-semibold text-gray-800">Orders (Last 7 Days)</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="h-[300px] w-full">
                    <ResponsiveContainer width="100%" height="100%">
                      <BarChart data={chartData} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                        <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                        <XAxis dataKey="date" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dy={10} />
                        <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} allowDecimals={false} />
                        <Tooltip 
                          contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                          cursor={{ fill: '#f3f4f6' }}
                        />
                        <Bar dataKey="orders" fill="#3b82f6" radius={[4, 4, 0, 0]} maxBarSize={40} />
                      </BarChart>
                    </ResponsiveContainer>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          {/* ORDERS TAB */}
          <TabsContent value="orders">
            <Card className="border-0 shadow-sm">
              <CardHeader><CardTitle>Manage Orders ({orders.length})</CardTitle></CardHeader>
              <CardContent>
                <div className="overflow-x-auto">
                  <table className="w-full text-sm text-left">
                    <thead className="text-xs text-gray-500 uppercase bg-gray-50 rounded-t-lg">
                      <tr>
                        <th className="px-4 py-4 w-10"></th>
                        <th className="px-4 py-4">Order ID</th>
                        <th className="px-4 py-4">Customer</th>
                        <th className="px-4 py-4">Date</th>
                        <th className="px-4 py-4">Total</th>
                        <th className="px-4 py-4">Status</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {orders.map(order => (
                        <React.Fragment key={order.id}>
                          <tr className="hover:bg-gray-50/50 transition-colors">
                            <td className="px-4 py-4">
                              <Button variant="ghost" size="icon" onClick={() => toggleOrderDetails(order.id)} className="h-8 w-8 rounded-full">
                                {expandedOrderId === order.id ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
                              </Button>
                            </td>
                            <td className="px-4 py-4 font-mono text-xs text-gray-600">{order.id.slice(0, 8)}</td>
                            <td className="px-4 py-4 font-medium text-gray-900">{order.profiles?.name || 'Unknown'}</td>
                            <td className="px-4 py-4 text-gray-600">{new Date(order.created_at).toLocaleDateString()}</td>
                            <td className="px-4 py-4 font-bold text-primary">₹{order.total_amount.toFixed(2)}</td>
                            <td className="px-4 py-4">
                              <select 
                                className="text-sm border border-gray-200 rounded-md px-2 py-1.5 bg-white focus:ring-2 focus:ring-primary/20 outline-none"
                                value={order.status}
                                onChange={(e) => handleUpdateOrderStatus(order.id, e.target.value)}
                              >
                                <option value="pending">Pending</option>
                                <option value="processing">Processing</option>
                                <option value="shipped">Shipped</option>
                                <option value="delivered">Delivered</option>
                                <option value="cancelled">Cancelled</option>
                              </select>
                            </td>
                          </tr>
                          {expandedOrderId === order.id && (
                            <tr className="bg-gray-50/80 border-b border-gray-100">
                              <td colSpan={6} className="px-8 py-6">
                                <h4 className="font-semibold text-gray-900 mb-4">Order Items</h4>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                  {order.order_items?.map((item: any) => {
                                    const img = (item.products?.images && item.products.images.length > 0) ? item.products.images[0] : (item.products?.image_url || 'https://via.placeholder.com/100');
                                    return (
                                      <div key={item.id} className="flex items-center space-x-4 bg-white p-3 rounded-lg border border-gray-100 shadow-sm">
                                        <img src={img} alt={item.products?.name} className="w-16 h-16 rounded-md object-cover border border-gray-100" />
                                        <div className="flex-1">
                                          <p className="font-medium text-gray-900 line-clamp-1">{item.products?.name || 'Unknown Product'}</p>
                                          <div className="flex justify-between mt-1 text-sm text-gray-500">
                                            <span>Qty: {item.quantity}</span>
                                            <span className="font-medium text-gray-900">₹{item.price * item.quantity}</span>
                                          </div>
                                        </div>
                                      </div>
                                    );
                                  })}
                                </div>
                              </td>
                            </tr>
                          )}
                        </React.Fragment>
                      ))}
                    </tbody>
                  </table>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* PRODUCTS TAB */}
          <TabsContent value="products">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              <div className="lg:col-span-1 space-y-6">
                {/* Single Product Form */}
                <Card className="border-0 shadow-sm">
                  <CardHeader className="flex flex-row items-center justify-between">
                    <CardTitle>{editingProductId ? 'Edit Product' : 'Add Product'}</CardTitle>
                    {editingProductId && (
                      <Button variant="ghost" size="icon" onClick={resetProductForm} className="h-8 w-8 rounded-full"><X className="h-4 w-4" /></Button>
                    )}
                  </CardHeader>
                  <CardContent>
                    <form onSubmit={handleSaveProduct} className="space-y-4">
                      <Input placeholder="Product Name" value={prodName} onChange={(e) => setProdName(e.target.value)} required />
                      <div className="grid grid-cols-2 gap-4">
                        <Input type="number" placeholder="Price (₹)" value={prodPrice} onChange={(e) => setProdPrice(e.target.value)} required />
                        <Input type="number" placeholder="Stock" value={prodStock} onChange={(e) => setProdStock(e.target.value)} required />
                      </div>
                      <select 
                        className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                        value={prodCat} onChange={(e) => setProdCat(e.target.value)} required
                      >
                        <option value="">Select Category</option>
                        {categories.map(c => (
                          <option key={c.id} value={c.id}>
                            {c.parent ? `${c.parent.name} > ${c.name}` : c.name}
                          </option>
                        ))}
                      </select>
                      <Textarea placeholder="Description" value={prodDesc} onChange={(e) => setProdDesc(e.target.value)} rows={3} />
                      
                      {/* Image Upload Section */}
                      <div className="space-y-3 border border-gray-200 rounded-xl p-4 bg-gray-50/50">
                        <div className="flex items-center justify-between">
                          <label className="text-sm font-medium text-gray-700 flex items-center">
                            <ImageIcon className="w-4 h-4 mr-2" /> Product Images ({prodImages.length}/50)
                          </label>
                          <label className="cursor-pointer bg-white border border-gray-200 hover:bg-gray-50 text-gray-700 px-3 py-1.5 rounded-md text-xs font-medium transition-colors flex items-center">
                            {isUploadingImages ? <Loader2 className="w-3 h-3 mr-1 animate-spin" /> : <Upload className="w-3 h-3 mr-1" />}
                            Upload
                            <input type="file" multiple accept="image/*" className="hidden" onChange={handleImageUpload} disabled={isUploadingImages} />
                          </label>
                        </div>
                        
                        {/* Image Preview Grid */}
                        {prodImages.length > 0 && (
                          <div className="grid grid-cols-4 gap-2 mt-2">
                            {prodImages.map((img, idx) => (
                              <div key={idx} className="relative group aspect-square rounded-md overflow-hidden border border-gray-200">
                                <img src={img} alt={`Preview ${idx}`} className="w-full h-full object-cover" />
                                <button 
                                  type="button"
                                  onClick={() => removeImage(idx)}
                                  className="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
                                >
                                  <X className="w-3 h-3" />
                                </button>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>

                      <Button type="submit" className="w-full rounded-full" disabled={isUploadingImages}>
                        {editingProductId ? 'Update Product' : 'Add Product'}
                      </Button>
                    </form>
                  </CardContent>
                </Card>

                {/* Bulk Upload Card */}
                <Card className="border-0 shadow-sm">
                  <CardHeader><CardTitle className="flex items-center"><FileSpreadsheet className="w-5 h-5 mr-2" /> Bulk Upload (CSV)</CardTitle></CardHeader>
                  <CardContent>
                    <p className="text-xs text-gray-500 mb-4">
                      Format: <code className="bg-gray-100 px-1 rounded">name, price, description, category_id, stock, images</code><br/>
                      (Separate multiple image URLs with a semicolon <code className="bg-gray-100 px-1 rounded">;</code>)
                    </p>
                    <label className="flex items-center justify-center w-full h-24 border-2 border-dashed border-gray-300 rounded-xl hover:bg-gray-50 cursor-pointer transition-colors">
                      <div className="flex flex-col items-center">
                        {isUploadingBulk ? <Loader2 className="w-6 h-6 text-primary animate-spin mb-2" /> : <Upload className="w-6 h-6 text-gray-400 mb-2" />}
                        <span className="text-sm font-medium text-gray-600">{isUploadingBulk ? 'Processing...' : 'Select CSV File'}</span>
                      </div>
                      <input type="file" accept=".csv" className="hidden" onChange={handleBulkUpload} disabled={isUploadingBulk} />
                    </label>
                  </CardContent>
                </Card>

                {/* Quick Fixes Card */}
                <Card className="border-0 shadow-sm">
                  <CardHeader><CardTitle className="flex items-center"><Wrench className="w-5 h-5 mr-2" /> Quick Fixes</CardTitle></CardHeader>
                  <CardContent>
                    <Button 
                      variant="outline" 
                      onClick={handleFixDescriptions} 
                      disabled={isFixingDescriptions}
                      className="w-full text-sm"
                    >
                      {isFixingDescriptions ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : null}
                      Remove "Premium" text from Acrylics
                    </Button>
                    <p className="text-xs text-gray-500 mt-3 text-center">
                      This will scan all products and remove the "Acrylic sheets are positioned as more premium..." line from their descriptions.
                    </p>
                  </CardContent>
                </Card>
              </div>

              <Card className="lg:col-span-2 border-0 shadow-sm">
                <CardHeader><CardTitle>Product List ({products.length})</CardTitle></CardHeader>
                <CardContent>
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm text-left">
                      <thead className="text-xs text-gray-500 uppercase bg-gray-50">
                        <tr>
                          <th className="px-4 py-3">Product</th>
                          <th className="px-4 py-3">Category</th>
                          <th className="px-4 py-3">Price</th>
                          <th className="px-4 py-3">Stock</th>
                          <th className="px-4 py-3 text-right">Actions</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-100">
                        {products.map(product => {
                          const img = (product.images && product.images.length > 0) ? product.images[0] : (product.image_url || 'https://via.placeholder.com/40');
                          return (
                            <tr key={product.id} className="hover:bg-gray-50/50 transition-colors">
                              <td className="px-4 py-3 font-medium text-gray-900">
                                <div className="flex items-center space-x-3">
                                  <img src={img} alt="" className="w-8 h-8 rounded object-cover" />
                                  <span className="line-clamp-1">{product.name}</span>
                                </div>
                              </td>
                              <td className="px-4 py-3 text-gray-600">{product.categories?.name || 'N/A'}</td>
                              <td className="px-4 py-3 font-medium">₹{product.price}</td>
                              <td className="px-4 py-3">{product.stock}</td>
                              <td className="px-4 py-3 text-right space-x-2">
                                <Button variant="outline" size="icon" onClick={() => handleEditClick(product)} className="h-8 w-8 rounded-full">
                                  <Edit2 className="h-4 w-4 text-blue-600" />
                                </Button>
                                <Button variant="outline" size="icon" onClick={() => handleDeleteProduct(product.id)} className="h-8 w-8 rounded-full hover:bg-red-50 hover:text-red-600 border-red-100">
                                  <X className="h-4 w-4 text-red-500" />
                                </Button>
                              </td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          {/* CATEGORIES TAB */}
          <TabsContent value="categories">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              <Card className="lg:col-span-1 border-0 shadow-sm h-fit">
                <CardHeader><CardTitle>Add Category</CardTitle></CardHeader>
                <CardContent>
                  <form onSubmit={handleAddCategory} className="space-y-4">
                    <Input placeholder="Name (e.g. Sunmica)" value={catName} onChange={(e) => setCatName(e.target.value)} required />
                    <Input placeholder="Slug (e.g. sunmica)" value={catSlug} onChange={(e) => setCatSlug(e.target.value)} required />
                    <select 
                      className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                      value={catParentId} onChange={(e) => setCatParentId(e.target.value)}
                    >
                      <option value="">No Parent (Top Level)</option>
                      {categories.filter(c => !c.parent_id).map(c => (
                        <option key={c.id} value={c.id}>{c.name}</option>
                      ))}
                    </select>
                    <Button type="submit" className="w-full rounded-full">Add Category</Button>
                  </form>
                </CardContent>
              </Card>

              <Card className="lg:col-span-2 border-0 shadow-sm">
                <CardHeader><CardTitle>Category List ({categories.length})</CardTitle></CardHeader>
                <CardContent>
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm text-left">
                      <thead className="text-xs text-gray-500 uppercase bg-gray-50">
                        <tr>
                          <th className="px-4 py-3">Name</th>
                          <th className="px-4 py-3">Parent</th>
                          <th className="px-4 py-3">Slug</th>
                          <th className="px-4 py-3 text-right">Action</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-100">
                        {categories.map(cat => (
                          <tr key={cat.id}>
                            <td className="px-4 py-3 font-medium text-gray-900">{cat.name}</td>
                            <td className="px-4 py-3 text-gray-500">{cat.parent?.name || '-'}</td>
                            <td className="px-4 py-3 text-gray-500">{cat.slug}</td>
                            <td className="px-4 py-3 text-right">
                              <Button variant="outline" size="sm" onClick={() => handleDeleteCategory(cat.id)} className="rounded-full text-xs h-8 text-red-600 hover:bg-red-50 border-red-100">Delete</Button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        </Tabs>
      </div>
      <Footer />
    </div>
  );
};

export default Admin;