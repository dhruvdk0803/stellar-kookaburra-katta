import React, { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Switch } from '@/components/ui/switch';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import { toast } from 'sonner';
import { Auth } from '@supabase/auth-ui-react';
import { ThemeSupa } from '@supabase/auth-ui-shared';
import { Loader2, LogOut, Package, Tags, ShoppingBag, Edit2, Trash2, X, DollarSign, Activity, LayoutDashboard, ChevronDown, ChevronUp, Upload, Image as ImageIcon, FileSpreadsheet, Wrench } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';
import { ensureBrandPrefix, stripKnownBrandPrefix } from '@/lib/catalog';
import { getSavedVariantImage } from '@/lib/productImages';

type ProductVariant = {
  _editorKey?: string;
  label?: string;
  price?: number | string;
  image?: string;
  is_default?: boolean;
  type?: string;
  [key: string]: unknown;
};

const parsePrice = (value: unknown) => {
  if (typeof value === 'string' && value.trim() === '') return Number.NaN;
  return Number(value);
};

const createVariantEditorKey = () => globalThis.crypto?.randomUUID?.() || `${Date.now()}-${Math.random()}`;

const getErrorMessage = (error: unknown) => {
  if (error instanceof Error) return error.message;
  if (error && typeof error === 'object' && 'message' in error) return String(error.message);
  return String(error);
};

interface ProductCategoryOption {
  id: string;
  name: string;
  parent_id?: string | null;
  parent?: { name: string } | null;
}

interface ProductCategoryAssignment {
  brand_id?: string | null;
  category_id?: string | null;
}

const uploadCatalogImage = async (file: File, folder: 'products' | 'categories' | 'brands') => {
  const extensions: Record<string, string> = {
    'image/jpeg': 'jpg', 'image/png': 'png', 'image/webp': 'webp',
    'image/avif': 'avif', 'image/gif': 'gif',
  };
  const extension = extensions[file.type];
  if (!extension) throw new Error('Choose a JPG, PNG, WebP, AVIF, or GIF image.');
  if (file.size === 0 || file.size > 10 * 1024 * 1024) throw new Error('Image must be between 1 byte and 10 MB.');
  const uniqueId = globalThis.crypto?.randomUUID?.() || `${Date.now()}-${Math.random().toString(36).slice(2)}`;
  const filePath = `${folder}/${uniqueId}.${extension}`;
  const { error } = await supabase.storage.from('product-images').upload(filePath, file, { cacheControl: '3600', upsert: false });
  if (error) throw error;
  return supabase.storage.from('product-images').getPublicUrl(filePath).data.publicUrl;
};

const getCategoriesForBrand = (categories: ProductCategoryOption[], products: ProductCategoryAssignment[], brandId: string) => {
  const usedIds = new Set<string>(
    products.filter((product) => product.brand_id === brandId && product.category_id).map((product) => product.category_id as string),
  );
  if (!usedIds.size) return categories;

  const byId = new Map(categories.map((category) => [category.id, category]));
  for (const id of [...usedIds]) {
    let current = byId.get(id);
    let guard = 0;
    while (current?.parent_id && guard++ < 20) {
      usedIds.add(current.parent_id);
      current = byId.get(current.parent_id);
    }
  }
  return categories.filter((category) => usedIds.has(category.id));
};

// Supabase limits one response to 1,000 rows. Admin must page through the
// whole catalog, otherwise its product list and dashboard counts diverge from
// the public Shop page once the catalog grows beyond that limit.
async function fetchAllAdminProducts(): Promise<any[]> {
  const PAGE_SIZE = 1000;
  const allProducts: any[] = [];

  for (let from = 0; ; from += PAGE_SIZE) {
    const { data, error } = await supabase
      .from('products')
      .select('*, categories(name), brands(name, slug)')
      .order('created_at', { ascending: false })
      .order('id', { ascending: false })
      .range(from, from + PAGE_SIZE - 1);

    if (error) throw error;
    if (!data || data.length === 0) break;
    allProducts.push(...data);
    if (data.length < PAGE_SIZE) break;
  }

  return allProducts;
}

async function fetchAllAdminOrders() {
  const PAGE_SIZE = 250;
  const allOrders = [];
  for (let from = 0; ; from += PAGE_SIZE) {
    const { data, error } = await supabase.from('orders')
      .select('*, profiles(name), order_items(*, products(name, image_url, images))')
      .order('created_at', { ascending: false })
      .order('id', { ascending: false })
      .range(from, from + PAGE_SIZE - 1);
    if (error) throw error;
    if (!data?.length) break;
    allOrders.push(...data);
    if (data.length < PAGE_SIZE) break;
  }
  return allOrders;
}

const countsAsRevenue = (order: { status: string; payment_provider?: string | null; payment_status?: string | null }) =>
  ['confirmed', 'processing', 'shipped', 'delivered'].includes(order.status) &&
  (order.payment_provider !== 'razorpay' || order.payment_status === 'captured');

