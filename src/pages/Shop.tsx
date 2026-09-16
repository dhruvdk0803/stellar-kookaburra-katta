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
import { filterNonEmptyCategories } from '@/lib/categories';

// Fetch all active products with pagination. PostgREST caps any single
// request at 1000 rows regardless of the requested limit, so the catalog
// must be fetched in 1000-row pages until a short page comes back.
async function fetchAllProducts(): Promise<any[]> {
  const PAGE = 1000;
  let all: any[] = [];
  let from = 0;
  for (;;) {
    const { data, error } = await supabase
      .from('products')
      .select('*, categories(name, slug, parent_id), brands(name, slug)')
      .eq('is_active', true)
      .range(from, from + PAGE - 1);
    if (error) throw error;
    if (!data || data.length === 0) break;
    all = all.concat(data);
    if (data.length < PAGE) break;
    from += PAGE;
  }
  return all;
}

const Shop = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const location = useLocation();
  const { isInWishlist, toggleWishlist } = useWishlist();
  
  const [allProducts, setAllProducts] = useState<any[]>([]);
  const [filteredProducts, setFilteredProducts] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortBy, setSortBy] = useState('newest');
  // Price slider ceiling: the highest-priced active product, rounded up to a
  // clean step, so premium items (e.g. digital locks) are never filtered out.
  const [priceMax, setPriceMax] = useState(10000);
  // Brands present in the current category/search selection (before brand
  // filtering), so we only show brand chips when there is more than one.
  const [availableBrands, setAvailableBrands] = useState<{ name: string; slug: string }[]>([]);

  const [filters, setFilters] = useState(() => {
    const categoriesFromUrl = searchParams.getAll('category');
    const brandsFromUrl = searchParams.getAll('brand');
    return {
      category: categoriesFromUrl.length > 0 ? categoriesFromUrl : [],
      brand: brandsFromUrl,
      price: [0, 10000],
    };
  });

  // Fetch products and categories from Supabase
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      
      const [prodRes, catRes] = await Promise.all([
        // Paged fetch (see fetchAllProducts) — a single request caps at 1000
        // rows server-side, which would silently hide everything past #1000.
        fetchAllProducts(),
        supabase.from('categories').select('*')
      ]);

      if (prodRes) {
        setAllProducts(prodRes);
        setFilteredProducts(prodRes);
        // Raise the default price ceiling to cover the whole catalog instead
        // of the old hard-coded ₹10,000 cap.
        const maxPrice = prodRes.reduce((m, p) => Math.max(m, Number(p.price) || 0), 0);
        const roundedMax = Math.ceil(maxPrice / 1000) * 1000;
        setPriceMax(roundedMax);
        setFilters(prev => (prev.price[1] >= roundedMax ? prev : { ...prev, price: [prev.price[0], roundedMax] }));
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
      const categoriesById = new Map(categories.map((category) => [category.id, category]));
      
      newProducts = newProducts.filter(p => {
        let category = categoriesById.get(p.category_id) || p.categories;
        let guard = 0;
        while (category && guard++ < 20) {
          const name = category.name?.toLowerCase().trim();
          const slug = category.slug?.toLowerCase().trim();
          if ((name && filterCats.includes(name)) || (slug && filterCats.includes(slug))) return true;
          category = category.parent_id ? categoriesById.get(category.parent_id) : null;
        }
        
        return false;
      });
    }
    
    // 3. Brand Filter — only meaningful when a material has >1 brand.
    // Brands offered are recomputed from the current category/search selection
    // so the chips always reflect what is actually visible.
    const brandMap = new Map<string, { name: string; slug: string }>();
    newProducts.forEach((product) => {
      if (product.brands?.slug && product.brands?.name) brandMap.set(product.brands.slug, product.brands);
    });
    setAvailableBrands([...brandMap.values()].sort((a, b) => a.name.localeCompare(b.name)));

    if (filters.brand && filters.brand.length > 0) {
      const activeBrands = filters.brand.map((b: string) => b.toLowerCase().trim());
      newProducts = newProducts.filter(p => activeBrands.includes(p.brands?.slug?.toLowerCase().trim()));
    }

    // 4. Price Filter
    if (filters.price && filters.price.length === 2) {
      newProducts = newProducts.filter(p => p.price >= filters.price[0] && p.price <= filters.price[1]);
    }

    // 5. Sorting
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
    const brandsFromUrl = searchParams.getAll('brand');
    setFilters(prevFilters => {
      if (JSON.stringify(prevFilters.category) === JSON.stringify(categoriesFromUrl) && JSON.stringify(prevFilters.brand) === JSON.stringify(brandsFromUrl)) return prevFilters;
      return { ...prevFilters, category: categoriesFromUrl, brand: brandsFromUrl };
    });
  }, [searchParams]);

  const handleFilterChange = (newFilters: any) => {
    setFilters(newFilters);
    const next = new URLSearchParams();
    newFilters.category.forEach((category: string) => next.append('category', category));
    newFilters.brand.forEach((brand: string) => next.append('brand', brand));
    const search = searchParams.get('search');
    if (search) next.set('search', search);
    setSearchParams(next, { replace: true });
  };

  // Only offer categories that actually contain products. The full `categories`
  // list is still used above to resolve parents when filtering.
  const visibleCategories = React.useMemo(
    () => filterNonEmptyCategories(categories, allProducts.map((p) => p.category_id)),
    [categories, allProducts],
  );

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-4 gap-8">
          <aside className="hidden lg:block lg:col-span-1 space-y-6">
            <h2 className="text-2xl font-playfair font-bold text-gray-900">Filters</h2>
            <ShopFilters categories={visibleCategories} onFilterChange={handleFilterChange} filters={filters} priceMax={priceMax} availableBrands={availableBrands} />
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
                        <ShopFilters categories={visibleCategories} onFilterChange={handleFilterChange} filters={filters} priceMax={priceMax} availableBrands={availableBrands} />
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
