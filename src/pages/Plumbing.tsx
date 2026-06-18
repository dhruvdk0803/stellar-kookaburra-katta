import React, { useState, useEffect, useMemo } from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import ProductCard from '@/components/ProductCard';
import { useWishlist } from '@/contexts/WishlistContext';
import { supabase } from '@/integrations/supabase/client';
import { Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils';

// Top-level category that groups all APL Apollo building-material products.
const APOLLO_PARENT_SLUG = 'apollo';

const Plumbing = () => {
  const { isInWishlist, toggleWishlist } = useWishlist();

  const [products, setProducts] = useState<any[]>([]);
  const [subcategories, setSubcategories] = useState<any[]>([]);
  const [activeSub, setActiveSub] = useState<string>('all');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);

      // 1. Find the Apollo parent category and its subcategories.
      const { data: cats } = await supabase
        .from('categories')
        .select('id, name, slug, parent_id');

      const parent = cats?.find(
        (c) => c.slug === APOLLO_PARENT_SLUG || c.name?.toLowerCase() === 'apollo'
      );

      let subs: any[] = [];
      let categoryIds: string[] = [];
      if (parent) {
        subs = (cats || []).filter((c) => c.parent_id === parent.id);
        categoryIds = [parent.id, ...subs.map((s) => s.id)];
      }
      setSubcategories(subs);

      // 2. Fetch active products belonging to Apollo categories.
      if (categoryIds.length > 0) {
        const { data: prods } = await supabase
          .from('products')
          .select('*, categories(name, parent_id)')
          .in('category_id', categoryIds)
          .eq('is_active', true)
          .order('price', { ascending: true });
        setProducts(prods || []);
      } else {
        setProducts([]);
      }

      setLoading(false);
    };

    fetchData();
  }, []);

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
              APL Apollo Plumbing & Building Materials
            </h1>
            <p className="text-gray-500 max-w-2xl">
              Genuine APL Apollo CPVC &amp; uPVC pipes, SWR drainage fittings, water tanks and
              solvent cement — engineered for strong, leak-proof, long-lasting plumbing systems.
            </p>
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
                No Apollo products available yet. Add them from the Admin panel.
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
