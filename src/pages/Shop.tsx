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
import { filterNonEmptyCategories, productBrowsingCategories } from '@/lib/categories';

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

const normalizeFilterValue = (value: unknown) => String(value || '').toLowerCase().trim();

interface ProductCategoryFacet {
  id: string;
  name: string;
  slug?: string | null;
  parent_id?: string | null;
}

interface ProductFacetRow {
  category_id?: string | null;
  categories?: ProductCategoryFacet | null;
}

const getProductCategoryTokens = (product: ProductFacetRow, categoriesById: Map<string, ProductCategoryFacet>) => {
  const tokens = new Set<string>();
  let category = categoriesById.get(product.category_id) || product.categories;
  let guard = 0;
  while (category && guard++ < 20) {
    if (category.name) tokens.add(normalizeFilterValue(category.name));
    if (category.slug) tokens.add(normalizeFilterValue(category.slug));
    category = category.parent_id ? categoriesById.get(category.parent_id) : null;
  }
  return tokens;
};

const productMatchesSelectedCategories = (product: ProductFacetRow, selectedCategories: string[], categoriesById: Map<string, ProductCategoryFacet>) => {
  if (!selectedCategories.length) return true;
  const productTokens = getProductCategoryTokens(product, categoriesById);
  return selectedCategories.some((category) => productTokens.has(normalizeFilterValue(category)));
};

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

  const categoriesById = React.useMemo(() => new Map(categories.map((category) => [category.id, category])), [categories]);
  const searchTerm = location.state?.search || searchParams.get('search') || '';
  const searchMatchedProducts = React.useMemo(() => {
    const normalizedSearch = normalizeFilterValue(searchTerm);
    return normalizedSearch
      ? allProducts.filter((product) => normalizeFilterValue(product.name).includes(normalizedSearch))
      : allProducts;
  }, [allProducts, searchTerm]);

  // Facets cross-filter each other: a selected brand narrows categories, and
  // selected categories narrow available brands. Exclude each facet's own
  // current selection so users can still change or clear it.
  const categoryFacetProducts = React.useMemo(() => {
    if (!filters.brand.length) return searchMatchedProducts;
    const selectedBrands = new Set(filters.brand.map(normalizeFilterValue));
    return searchMatchedProducts.filter((product) => selectedBrands.has(normalizeFilterValue(product.brands?.slug)));
  }, [filters.brand, searchMatchedProducts]);
  const visibleCategories = React.useMemo(
    () => productBrowsingCategories(filterNonEmptyCategories(categories, categoryFacetProducts.map((product) => product.category_id))),
    [categories, categoryFacetProducts],
  );
  const availableBrands = React.useMemo(() => {
    const brandFacetProducts = searchMatchedProducts.filter((product) =>
      productMatchesSelectedCategories(product, filters.category, categoriesById),
    );
    const brandMap = new Map<string, { name: string; slug: string }>();
    brandFacetProducts.forEach((product) => {
      if (product.brands?.slug && product.brands?.name) brandMap.set(product.brands.slug, product.brands);
    });
    return [...brandMap.values()].sort((a, b) => a.name.localeCompare(b.name));
  }, [categoriesById, filters.category, searchMatchedProducts]);

  // Apply Filters and Sorting locally
  useEffect(() => {
    let newProducts = searchMatchedProducts.filter((product) =>
      productMatchesSelectedCategories(product, filters.category, categoriesById),
    );
    if (filters.brand.length > 0) {
      const activeBrands = new Set(filters.brand.map(normalizeFilterValue));
      newProducts = newProducts.filter((product) => activeBrands.has(normalizeFilterValue(product.brands?.slug)));
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
  }, [filters, searchMatchedProducts, sortBy, categoriesById]);

  // Sync URL params to state on initial load or URL change
  useEffect(() => {
    const categoriesFromUrl = searchParams.getAll('category');
    const brandsFromUrl = searchParams.getAll('brand');
    setFilters(prevFilters => {
      if (JSON.stringify(prevFilters.category) === JSON.stringify(categoriesFromUrl) && JSON.stringify(prevFilters.brand) === JSON.stringify(brandsFromUrl)) return prevFilters;
      return { ...prevFilters, category: categoriesFromUrl, brand: brandsFromUrl };
    });
  }, [searchParams]);

  // Also normalize bookmarked or manually edited URLs: a category that does
  // not exist for the selected brand must not leave an invisible active filter.
  useEffect(() => {
    if (!filters.brand.length || !filters.category.length || !allProducts.length) return;
    const selectedBrands = new Set(filters.brand.map(normalizeFilterValue));
    const matchingBrandProducts = searchMatchedProducts.filter((product) => selectedBrands.has(normalizeFilterValue(product.brands?.slug)));
    const validCategories = filters.category.filter((category) =>
      matchingBrandProducts.some((product) => productMatchesSelectedCategories(product, [category], categoriesById)),
    );
    if (validCategories.length === filters.category.length) return;

    const nextFilters = { ...filters, category: validCategories };
    setFilters(nextFilters);
    const nextParams = new URLSearchParams();
    nextFilters.category.forEach((category) => nextParams.append('category', category));
    nextFilters.brand.forEach((brand) => nextParams.append('brand', brand));
    const search = searchParams.get('search');
    if (search) nextParams.set('search', search);
    setSearchParams(nextParams, { replace: true });
  }, [allProducts.length, categoriesById, filters, searchMatchedProducts, searchParams, setSearchParams]);

  const handleFilterChange = (newFilters: any) => {
    const normalizedFilters = { ...newFilters, category: newFilters.category || [], brand: newFilters.brand || [] };
    const brandSelectionChanged = JSON.stringify(filters.brand) !== JSON.stringify(normalizedFilters.brand);
    if (brandSelectionChanged && normalizedFilters.brand.length > 0 && normalizedFilters.category.length > 0) {
      const selectedBrands = new Set(normalizedFilters.brand.map(normalizeFilterValue));
      const brandProducts = searchMatchedProducts.filter((product) => selectedBrands.has(normalizeFilterValue(product.brands?.slug)));
      const validCategories = normalizedFilters.category.filter((category: string) =>
        brandProducts.some((product) => productMatchesSelectedCategories(product, [category], categoriesById)),
      );
      normalizedFilters.category = validCategories;
    }

    setFilters(normalizedFilters);
    const next = new URLSearchParams();
    normalizedFilters.category.forEach((category: string) => next.append('category', category));
    normalizedFilters.brand.forEach((brand: string) => next.append('brand', brand));
    const search = searchParams.get('search');
    if (search) next.set('search', search);
    setSearchParams(next, { replace: true });
  };

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
