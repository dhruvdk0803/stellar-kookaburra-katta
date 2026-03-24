import React, { useState, useEffect } from 'react';
import { useLocation, useSearchParams } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import ShopFilters from '@/components/ShopFilters';
import ProductCard from '@/components/ProductCard';
import Footer from '@/components/Footer';
import { useWishlist } from '@/contexts/WishlistContext';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Filter, Loader2 } from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';

const Shop = () => {
  const [searchParams] = useSearchParams();
  const location = useLocation();
  const { isInWishlist, toggleWishlist } = useWishlist();
  
  const [allProducts, setAllProducts] = useState<any[]>([]);
  const [filteredProducts, setFilteredProducts] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortBy, setSortBy] = useState('newest');

  const [filters, setFilters] = useState(() => {
    const categoriesFromUrl = searchParams.getAll('category');
    return {
      category: categoriesFromUrl.length > 0 ? categoriesFromUrl : [],
      price: [0, 10000],
    };
  });

  // Fetch products and categories from Supabase
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      
      const [prodRes, catRes] = await Promise.all([
        supabase.from('products').select('*, categories(name, parent_id)').eq('is_active', true),
        supabase.from('categories').select('*')
      ]);
      
      if (prodRes.data) {
        setAllProducts(prodRes.data);
        setFilteredProducts(prodRes.data);
      }
      if (catRes.data) {
        setCategories(catRes.data);
      }
      
      setLoading(false);
    };
    fetchData();
  }, []);

  // Apply Filters and Sorting locally
  useEffect(() => {
    const search = location.state?.search || searchParams.get('search');
    let newProducts = [...allProducts];

    // 1. Search
    if (search) {
      newProducts = newProducts.filter(p => p.name.toLowerCase().includes(search.toLowerCase()));
    }

    // 2. Category Filter (Case-insensitive and robust)
    if (filters.category && filters.category.length > 0) {
      const filterCats = filters.category.map((c: string) => c.toLowerCase().trim());
      
      newProducts = newProducts.filter(p => {
        // Check direct category
        const catName = p.categories?.name?.toLowerCase().trim();
        if (catName && filterCats.includes(catName)) return true;
        
        // Check parent category
        if (p.categories?.parent_id && categories.length > 0) {
          const parentCat = categories.find(c => c.id === p.categories.parent_id);
          if (parentCat && parentCat.name) {
            const parentName = parentCat.name.toLowerCase().trim();
            if (filterCats.includes(parentName)) return true;
          }
        }
        
        return false;
      });
    }
    
    // 3. Price Filter
    if (filters.price && filters.price.length === 2) {
      newProducts = newProducts.filter(p => p.price >= filters.price[0] && p.price <= filters.price[1]);
    }

    // 4. Sorting
    if (sortBy === 'price-asc') {
      newProducts.sort((a, b) => a.price - b.price);
    } else if (sortBy === 'price-desc') {
      newProducts.sort((a, b) => b.price - a.price);
    } else if (sortBy === 'newest') {
      newProducts.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
    }

    setFilteredProducts(newProducts);
  }, [searchParams, location.state, filters, allProducts, sortBy, categories]);

  // Sync URL params to state on initial load or URL change
  useEffect(() => {
    const categoriesFromUrl = searchParams.getAll('category');
    if (categoriesFromUrl.length > 0) {
      setFilters(prevFilters => {
        // Only update if different to prevent unnecessary re-renders
        if (JSON.stringify(prevFilters.category) !== JSON.stringify(categoriesFromUrl)) {
          return { ...prevFilters, category: categoriesFromUrl };
        }
        return prevFilters;
      });
    }
  }, [searchParams]);

  const handleFilterChange = (newFilters: any) => {
    setFilters(newFilters);
  };

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-4 gap-8">
          <aside className="hidden lg:block lg:col-span-1 space-y-6">
            <h2 className="text-2xl font-playfair font-bold text-gray-900">Filters</h2>
            <ShopFilters categories={categories} onFilterChange={handleFilterChange} initialFilters={filters} />
          </aside>

          <main className="lg:col-span-3">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
              <h2 className="text-3xl font-playfair font-bold text-gray-900">Shop</h2>
              
              <div className="flex items-center gap-4 w-full sm:w-auto">
                <p className="text-gray-600 hidden sm:block whitespace-nowrap">{filteredProducts.length} products</p>
                
                <Select value={sortBy} onValueChange={setSortBy}>
                  <SelectTrigger className="w-full sm:w-[180px] bg-white">
                    <SelectValue placeholder="Sort by" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="newest">Newest Arrivals</SelectItem>
                    <SelectItem value="price-asc">Price: Low to High</SelectItem>
                    <SelectItem value="price-desc">Price: High to Low</SelectItem>
                  </SelectContent>
                </Select>

                <div className="lg:hidden">
                  <Sheet>
                    <SheetTrigger asChild>
                      <Button variant="outline" className="flex items-center gap-2">
                        <Filter className="h-4 w-4" />
                        <span className="hidden sm:inline">Filters</span>
                      </Button>
                    </SheetTrigger>
                    <SheetContent side="left" className="w-full max-w-sm overflow-y-auto">
                      <SheetHeader>
                        <SheetTitle>Filters</SheetTitle>
                      </SheetHeader>
                      <div className="py-4">
                        <ShopFilters categories={categories} onFilterChange={handleFilterChange} initialFilters={filters} />
                      </div>
                    </SheetContent>
                  </Sheet>
                </div>
              </div>
            </div>

            {loading ? (
              <div className="flex justify-center items-center py-20">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
              </div>
            ) : (
              <>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                  {filteredProducts.map((product) => (
                    <ProductCard
                      key={product.id}
                      product={product}
                      isInWishlist={isInWishlist(product.id)}
                      onWishlistToggle={toggleWishlist}
                    />
                  ))}
                </div>
                {filteredProducts.length === 0 && (
                  <div className="text-center py-12">
                    <p className="text-gray-500 text-lg">No products found. Try adjusting your filters or add some from the Admin panel.</p>
                  </div>
                )}
              </>
            )}
          </main>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Shop;