const Admin = () => {
  const { user, profile, isLoading, signOut } = useAuth();
  const navigate = useNavigate();
  
  const [categories, setCategories] = useState<any[]>([]);
  const [brands, setBrands] = useState<any[]>([]);
  const [products, setProducts] = useState<any[]>([]);
  const [orders, setOrders] = useState<any[]>([]);
  const [expandedOrderId, setExpandedOrderId] = useState<string | null>(null);

  // Category Form States
  const [editingCategoryId, setEditingCategoryId] = useState<string | null>(null);
  const [catName, setCatName] = useState('');
  const [catSlug, setCatSlug] = useState('');
  const [catParentId, setCatParentId] = useState('');
  const [catImage, setCatImage] = useState('');
  const [catOrder, setCatOrder] = useState('0');
  const [isUploadingCatImage, setIsUploadingCatImage] = useState(false);

  // Brand Form States
  const [editingBrandId, setEditingBrandId] = useState<string | null>(null);
  const [brandName, setBrandName] = useState('');
  const [brandSlug, setBrandSlug] = useState('');
  const [brandLogo, setBrandLogo] = useState('');
  const [brandOrder, setBrandOrder] = useState('0');
  const [isUploadingBrandLogo, setIsUploadingBrandLogo] = useState(false);
  const [deletingBrandId, setDeletingBrandId] = useState<string | null>(null);
  
  // Product Form States
  const [editingProductId, setEditingProductId] = useState<string | null>(null);
  const [prodName, setProdName] = useState('');
  const [prodPrice, setProdPrice] = useState('');
  const [prodDesc, setProdDesc] = useState('');
  const [prodCat, setProdCat] = useState('');
  const [prodBrand, setProdBrand] = useState('');
  const [showAllProductCategories, setShowAllProductCategories] = useState(false);
  const [prodStock, setProdStock] = useState('100');
  const [prodIsActive, setProdIsActive] = useState(true);
  const [prodImages, setProdImages] = useState<string[]>([]);
  const [prodVariants, setProdVariants] = useState<ProductVariant[]>([]);
  const [prodVariantType, setProdVariantType] = useState('size');
  const [isUploadingImages, setIsUploadingImages] = useState(false);
  const [isSavingProduct, setIsSavingProduct] = useState(false);
  const [isUploadingBulk, setIsUploadingBulk] = useState(false);
  const [isFixingDescriptions, setIsFixingDescriptions] = useState(false);
  const [listBrand, setListBrand] = useState('');
  const [listCategory, setListCategory] = useState('');
  const [listStatus, setListStatus] = useState('all');
  const [listSearch, setListSearch] = useState('');

  useEffect(() => {
    if (profile?.role === 'admin') {
      fetchData();
    }
  }, [profile]);

  const fetchData = async () => {
    try {
      const [catRes, brandRes, prodRes, ordRes] = await Promise.all([
      supabase.from('categories').select('*, parent:parent_id(name)').order('created_at', { ascending: false }),
      supabase.from('brands').select('*').order('display_order').order('name'),
      fetchAllAdminProducts(),
      fetchAllAdminOrders()
    ]);
      if (catRes.error) throw catRes.error;
      if (brandRes.error) throw brandRes.error;
      setCategories(catRes.data || []);
      setBrands(brandRes.data || []);
      setProducts(prodRes);
      setOrders(ordRes);
    } catch (error) {
      toast.error(`Could not load admin data: ${getErrorMessage(error)}`);
    }
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
      const dayOrders = orders.filter(o => o.created_at.startsWith(date) && countsAsRevenue(o));
      return {
        date: new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
        revenue: dayOrders.reduce((sum, o) => sum + Number(o.total_amount), 0),
        orders: dayOrders.length
      };
    });
  }, [orders]);

  // --- Category Actions ---
  const handleAddCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    const newCat: any = { name: catName, slug: catSlug, image_url: catImage || null, display_order: parseInt(catOrder) || 0 };
    newCat.parent_id = catParentId || null;

    const query = editingCategoryId
      ? supabase.from('categories').update(newCat).eq('id', editingCategoryId)
      : supabase.from('categories').insert([newCat]);
    const { error } = await query;
    if (error) toast.error(error.message);
    else { toast.success(editingCategoryId ? 'Category updated!' : 'Category added!'); setEditingCategoryId(null); setCatName(''); setCatSlug(''); setCatParentId(''); setCatImage(''); setCatOrder('0'); fetchData(); }
  };

  const handleEditCategory = (category: any) => {
    setEditingCategoryId(category.id); setCatName(category.name); setCatSlug(category.slug); setCatParentId(category.parent_id || ''); setCatImage(category.image_url || ''); setCatOrder(String(category.display_order || 0));
  };

  const handleCategoryImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsUploadingCatImage(true);
    try {
      setCatImage(await uploadCatalogImage(file, 'categories'));
      toast.success('Category image uploaded. Save the category to keep it.');
    } catch (error: unknown) {
      toast.error(`Image upload failed: ${getErrorMessage(error)}`);
    } finally {
      setIsUploadingCatImage(false);
      e.target.value = '';
    }
  };

  const handleDeleteCategory = async (id: string) => {
    if (!confirm('Delete this category? Products linked to it might be affected.')) return;
    const { error } = await supabase.from('categories').delete().eq('id', id);
    if (error) toast.error(error.message);
    else { toast.success('Category deleted'); fetchData(); }
  };

  const resetBrandForm = () => {
    setEditingBrandId(null); setBrandName(''); setBrandSlug(''); setBrandLogo(''); setBrandOrder('0');
  };

  const handleSaveBrand = async (e: React.FormEvent) => {
    e.preventDefault();
    const values = { name: brandName.trim(), slug: brandSlug.trim().toLowerCase(), logo_url: brandLogo.trim() || null, display_order: parseInt(brandOrder) || 0, is_active: true };
    const query = editingBrandId
      ? supabase.from('brands').update(values).eq('id', editingBrandId)
      : supabase.from('brands').insert([values]);
    const { error } = await query;
    if (error) toast.error(error.message);
    else { toast.success(editingBrandId ? 'Brand updated!' : 'Brand added!'); resetBrandForm(); fetchData(); }
  };

  const handleEditBrand = (brand: any) => {
    setEditingBrandId(brand.id); setBrandName(brand.name); setBrandSlug(brand.slug); setBrandLogo(brand.logo_url || ''); setBrandOrder(String(brand.display_order || 0));
  };

  const handleBrandLogoUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsUploadingBrandLogo(true);
    try {
      setBrandLogo(await uploadCatalogImage(file, 'brands'));
      toast.success('Brand logo uploaded. Save the brand to keep it.');
    } catch (error: unknown) {
      toast.error(`Logo upload failed: ${getErrorMessage(error)}`);
    } finally {
      setIsUploadingBrandLogo(false);
      e.target.value = '';
    }
  };

  const handleDeleteBrand = async (brand: { id: string; name: string }) => {
    const brandProducts = products.filter((product) => product.brand_id === brand.id);
    const productCount = brandProducts.length;
    const categoryCount = new Set(brandProducts.map((product) => product.category_id).filter(Boolean)).size;
    const confirmed = window.confirm(
      `Are you sure you want to delete ${brand.name}? This will permanently delete the brand and its ${productCount} product(s). Category records used only by this brand will be removed where safe (up to ${categoryCount} directly used categories); categories shared with other brands and past orders will be preserved. Continue?`,
    );
    if (!confirmed) return;

    setDeletingBrandId(brand.id);
    try {
      const { data, error } = await supabase.rpc('delete_brand_catalog', { target_brand_id: brand.id });
      if (error) throw error;
      const result = data as { deleted_products?: number; deleted_categories?: number } | null;
      toast.success(`Brand deleted: ${result?.deleted_products ?? productCount} product(s) and ${result?.deleted_categories ?? 0} exclusive category(ies) removed.`);
      if (editingBrandId === brand.id) resetBrandForm();
      await fetchData();
    } catch (error: unknown) {
      toast.error(`Brand could not be deleted: ${getErrorMessage(error)}`);
    } finally {
      setDeletingBrandId(null);
    }
  };

  // --- Product Actions ---
  const resetProductForm = () => {
    setProdName(''); setProdPrice(''); setProdDesc(''); setProdCat(''); setProdBrand(''); setShowAllProductCategories(false); setProdStock('100'); setProdIsActive(true); setProdImages([]); setProdVariants([]); setProdVariantType('size');
    setEditingProductId(null);
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    if (!files.length) return;
    
    if (prodImages.length + files.length > 50) {
      toast.error("You can only upload up to 50 images per product.");
      e.target.value = '';
      return;
    }

    setIsUploadingImages(true);
    const newImageUrls: string[] = [];
    try {
      for (const file of files) {
        try {
          newImageUrls.push(await uploadCatalogImage(file, 'products'));
        } catch (error: unknown) {
          toast.error(`Failed to upload ${file.name}: ${getErrorMessage(error)}`);
        }
      }
      setProdImages((previous) => [...previous, ...newImageUrls]);
    } finally {
      setIsUploadingImages(false);
      e.target.value = '';
    }
  };

  const removeImage = (indexToRemove: number) => {
    const removed = prodImages[indexToRemove];
    setProdImages(prev => prev.filter((_, index) => index !== indexToRemove));
    setProdVariants(prev => prev.map(variant => variant.image === removed ? { ...variant, image: undefined } : variant));
  };

  const setPrimaryImage = (indexToMove: number) => {
    setProdImages(prev => [prev[indexToMove], ...prev.filter((_, index) => index !== indexToMove)]);
  };

  const handleSaveProduct = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSavingProduct || isUploadingImages) return;
    const selectedBrand = brands.find((brand) => brand.id === prodBrand);
    if (!selectedBrand) { toast.error('Select a valid brand.'); return; }
    if (!(showAllProductCategories ? categories : getCategoriesForBrand(categories, products, selectedBrand.id)).some((category) => category.id === prodCat)) {
      toast.error('Choose a category currently associated with this brand.');
      return;
    }

    const hasVariants = prodVariants.length > 0;
    const variantPrices = prodVariants.map((variant) => parsePrice(variant.price));
    if (hasVariants && prodVariants.length < 2) {
      toast.error('Add at least two options, or remove variant mode to save a single product.');
      return;
    }
    const variantLabels = prodVariants.map((variant) => variant.label?.trim() || '');
    if (hasVariants && variantLabels.some((label) => !label)) {
      toast.error('Every option needs a label, such as 1/2 inch or Black.');
      return;
    }
    if (hasVariants && new Set(variantLabels.map((label) => label.toLocaleLowerCase())).size !== variantLabels.length) {
      toast.error('Variant labels must be unique.');
      return;
    }
    if (hasVariants && variantPrices.some((price) => !Number.isFinite(price) || price <= 0)) {
      toast.error('Every option needs a price greater than zero.');
      return;
    }
    const stock = parsePrice(prodStock);
    if (!Number.isInteger(stock) || stock < 0) {
      toast.error('Stock must be a whole number equal to or greater than zero.');
      return;
    }
    const defaultIndex = prodVariants.findIndex((variant) => variant.is_default);
    const variants = prodVariants.map((variant, index) => {
      const savedVariant = { ...variant };
      delete savedVariant._editorKey;
      return {
        ...savedVariant,
        label: variantLabels[index],
        price: variantPrices[index],
        type: prodVariantType,
        image: getSavedVariantImage(variant.image, prodImages),
        is_default: index === (defaultIndex >= 0 ? defaultIndex : 0),
      };
    });
    const enteredPrice = parsePrice(prodPrice);

    if (!hasVariants && (!Number.isFinite(enteredPrice) || enteredPrice <= 0)) {
      toast.error('Enter a product price greater than zero.');
      return;
    }

    const productPrice = hasVariants
      ? Math.min(...variants.map((variant) => Number(variant.price)))
      : enteredPrice;
    const productData = {
      name: ensureBrandPrefix(stripKnownBrandPrefix(prodName, brands), selectedBrand.name),
      brand_id: selectedBrand.id,
      price: productPrice,
      description: prodDesc,
      category_id: prodCat, 
      stock,
      is_active: prodIsActive,
      images: prodImages,
      image_url: prodImages.length > 0 ? prodImages[0] : null,
      variants
    };

    setIsSavingProduct(true);
    try {
      const { error } = editingProductId
        ? await supabase.from('products').update(productData).eq('id', editingProductId)
        : await supabase.from('products').insert([productData]);
      if (error) throw error;
      toast.success(editingProductId ? 'Product updated!' : 'Product added!');
      resetProductForm();
      await fetchData();
    } catch (error) {
      toast.error(`Could not save product: ${getErrorMessage(error)}`);
    } finally {
      setIsSavingProduct(false);
    }
  };

  const handleEditClick = (product: any) => {
    setEditingProductId(product.id);
    setProdName(stripKnownBrandPrefix(product.name, brands));
    setProdPrice(product.price.toString());
    setProdDesc(product.description || '');
    setProdCat(product.category_id || '');
    setProdBrand(product.brand_id || '');
    setShowAllProductCategories(false);
    setProdStock(product.stock?.toString() || '0');
    setProdIsActive(product.is_active !== false);
    
    let imgs = Array.isArray(product.images) ? product.images : [];
    if (imgs.length === 0 && product.image_url) imgs = [product.image_url];
    // Older catalog rows may keep option photos outside the gallery. Surface
    // them here so an admin can keep or remove them deliberately.
    const variantImages = Array.isArray(product.variants)
      ? product.variants.map((variant: ProductVariant) => variant?.image).filter((image: unknown): image is string => typeof image === 'string' && Boolean(image))
      : [];
    setProdImages([...new Set([...imgs, ...variantImages])]);
    setProdVariants(
      Array.isArray(product.variants)
        ? product.variants
          .filter((variant: unknown) => variant && typeof variant === 'object' && !Array.isArray(variant))
          .map((variant: ProductVariant) => ({ ...variant, _editorKey: createVariantEditorKey(), price: variant.price ?? '' }))
        : []
    );
    const savedVariantType = Array.isArray(product.variants)
      ? product.variants.find((variant: ProductVariant) => variant && typeof variant.type === 'string')?.type
      : undefined;
    const normalizedVariantType = typeof savedVariantType === 'string' ? savedVariantType.toLowerCase() : '';
    setProdVariantType(normalizedVariantType === 'colour' ? 'color' : ['size', 'color', 'finish', 'option'].includes(normalizedVariantType) ? normalizedVariantType : 'option');
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleVariantChange = (index: number, field: 'label' | 'price' | 'image', value: string) => {
    setProdVariants((variants) => variants.map((variant, variantIndex) => (
      variantIndex === index ? { ...variant, [field]: value || undefined } : variant
    )));
  };

  const addProductVariant = () => {
    const editorKey = createVariantEditorKey();
    setProdVariants((variants) => [...variants, {
      _editorKey: editorKey,
      label: '',
      price: '',
      type: prodVariantType,
      is_default: variants.length === 0,
      image: undefined,
    }]);
  };

  const removeProductVariant = (index: number) => {
    setProdVariants((variants) => {
      const next = variants.filter((_, variantIndex) => variantIndex !== index);
      if (variants[index]?.is_default && next.length > 0) {
        next[0] = { ...next[0], is_default: true };
      }
      return next;
    });
  };

  const setDefaultProductVariant = (index: number) => {
    setProdVariants((variants) => variants.map((variant, variantIndex) => ({
      ...variant,
      is_default: variantIndex === index,
    })));
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
      if (!headers.includes('brand') && !headers.includes('brand_slug')) throw new Error('CSV must include a brand or brand_slug column.');
      
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
        
        const requestedBrand = (product.brand_slug || product.brand || '').toLowerCase();
        const matchedBrand = brands.find((brand) => brand.slug.toLowerCase() === requestedBrand || brand.name.toLowerCase() === requestedBrand);
        if (!matchedBrand) throw new Error(`Row ${i + 1}: unknown brand "${product.brand_slug || product.brand || ''}".`);
        if (!product.name || !product.category_id) throw new Error(`Row ${i + 1}: name and category_id are required.`);
        if (!categories.some((category) => category.id === product.category_id)) throw new Error(`Row ${i + 1}: category_id "${product.category_id}" does not exist in Admin.`);
        product.brand_id = matchedBrand.id;
        product.name = ensureBrandPrefix(stripKnownBrandPrefix(product.name, brands), matchedBrand.name);
        delete product.brand;
        delete product.brand_slug;
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

  const totalRevenue = orders.filter(countsAsRevenue).reduce((sum, o) => sum + Number(o.total_amount), 0);
  const activeProductCount = products.filter((product) => product.is_active !== false).length;
  const productCategoryOptions = prodBrand && !showAllProductCategories ? getCategoriesForBrand(categories, products, prodBrand) : categories;
  const listCategoryOptions = useMemo(() => {
    if (!listBrand) return categories;
    if (!products.some((product) => product.brand_id === listBrand)) return [];
    return getCategoriesForBrand(categories, products, listBrand);
  }, [categories, products, listBrand]);
  const matchingProducts = useMemo(() => {
    const search = listSearch.trim().toLocaleLowerCase();
    const selectedCategory = categories.find((category) => category.id === listCategory);
    const categoryMatches = (categoryId: string | null) => {
      if (!selectedCategory) return !listCategory;
      let current = categories.find((category) => category.id === categoryId);
      let guard = 0;
      while (current && guard++ < 20) {
        if (current.id === selectedCategory.id) return true;
        current = categories.find((category) => category.id === current.parent_id);
      }
      return false;
    };

    return products.filter((product) =>
      (!listBrand || product.brand_id === listBrand) &&
      (!listCategory || categoryMatches(product.category_id)) &&
      (listStatus === 'all' || (product.is_active !== false) === (listStatus === 'live')) &&
      (!search || String(product.name || '').toLocaleLowerCase().includes(search)),
    );
  }, [products, categories, listBrand, listCategory, listStatus, listSearch]);
  const hasProductVariants = prodVariants.length > 0;
  const validVariantPrices = prodVariants
    .map((variant) => parsePrice(variant.price))
    .filter((price) => Number.isFinite(price) && price >= 0);
  const lowestVariantPrice = validVariantPrices.length > 0 ? Math.min(...validVariantPrices) : null;

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
          <TabsList className="grid w-full grid-cols-5 mb-8 bg-white p-1 rounded-xl shadow-sm border border-gray-100">
            <TabsTrigger value="overview" className="rounded-lg py-3"><LayoutDashboard className="w-4 h-4 mr-2 hidden sm:block" /> Overview</TabsTrigger>
            <TabsTrigger value="orders" className="rounded-lg py-3"><ShoppingBag className="w-4 h-4 mr-2 hidden sm:block" /> Orders</TabsTrigger>
            <TabsTrigger value="products" className="rounded-lg py-3"><Package className="w-4 h-4 mr-2 hidden sm:block" /> Products</TabsTrigger>
            <TabsTrigger value="categories" className="rounded-lg py-3"><Tags className="w-4 h-4 mr-2 hidden sm:block" /> Categories</TabsTrigger>
            <TabsTrigger value="brands" className="rounded-lg py-3"><Tags className="w-4 h-4 mr-2 hidden sm:block" /> Brands</TabsTrigger>
          </TabsList>

          {/* OVERVIEW TAB */}
          <TabsContent value="overview" className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <Card className="border-0 shadow-sm"><CardContent className="p-6 flex items-center space-x-4"><div className="p-4 bg-green-100 rounded-full"><DollarSign className="h-8 w-8 text-green-600" /></div><div><p className="text-sm font-medium text-gray-500">Total Revenue</p><h3 className="text-2xl font-bold text-gray-900">₹{totalRevenue.toLocaleString()}</h3></div></CardContent></Card>
              <Card className="border-0 shadow-sm"><CardContent className="p-6 flex items-center space-x-4"><div className="p-4 bg-blue-100 rounded-full"><ShoppingBag className="h-8 w-8 text-blue-600" /></div><div><p className="text-sm font-medium text-gray-500">Total Orders</p><h3 className="text-2xl font-bold text-gray-900">{orders.length}</h3></div></CardContent></Card>
              <Card className="border-0 shadow-sm"><CardContent className="p-6 flex items-center space-x-4"><div className="p-4 bg-purple-100 rounded-full"><Package className="h-8 w-8 text-purple-600" /></div><div><p className="text-sm font-medium text-gray-500">Live Products</p><h3 className="text-2xl font-bold text-gray-900">{activeProductCount}</h3><p className="text-xs text-gray-500">{products.length} total in Admin</p></div></CardContent></Card>
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
                            <td className="px-4 py-4 font-bold text-primary">₹{Number(order.total_amount).toFixed(2)}</td>
                            <td className="px-4 py-4">
                              <select 
                                className="text-sm border border-gray-200 rounded-md px-2 py-1.5 bg-white focus:ring-2 focus:ring-primary/20 outline-none"
                                value={order.status}
                                onChange={(e) => handleUpdateOrderStatus(order.id, e.target.value)}
                              >
                                {!order.payment_id && <option value="pending">Pending</option>}
                                {(order.payment_provider !== 'razorpay' || order.payment_status === 'captured') && <>
                                  <option value="confirmed">Confirmed</option>
                                  <option value="processing">Processing</option>
                                  <option value="shipped">Shipped</option>
                                  <option value="delivered">Delivered</option>
                                </>}
                                {(order.payment_provider !== 'razorpay' || order.status === 'cancelled') && <option value="cancelled">Cancelled</option>}
                              </select>
                              {order.inventory_issue && <div className="mt-1 text-xs font-semibold text-red-700">Check stock before fulfilment</div>}
                            </td>
                          </tr>
                          {expandedOrderId === order.id && (
                            <tr className="bg-gray-50/80 border-b border-gray-100">
                              <td colSpan={6} className="px-8 py-6">
                                <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
                                  <h4 className="font-semibold text-gray-900">Order Items</h4>
                                  {Number(order.discount_percent) > 0 && (
                                    <span className="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700">
                                      {Number(order.discount_percent)}% discount · saved ₹{Number(order.discount_amount || 0).toFixed(2)}
                                    </span>
                                  )}
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                  {order.order_items?.map((item: any) => {
                                    const img = item.product_image_snapshot || ((item.products?.images && item.products.images.length > 0) ? item.products.images[0] : (item.products?.image_url || '/placeholder.svg'));
                                    const itemName = item.product_name_snapshot || item.products?.name || 'Unknown Product';
                                    return (
                                      <div key={item.id} className="flex items-center space-x-4 bg-white p-3 rounded-lg border border-gray-100 shadow-sm">
                                        <img src={img} alt={itemName} className="w-16 h-16 rounded-md object-cover border border-gray-100" />
                                        <div className="flex-1">
                                          <p className="font-medium text-gray-900 line-clamp-1">
                                            {itemName}
                                            {item.variant_label ? ` (${item.variant_label})` : ''}
                                          </p>
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
                      <Input placeholder="Product name without brand" value={prodName} onChange={(e) => setProdName(e.target.value)} required />
                      <select
                        className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                        value={prodBrand}
                        onChange={(e) => {
                          const nextBrandId = e.target.value;
                          setProdBrand(nextBrandId);
                          setShowAllProductCategories(false);
                          if (prodCat && !getCategoriesForBrand(categories, products, nextBrandId).some((category) => category.id === prodCat)) setProdCat('');
                        }}
                        required
                      >
                        <option value="">Select Brand</option>
                        {brands.map(brand => <option key={brand.id} value={brand.id}>{brand.name}</option>)}
                      </select>
                      {prodBrand && prodName.trim() && (
                        <p className="rounded-lg bg-slate-50 px-3 py-2 text-xs text-gray-600">Customer-facing name: <strong>{ensureBrandPrefix(stripKnownBrandPrefix(prodName, brands), brands.find(brand => brand.id === prodBrand)?.name || '')}</strong></p>
                      )}
                      <div className="space-y-3 rounded-xl border border-primary/20 bg-primary/5 p-4">
                        <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                          <div>
                            <p className="text-sm font-semibold text-gray-800">Product options</p>
                            <p className="text-xs text-gray-600">Enter each size or option with its price in the same card. The storefront will show this exact size–price pair.</p>
                          </div>
                          <Button type="button" variant="outline" onClick={addProductVariant} className="shrink-0 bg-white">Add option</Button>
                        </div>
                        {hasProductVariants ? (
                          <>
                            <div className="grid gap-2 sm:grid-cols-[minmax(0,1fr)_8rem]">
                              <label className="text-xs font-medium text-gray-600">
                                Option type
                                <select
                                  className="mt-1 flex h-10 w-full rounded-md border border-input bg-white px-3 py-2 text-sm text-gray-900"
                                  value={prodVariantType}
                                  onChange={(e) => setProdVariantType(e.target.value)}
                                >
                                  <option value="size">Size</option>
                                  <option value="color">Colour</option>
                                  <option value="finish">Finish</option>
                                  <option value="option">Other option</option>
                                </select>
                              </label>
                              <div className="flex items-end text-xs text-gray-500">{prodVariants.length} option{prodVariants.length === 1 ? '' : 's'}</div>
                            </div>
                            <div className="space-y-2">
                              {prodVariants.map((variant, index) => {
                                const availableImages = prodImages;
                                const optionLabel = String(variant.label ?? '').trim();
                                const optionPrice = parsePrice(variant.price);
                                const priceSummary = Number.isFinite(optionPrice) && optionPrice > 0
                                  ? `₹${optionPrice.toLocaleString('en-IN')}`
                                  : 'Price not set';
                                return (
                                  <div key={variant._editorKey ?? index} className="min-w-0 space-y-3 rounded-lg border border-gray-200 bg-white p-3 sm:p-4">
                                    <div className="flex min-w-0 items-start justify-between gap-3 border-b border-gray-100 pb-3">
                                      <div className="min-w-0">
                                        <p className="text-xs font-semibold uppercase tracking-wide text-gray-500">Option {index + 1}</p>
                                        <p className="mt-1 break-words text-sm font-semibold text-gray-900">
                                          {optionLabel || (prodVariantType === 'size' ? 'Size not entered' : 'Option name not entered')}
                                          <span className="mx-2 text-gray-400">·</span>
                                          <span className={Number.isFinite(optionPrice) && optionPrice > 0 ? 'text-primary' : 'text-amber-700'}>{priceSummary}</span>
                                        </p>
                                      </div>
                                      {variant.is_default && <span className="shrink-0 rounded-full bg-primary/10 px-2.5 py-1 text-xs font-semibold text-primary">Default price</span>}
                                    </div>
                                    <div className="grid min-w-0 gap-3 sm:grid-cols-2">
                                      <label className="min-w-0 text-xs font-semibold text-gray-700">
                                        {prodVariantType === 'size' ? 'Size' : prodVariantType === 'color' ? 'Colour name' : prodVariantType === 'finish' ? 'Finish name' : 'Option name'}
                                        <Input
                                          className="mt-1"
                                          placeholder={prodVariantType === 'size' ? 'e.g. 1/2 inch or 25 mm' : prodVariantType === 'color' ? 'e.g. Matte black' : prodVariantType === 'finish' ? 'e.g. Brushed brass' : 'e.g. Premium'}
                                          aria-label={`Label for option ${index + 1}`}
                                          value={String(variant.label ?? '')}
                                          onChange={(e) => handleVariantChange(index, 'label', e.target.value)}
                                          required
                                        />
                                      </label>
                                      <label className="min-w-0 text-xs font-semibold text-gray-700">
                                        Price for this option (₹)
                                        <Input
                                          className="mt-1"
                                          type="number"
                                          min="0.01"
                                          step="0.01"
                                          placeholder="e.g. 580"
                                          aria-label={`Price for ${variant.label || `option ${index + 1}`}`}
                                          value={String(variant.price ?? '')}
                                          onChange={(e) => handleVariantChange(index, 'price', e.target.value)}
                                          required
                                        />
                                      </label>
                                    </div>
                                    <div className="flex flex-wrap items-center justify-between gap-2 border-t border-gray-100 pt-3">
                                      <Button type="button" variant={variant.is_default ? 'default' : 'outline'} onClick={() => setDefaultProductVariant(index)} className="min-h-10" aria-pressed={Boolean(variant.is_default)}>
                                        {variant.is_default ? 'Default price' : 'Set as default price'}
                                      </Button>
                                      <Button type="button" variant="ghost" onClick={() => removeProductVariant(index)} aria-label={`Remove option ${variant.label || index + 1}`} className="min-h-10 text-red-600 hover:bg-red-50 hover:text-red-700">
                                        <Trash2 className="mr-2 h-4 w-4" /> Remove option
                                      </Button>
                                    </div>
                                    {availableImages.length > 0 && (
                                      <label className="block text-xs font-medium text-gray-600">
                                        Option image
                                        <select
                                          className="mt-1 flex h-10 w-full rounded-md border border-input bg-white px-3 py-2 text-sm text-gray-900"
                                          aria-label={`Image for ${variant.label || `option ${index + 1}`}`}
                                          value={variant.image || ''}
                                          onChange={(e) => handleVariantChange(index, 'image', e.target.value)}
                                        >
                                          <option value="">Use product image</option>
                                          {availableImages.map((image) => <option key={image} value={image}>{image.split('/').pop()}</option>)}
                                        </select>
                                      </label>
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                            <p className="text-xs font-medium text-primary">Starting price: {lowestVariantPrice === null ? 'Enter valid option prices' : `₹${lowestVariantPrice.toLocaleString('en-IN')}`}</p>
                          </>
                        ) : (
                          <Input type="number" min="0.01" step="0.01" placeholder="Price (₹)" value={prodPrice} onChange={(e) => setProdPrice(e.target.value)} required />
                        )}
                      </div>
                      <Input type="number" min="0" placeholder="Stock" value={prodStock} onChange={(e) => setProdStock(e.target.value)} required />
                      <div className="flex items-center justify-between rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5">
                        <div>
                          <p className="text-sm font-medium text-gray-800">Show on website</p>
                          <p className="text-xs text-gray-500">Draft products are visible only in Admin.</p>
                        </div>
                        <Switch checked={prodIsActive} onCheckedChange={setProdIsActive} aria-label="Show product on website" />
                      </div>
                      <select 
                        className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                        value={prodCat} onChange={(e) => setProdCat(e.target.value)} required
                      >
                        <option value="">{prodBrand ? 'Select a category used by this brand' : 'Select Category'}</option>
                        {productCategoryOptions.map(c => (
                          <option key={c.id} value={c.id}>
                            {c.parent ? `${c.parent.name} > ${c.name}` : c.name}
                          </option>
                        ))}
                      </select>
                      {prodBrand && (
                        <div className="-mt-2 flex items-center justify-between gap-3 text-xs text-gray-500">
                          <span>{showAllProductCategories ? 'Showing every category for this product.' : 'Showing categories already used by this brand.'}</span>
                          <button type="button" className="shrink-0 font-medium text-primary underline-offset-2 hover:underline" onClick={() => setShowAllProductCategories((shown) => !shown)}>
                            {showAllProductCategories ? 'Show brand categories' : 'Show all categories'}
                          </button>
                        </div>
                      )}
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
                                {idx === 0 ? (
                                  <span className="absolute bottom-1 left-1 rounded bg-white/90 px-1.5 py-0.5 text-[10px] font-semibold text-gray-800">Primary</span>
                                ) : (
                                  <button type="button" onClick={() => setPrimaryImage(idx)} className="absolute bottom-1 left-1 rounded bg-white/90 px-1.5 py-0.5 text-[10px] font-semibold text-gray-800 hover:bg-white" aria-label={`Make image ${idx + 1} primary`}>
                                    Make primary
                                  </button>
                                )}
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

                      <Button type="submit" className="w-full rounded-full" disabled={isUploadingImages || isSavingProduct}>
                        {isSavingProduct ? 'Saving...' : editingProductId ? 'Update Product' : 'Add Product'}
                      </Button>
                    </form>
                  </CardContent>
                </Card>

                {/* Bulk Upload Card */}
                <Card className="border-0 shadow-sm">
                  <CardHeader><CardTitle className="flex items-center"><FileSpreadsheet className="w-5 h-5 mr-2" /> Bulk Upload (CSV)</CardTitle></CardHeader>
                  <CardContent>
                    <p className="text-xs text-gray-500 mb-4">
                      Format: <code className="bg-gray-100 px-1 rounded">name, brand_slug, price, description, category_id, stock, images</code><br/>
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
                <CardHeader><CardTitle>Product List ({matchingProducts.length} shown · {products.length} total · {activeProductCount} live)</CardTitle></CardHeader>
                <CardContent>
                  <div className="mb-5 grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
                    <div>
                      <label htmlFor="product-list-search" className="mb-1 block text-xs font-medium text-gray-600">Search products</label>
                      <Input id="product-list-search" placeholder="Product name" value={listSearch} onChange={(event) => setListSearch(event.target.value)} />
                    </div>
                    <div>
                      <label htmlFor="product-list-brand" className="mb-1 block text-xs font-medium text-gray-600">Brand</label>
                      <select id="product-list-brand" className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" value={listBrand} onChange={(event) => { setListBrand(event.target.value); setListCategory(''); }}>
                        <option value="">All brands</option>
                        {brands.map((brand) => <option key={brand.id} value={brand.id}>{brand.name}</option>)}
                      </select>
                    </div>
                    <div>
                      <label htmlFor="product-list-category" className="mb-1 block text-xs font-medium text-gray-600">Category</label>
                      <select id="product-list-category" className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" value={listCategory} onChange={(event) => setListCategory(event.target.value)}>
                        <option value="">All categories</option>
                        {listCategoryOptions.map((category) => <option key={category.id} value={category.id}>{category.parent?.name ? `${category.parent.name} / ` : ''}{category.name}</option>)}
                      </select>
                    </div>
                    <div>
                      <label htmlFor="product-list-status" className="mb-1 block text-xs font-medium text-gray-600">Website status</label>
                      <select id="product-list-status" className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" value={listStatus} onChange={(event) => setListStatus(event.target.value)}>
                        <option value="all">All statuses</option>
                        <option value="live">Live</option>
                        <option value="draft">Draft</option>
                      </select>
                    </div>
                  </div>
                  {(listSearch || listBrand || listCategory || listStatus !== 'all') && (
                    <Button type="button" variant="ghost" size="sm" className="mb-3" onClick={() => { setListSearch(''); setListBrand(''); setListCategory(''); setListStatus('all'); }}>Clear filters</Button>
                  )}
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm text-left">
                      <thead className="text-xs text-gray-500 uppercase bg-gray-50">
                        <tr>
                          <th className="px-4 py-3">Product</th>
                          <th className="px-4 py-3">Category</th>
                          <th className="px-4 py-3">Brand</th>
                          <th className="px-4 py-3">Price</th>
                          <th className="px-4 py-3">Stock</th>
                          <th className="px-4 py-3">Website</th>
                          <th className="px-4 py-3 text-right">Actions</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-100">
                        {matchingProducts.map(product => {
                          const img = (product.images && product.images.length > 0) ? product.images[0] : (product.image_url || '/placeholder.svg');
                          return (
                            <tr key={product.id} className="hover:bg-gray-50/50 transition-colors">
                              <td className="px-4 py-3 font-medium text-gray-900">
                                <div className="flex items-center space-x-3">
                                  <img src={img} alt="" className="w-8 h-8 rounded object-cover" />
                                  <span className="line-clamp-1">{product.name}</span>
                                </div>
                              </td>
                              <td className="px-4 py-3 text-gray-600">{product.categories?.name || 'N/A'}</td>
                              <td className="px-4 py-3 text-gray-600">{product.brands?.name || 'N/A'}</td>
                              <td className="px-4 py-3 font-medium">₹{product.price}</td>
                              <td className="px-4 py-3">{product.stock}</td>
                              <td className="px-4 py-3">
                                <span className={product.is_active !== false ? 'inline-flex rounded-full bg-emerald-100 px-2 py-1 text-xs font-medium text-emerald-700' : 'inline-flex rounded-full bg-amber-100 px-2 py-1 text-xs font-medium text-amber-700'}>
                                  {product.is_active !== false ? 'Live' : 'Draft'}
                                </span>
                              </td>
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
                        {matchingProducts.length === 0 && (
                          <tr><td colSpan={7} className="px-4 py-8 text-center text-gray-500">No products match these filters.</td></tr>
                        )}
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
                <CardHeader className="flex flex-row items-center justify-between">
                  <CardTitle>{editingCategoryId ? 'Edit Category' : 'Add Category'}</CardTitle>
                  {editingCategoryId && <Button variant="ghost" size="icon" disabled={isUploadingCatImage} onClick={() => { setEditingCategoryId(null); setCatName(''); setCatSlug(''); setCatParentId(''); setCatImage(''); setCatOrder('0'); }}><X className="h-4 w-4" /></Button>}
                </CardHeader>
                <CardContent>
                  <form onSubmit={handleAddCategory} className="space-y-4">
                    <Input placeholder="Name (e.g. Sunmica)" value={catName} onChange={(e) => setCatName(e.target.value)} required />
                    <Input placeholder="Slug (e.g. sunmica)" value={catSlug} onChange={(e) => setCatSlug(e.target.value)} required />
                    <div className="space-y-2">
                      <Input placeholder="Category image URL (optional)" value={catImage} onChange={(e) => setCatImage(e.target.value)} />
                      <label className="inline-flex cursor-pointer items-center rounded-md border border-gray-200 bg-white px-3 py-2 text-xs font-medium text-gray-700 hover:bg-gray-50">
                        {isUploadingCatImage ? <Loader2 className="mr-2 h-3.5 w-3.5 animate-spin" /> : <Upload className="mr-2 h-3.5 w-3.5" />}
                        {isUploadingCatImage ? 'Uploading…' : 'Choose image from this device'}
                        <input type="file" accept="image/*" className="hidden" onChange={handleCategoryImageUpload} disabled={isUploadingCatImage} />
                      </label>
                      {catImage && <img src={catImage} alt="Category preview" className="h-20 w-28 rounded-md border border-gray-200 bg-white object-contain p-1" />}
                    </div>
                    <Input type="number" placeholder="Display order" value={catOrder} onChange={(e) => setCatOrder(e.target.value)} />
                    <select 
                      className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                      value={catParentId} onChange={(e) => setCatParentId(e.target.value)}
                    >
                      <option value="">No Parent (Top Level)</option>
                      {categories.filter(c => !c.parent_id).map(c => (
                        <option key={c.id} value={c.id}>{c.name}</option>
                      ))}
                    </select>
                    <Button type="submit" className="w-full rounded-full" disabled={isUploadingCatImage}>{editingCategoryId ? 'Update Category' : 'Add Category'}</Button>
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
                          <th className="px-4 py-3">Order</th>
                          <th className="px-4 py-3 text-right">Action</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-100">
                        {categories.map(cat => (
                          <tr key={cat.id}>
                            <td className="px-4 py-3 font-medium text-gray-900">{cat.name}</td>
                            <td className="px-4 py-3 text-gray-500">{cat.parent?.name || '-'}</td>
                            <td className="px-4 py-3 text-gray-500">{cat.slug}</td>
                            <td className="px-4 py-3 text-gray-500">{cat.display_order || 0}</td>
                            <td className="px-4 py-3 text-right space-x-2">
                              <Button variant="outline" size="sm" onClick={() => handleEditCategory(cat)} className="rounded-full text-xs h-8">Edit</Button>
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

          {/* BRANDS TAB */}
          <TabsContent value="brands">
            <div className="grid grid-cols-1 gap-8 lg:grid-cols-3">
              <Card className="h-fit border-0 shadow-sm">
                <CardHeader className="flex flex-row items-center justify-between">
                  <CardTitle>{editingBrandId ? 'Edit Brand' : 'Add Brand'}</CardTitle>
                  {editingBrandId && <Button variant="ghost" size="icon" onClick={resetBrandForm}><X className="h-4 w-4" /></Button>}
                </CardHeader>
                <CardContent>
                  <form onSubmit={handleSaveBrand} className="space-y-4">
                    <Input placeholder="Brand name" value={brandName} onChange={(e) => setBrandName(e.target.value)} required />
                    <Input placeholder="Brand slug" value={brandSlug} onChange={(e) => setBrandSlug(e.target.value)} required />
                    <div className="space-y-2">
                      <Input placeholder="Logo URL (optional)" value={brandLogo} onChange={(e) => setBrandLogo(e.target.value)} />
                      <label className="inline-flex cursor-pointer items-center rounded-md border border-gray-200 bg-white px-3 py-2 text-xs font-medium text-gray-700 hover:bg-gray-50">
                        {isUploadingBrandLogo ? <Loader2 className="mr-2 h-3.5 w-3.5 animate-spin" /> : <Upload className="mr-2 h-3.5 w-3.5" />}
                        {isUploadingBrandLogo ? 'Uploading…' : 'Choose logo from this device'}
                        <input type="file" accept="image/*" className="hidden" onChange={handleBrandLogoUpload} disabled={isUploadingBrandLogo} />
                      </label>
                      {brandLogo && <img src={brandLogo} alt="Brand logo preview" className="h-20 w-28 rounded-md border border-gray-200 bg-white object-contain p-1" />}
                    </div>
                    <Input type="number" placeholder="Display order" value={brandOrder} onChange={(e) => setBrandOrder(e.target.value)} />
                    <Button type="submit" className="w-full rounded-full" disabled={isUploadingBrandLogo}>{editingBrandId ? 'Update Brand' : 'Add Brand'}</Button>
                  </form>
                </CardContent>
              </Card>
              <Card className="border-0 shadow-sm lg:col-span-2">
                <CardHeader><CardTitle>Brand List ({brands.length})</CardTitle></CardHeader>
                <CardContent className="grid grid-cols-1 gap-3 sm:grid-cols-2">
                  {brands.map(brand => (
                    <div key={brand.id} className="flex items-center gap-4 rounded-xl border border-gray-100 p-3">
                      <div className="flex h-14 w-24 items-center justify-center rounded-lg bg-gray-50 p-2">
                        {brand.logo_url ? <img src={brand.logo_url} alt="" className="h-full w-full object-contain" /> : <span className="font-bold">{brand.name}</span>}
                      </div>
                      <div className="min-w-0 flex-1"><p className="font-semibold">{brand.name}</p><p className="text-xs text-gray-500">/{brand.slug} · order {brand.display_order || 0}</p></div>
                      <Button variant="outline" size="icon" aria-label={`Edit ${brand.name}`} onClick={() => handleEditBrand(brand)}><Edit2 className="h-4 w-4" /></Button>
                      <Button
                        variant="outline"
                        size="icon"
                        aria-label={`Delete ${brand.name}`}
                        className="border-red-100 text-red-600 hover:bg-red-50"
                        disabled={deletingBrandId === brand.id}
                        onClick={() => handleDeleteBrand(brand)}
                      >
                        {deletingBrandId === brand.id ? <Loader2 className="h-4 w-4 animate-spin" /> : <Trash2 className="h-4 w-4" />}
                      </Button>
                    </div>
                  ))}
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
