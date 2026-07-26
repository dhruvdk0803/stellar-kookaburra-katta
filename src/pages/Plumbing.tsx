import React, { useState, useEffect, useMemo } from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import ProductCard from '@/components/ProductCard';
import { useWishlist } from '@/contexts/WishlistContext';
import { supabase } from '@/integrations/supabase/client';
import { Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils';

// Top-level brand categories shown on the plumbing page.
const BRANDS = [
  {
    slug: 'apollo',
    label: 'APL Apollo',
    title: 'APL Apollo CPVC Pipes & Fittings',
    blurb:
      'Genuine APL Apollo CPVC pipes and fittings — engineered for strong, leak-proof, long-lasting hot and cold water plumbing systems.',
  },
  {
    slug: 'astral',
    label: 'Astral',
    title: 'Astral Pipes & Fittings',
    blurb:
      'Astral CPVC & uPVC piping systems — trusted, ISI/ASTM-compliant pipes and fittings for reliable water distribution.',
  },
];

const Plumbing = () => {
  const { isInWishlist, toggleWishlist } = useWishlist();

  const [allProducts, setAllProducts] = useState<any[]>([]);
  const [catsByBrand, setCatsByBrand] = useState<Record<string, any[]>>({});
  const [activeSub, setActiveSub] = useState<string>('all');
  const [activeBrand, setActiveBrand] = useState(BRANDS[0]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);

      const { data: cats } = await supabase
        .from('categories')
        .select('id, name, slug, parent_id');

      // Resolve each brand's subcategories up front so we can tell which brands
      // actually have anything live and hide the ones that don't.
      const subsByBrand: Record<string, any[]> = {};
      const categoryIds: string[] = [];
      for (const brand of BRANDS) {
        const parent = cats?.find(
          (c) => c.slug === brand.slug || c.name?.toLowerCase() === brand.slug
        );
        const subs = parent ? (cats || []).filter((c) => c.parent_id === parent.id) : [];
        subsByBrand[brand.slug] = subs;
        if (parent) categoryIds.push(parent.id, ...subs.map((s) => s.id));
      }
      setCatsByBrand(subsByBrand);

      if (categoryIds.length > 0) {
        const { data: prods } = await supabase
          .from('products')
          .select('*, categories(name, parent_id)')
          .in('category_id', categoryIds)
          .eq('is_active', true)
          .order('price', { ascending: true });
        setAllProducts(prods || []);
      } else {
        setAllProducts([]);
      }

      setLoading(false);
    };

    fetchData();
  }, []);

  const productsForBrand = (slug: string) => {
    const ids = new Set((catsByBrand[slug] || []).map((s) => s.id));
    return allProducts.filter((p) => ids.has(p.category_id));
  };

  // Only offer brands that currently have live products.
  const availableBrands = useMemo(
    () => BRANDS.filter((b) => productsForBrand(b.slug).length > 0),
    [allProducts, catsByBrand]
  );

  // If the selected brand has nothing live, fall back to the first that does.
  useEffect(() => {
    if (loading || availableBrands.length === 0) return;
    if (!availableBrands.some((b) => b.slug === activeBrand.slug)) {
      setActiveBrand(availableBrands[0]);
      setActiveSub('all');
    }
  }, [availableBrands, activeBrand, loading]);

  const products = useMemo(
    () => productsForBrand(activeBrand.slug),
    [allProducts, catsByBrand, activeBrand]
  );
  const subcategories = catsByBrand[activeBrand.slug] || [];

  const visibleProducts = useMemo(() => {
    if (activeSub === 'all') return products;
    return products.filter((p) => p.category_id === activeSub);
  }, [products, activeSub]);

  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="mb-8">
            <h1 className="text-3xl md:text-4xl font-playfair font-bold text-gray-900 mb-2">
              {activeBrand.title}
            </h1>
            <p className="text-gray-500 max-w-2xl">{activeBrand.blurb}</p>
          </div>

          {/* Brand tabs — only brands with live products */}
          <div className={cn('flex gap-2 mb-6', availableBrands.length < 2 && 'hidden')}>
            {availableBrands.map((brand) => (
              <button
                key={brand.slug}
                onClick={() => setActiveBrand(brand)}
                className={cn(
                  'px-5 py-2.5 rounded-lg text-sm font-semibold border transition-colors',
                  activeBrand.slug === brand.slug
                    ? 'bg-gray-900 text-white border-gray-900'
                    : 'bg-white text-gray-700 border-gray-200 hover:border-gray-400'
                )}
              >
                {brand.label}
              </button>
            ))}
          </div>

          {/* Subcategory filter chips */}
          {subcategories.length > 0 && (
            <div className="flex flex-wrap gap-2 mb-8">
              <button
                onClick={() => setActiveSub('all')}
                className={cn(
                  'px-4 py-2 rounded-full text-sm border transition-colors',
                  activeSub === 'all'
                    ? 'bg-primary text-primary-foreground border-primary'
                    : 'bg-white text-gray-700 border-gray-200 hover:border-primary/50'
                )}
              >
                All ({products.length})
              </button>
              {subcategories.map((sub) => {
                const count = products.filter((p) => p.category_id === sub.id).length;
                if (count === 0) return null;
                return (
                  <button
                    key={sub.id}
                    onClick={() => setActiveSub(sub.id)}
                    className={cn(
                      'px-4 py-2 rounded-full text-sm border transition-colors',
                      activeSub === sub.id
                        ? 'bg-primary text-primary-foreground border-primary'
                        : 'bg-white text-gray-700 border-gray-200 hover:border-primary/50'
                    )}
                  >
                    {sub.name} ({count})
                  </button>
                );
              })}
            </div>
          )}

          {loading ? (
            <div className="flex justify-center items-center py-20">
              <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
          ) : visibleProducts.length === 0 ? (
            <div className="text-center py-20">
              <p className="text-gray-500 text-lg">
                No {activeBrand.label} products available yet. Add them from the Admin panel.
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {visibleProducts.map((product) => (
                <ProductCard
                  key={product.id}
                  product={product}
                  isInWishlist={isInWishlist(product.id)}
                  onWishlistToggle={toggleWishlist}
                />
              ))}
            </div>
          )}
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Plumbing;
