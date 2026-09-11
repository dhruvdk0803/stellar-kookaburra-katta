import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Loader2 } from 'lucide-react';
import ProductCard from '@/components/ProductCard';
import { supabase } from '@/integrations/supabase/client';
import { useWishlist } from '@/contexts/WishlistContext';
import { filterNonEmptyCategories } from '@/lib/categories';
import { brandsIn } from '@/lib/brands';

// Page the full catalog past PostgREST's 1000-row cap (see MISTAKES.md #6/#7).
async function fetchAllProducts(): Promise<any[]> {
  const PAGE = 1000;
  let all: any[] = [];
  let from = 0;
  for (;;) {
    const { data, error } = await supabase
      .from('products')
      .select('*, categories(name, parent_id)')
      .eq('is_active', true)
      .range(from, from + PAGE - 1);
    if (error) break;
    if (!data || data.length === 0) break;
    all = all.concat(data);
    if (data.length < PAGE) break;
    from += PAGE;
  }
  return all;
}

/**
 * Material-first homepage section. Each top-level material (Sunmica, Apollo,
 * Louvers/Panels, Ebco, Jivanjor) gets its own heading + horizontal product
 * rail, mirroring home-run.co's layout while keeping the brand's own identity.
 */
const MaterialSections = () => {
  const { isInWishlist, toggleWishlist } = useWishlist();

  const [products, setProducts] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      const [prods, cats] = await Promise.all([
        fetchAllProducts(),
        supabase.from('categories').select('*'),
      ]);
      setProducts(prods || []);
      setCategories(cats.data || []);
      setLoading(false);
    };
    load();
  }, []);

  if (loading) {
    return (
      <section className="py-20 px-4 bg-white flex justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </section>
    );
  }

  // Top-level categories that actually have products, kept in a stable order.
  // Count over the FULL category list so subcategory counts roll up into roots.
  const roots = filterNonEmptyCategories(
    categories,
    products.map((p) => p.category_id),
  ).filter((c) => !c.parent_id);

  // Resolve the top-level category for a product (walk parent_id chain).
  const byId = new Map(categories.map((c) => [c.id, c]));
  const rootOf = (product: any) => {
    let cur = byId.get(product.category_id);
    let guard = 0;
    while (cur && cur.parent_id && guard++ < 20) {
      const parent = byId.get(cur.parent_id);
      if (!parent) break;
      cur = parent;
    }
    return cur;
  };

  const sections = roots
    .map((root) => {
      const allItems = products.filter((p) => rootOf(p)?.id === root.id);
      return {
        root,
        brands: brandsIn(allItems, categories),
        items: allItems.slice(0, 8),
      };
    })
    .filter((s) => s.items.length > 0);

  if (sections.length === 0) return null;

  return (
    <section className="py-20 px-4 bg-white">
      <div className="max-w-7xl mx-auto">
        {sections.map(({ root, brands, items }) => {
          return (
            <div key={root.id} className="mb-20 last:mb-0">
              <div className="flex items-end justify-between mb-8">
                <div>
                  <h2 className="text-3xl md:text-4xl font-playfair font-bold text-gray-900">
                    {root.name}
                  </h2>
                  {brands.length > 0 && (
                    <p className="text-gray-500 mt-1 font-poppins">
                      {brands.length > 1
                        ? `Brands: ${brands.join(', ')}`
                        : `Brand: ${brands[0]}`}
                    </p>
                  )}
                </div>
                <Link
                  to={`/shop?category=${encodeURIComponent(root.name)}`}
                  className="text-primary font-medium hover:underline whitespace-nowrap"
                >
                  View all
                </Link>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                {items.map((product) => (
                  <ProductCard
                    key={product.id}
                    product={product}
                    isInWishlist={isInWishlist(product.id)}
                    onWishlistToggle={toggleWishlist}
                  />
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
};

export default MaterialSections;