import React, { useEffect, useMemo, useState } from 'react';
import { ArrowRight, Loader2, PackageSearch } from 'lucide-react';
import { Link } from 'react-router-dom';
import ProductCard from '@/components/ProductCard';
import { supabase } from '@/integrations/supabase/client';
import { useWishlist } from '@/contexts/WishlistContext';
import { Brand, CategoryCard, brandShopUrl, categoryShopUrl } from '@/lib/catalog';

interface ShelfProduct {
  id: string;
  name: string;
  price: number;
  image_url?: string | null;
  images?: string[] | null;
  stock?: number;
  category_id: string;
  category_name: string;
  category_slug: string;
  brand_id: string;
  brand_name: string;
  brand_slug: string;
  root_id: string;
  root_name: string;
  root_slug: string;
  root_display_order: number;
  shelf_rank: number;
}

interface LegacyCategory {
  id: string;
  name: string;
  slug: string;
  parent_id?: string | null;
  image_url?: string | null;
  display_order?: number;
}

interface LegacyProduct {
  id: string;
  name: string;
  price: number;
  image_url?: string | null;
  images?: string[] | null;
  stock?: number;
  category_id: string;
  created_at: string;
}

const fallbackBrands = [
  { name: 'Ebco', slug: 'ebco', logo_url: '/images/brands/ebco.svg' },
  { name: 'Apollo', slug: 'apollo', logo_url: '/images/brands/apollo.svg' },
  { name: 'Astral', slug: 'astral', logo_url: '/images/brands/astral.svg' },
  { name: 'Jivanjor', slug: 'jivanjor', logo_url: '/images/brands/jivanjor.svg' },
  { name: 'Rockstar', slug: 'rockstar', logo_url: '/images/brands/rockstar.svg' },
  { name: 'Gloirio', slug: 'gloirio', logo_url: '/images/brands/gloirio.svg' },
  { name: 'Rang', slug: 'rang', logo_url: '/images/brands/rang.svg' },
];

const loadLegacyPreview = async () => {
  const categoryResult = await supabase.from('categories').select('id, name, slug, parent_id, image_url, display_order').order('name');
  if (categoryResult.error) {
    // The merchandising columns are added by the migration; retry using the
    // current production schema so the design remains previewable beforehand.
    const retry = await supabase.from('categories').select('id, name, slug, parent_id').order('name');
    if (retry.error) throw retry.error;
    categoryResult.data = retry.data;
  }

  const legacyProducts: LegacyProduct[] = [];
  for (let from = 0; ; from += 1000) {
    const page = await supabase
      .from('products')
      .select('id, name, price, image_url, images, stock, category_id, created_at')
      .eq('is_active', true)
      .order('created_at', { ascending: false })
      .range(from, from + 999);
    if (page.error) throw page.error;
    legacyProducts.push(...((page.data || []) as LegacyProduct[]));
    if (!page.data || page.data.length < 1000) break;
  }

  const legacyCategories = (categoryResult.data || []) as LegacyCategory[];
  const byId = new Map(legacyCategories.map((category) => [category.id, category]));
  const ancestry = (categoryId: string) => {
    const result: LegacyCategory[] = [];
    let current = byId.get(categoryId);
    let guard = 0;
    while (current && guard++ < 20) {
      result.push(current);
      current = current.parent_id ? byId.get(current.parent_id) : undefined;
    }
    return result;
  };
  const brandFor = (product: LegacyProduct) => {
    const direct = fallbackBrands.find((brand) => product.name.toLowerCase().startsWith(`${brand.name.toLowerCase()} `));
    if (direct) return direct;
    const rootName = ancestry(product.category_id).at(-1)?.name.toLowerCase();
    return fallbackBrands.find((brand) => brand.name.toLowerCase() === rootName) || fallbackBrands.find((brand) => brand.slug === 'rang')!;
  };

  const categoryCards: CategoryCard[] = legacyCategories.flatMap((category) => {
    const matches = legacyProducts.filter((product) => ancestry(product.category_id).some((ancestor) => ancestor.id === category.id));
    if (!matches.length) return [];
    const root = ancestry(category.id).at(-1) || category;
    return [{
      ...category,
      display_order: category.display_order || 0,
      product_count: matches.length,
      thumbnail_url: category.image_url || matches.find((product) => product.images?.[0] || product.image_url)?.images?.[0] || matches[0]?.image_url,
      root_id: root.id,
      root_name: root.name,
      root_slug: root.slug,
      root_display_order: root.display_order || 0,
    }];
  });

  const brandCounts = new Map<string, number>();
  legacyProducts.forEach((product) => {
    const brand = brandFor(product);
    brandCounts.set(brand.slug, (brandCounts.get(brand.slug) || 0) + 1);
  });
  const brandCards: Brand[] = fallbackBrands.flatMap((brand, index) => {
    const productCount = brandCounts.get(brand.slug) || 0;
    return productCount ? [{ ...brand, id: brand.slug, display_order: index * 10, product_count: productCount }] : [];
  });

  const shelfCounts = new Map<string, number>();
  const shelfProducts: ShelfProduct[] = [];
  legacyProducts.forEach((product) => {
    const path = ancestry(product.category_id);
    const category = path[0];
    const root = path.at(-1);
    if (!category || !root || (shelfCounts.get(root.id) || 0) >= 8) return;
    const brand = brandFor(product);
    const rank = (shelfCounts.get(root.id) || 0) + 1;
    shelfCounts.set(root.id, rank);
    shelfProducts.push({
      ...product,
      category_name: category.name,
      category_slug: category.slug,
      brand_id: brand.slug,
      brand_name: brand.name,
      brand_slug: brand.slug,
      root_id: root.id,
      root_name: root.name,
      root_slug: root.slug,
      root_display_order: root.display_order || 0,
      shelf_rank: rank,
    });
  });

  return { categories: categoryCards, brands: brandCards, products: shelfProducts };
};

const sortByDisplayOrder = <T extends { display_order?: number; name: string }>(items: T[]) =>
  [...items].sort((a, b) => (a.display_order || 0) - (b.display_order || 0) || a.name.localeCompare(b.name));

const HomeCatalog = () => {
  const { isInWishlist, toggleWishlist } = useWishlist();
  const [categories, setCategories] = useState<CategoryCard[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [products, setProducts] = useState<ShelfProduct[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    let active = true;
    const load = async () => {
      const [categoryResult, brandResult, shelfResult] = await Promise.all([
        supabase.from('homepage_category_cards').select('*').order('display_order').order('name'),
        supabase.from('homepage_brand_cards').select('*').order('display_order').order('name'),
        supabase.from('homepage_product_shelves').select('*').order('root_display_order').order('root_name').order('shelf_rank'),
      ]);
      if (!active) return;
      const failed = categoryResult.error || brandResult.error || shelfResult.error;
      if (!failed) {
        setCategories((categoryResult.data || []) as CategoryCard[]);
        setBrands((brandResult.data || []) as Brand[]);
        setProducts((shelfResult.data || []) as ShelfProduct[]);
      } else {
        try {
          const fallback = await loadLegacyPreview();
          if (!active) return;
          setCategories(fallback.categories);
          setBrands(fallback.brands);
          setProducts(fallback.products);
        } catch {
          setError(true);
        }
      }
      setLoading(false);
    };
    load();
    return () => { active = false; };
  }, []);

  const categoryGroups = useMemo(() => {
    const roots = sortByDisplayOrder(categories.filter((category) => category.id === category.root_id));
    return roots.map((root) => {
      const children = sortByDisplayOrder(categories.filter((category) => category.root_id === root.id && category.id !== root.id));
      return { root, cards: children.length ? children : [root] };
    });
  }, [categories]);

  const shelves = useMemo(() => {
    const grouped = new Map<string, { id: string; name: string; slug: string; products: ShelfProduct[] }>();
    products.forEach((product) => {
      const shelf = grouped.get(product.root_id) || {
        id: product.root_id,
        name: product.root_name,
        slug: product.root_slug,
        products: [],
      };
      shelf.products.push(product);
      grouped.set(product.root_id, shelf);
    });
    return [...grouped.values()];
  }, [products]);

  if (loading) {
    return <div className="flex min-h-[420px] items-center justify-center"><Loader2 className="h-8 w-8 animate-spin text-primary" /></div>;
  }

  if (error) {
    return (
      <section className="px-4 py-16">
        <div className="mx-auto max-w-3xl rounded-3xl border border-amber-200 bg-amber-50 p-8 text-center">
          <PackageSearch className="mx-auto mb-4 h-9 w-9 text-amber-700" />
          <h2 className="text-2xl font-bold text-gray-900">The new catalog is being prepared</h2>
          <p className="mt-2 text-sm text-gray-600">Browse the complete range while the homepage catalog refreshes.</p>
          <Link to="/shop" className="mt-5 inline-flex items-center font-semibold text-primary hover:underline">Shop all products <ArrowRight className="ml-2 h-4 w-4" /></Link>
        </div>
      </section>
    );
  }

  return (
    <>
      <section id="categories" className="bg-white px-4 py-12 sm:py-16">
        <div className="mx-auto max-w-7xl">
          <div className="mb-10 text-center">
            <p className="mb-2 text-xs font-bold uppercase tracking-[0.22em] text-primary/70">Everything for better spaces</p>
            <h2 className="text-3xl font-bold text-gray-950 sm:text-4xl">Shop by category</h2>
            <p className="mx-auto mt-3 max-w-2xl text-sm text-gray-600 sm:text-base">Browse every available category, from surface finishes to plumbing and architectural hardware.</p>
          </div>

          <div className="space-y-12">
            {categoryGroups.map(({ root, cards }) => (
              <div key={root.id}>
                <div className="mb-5 flex items-end justify-between gap-4">
                  <div>
                    <h3 className="text-2xl font-bold text-gray-900">{root.name}</h3>
                    <p className="mt-1 text-sm text-gray-500">{root.product_count} products</p>
                  </div>
                  <Link to={categoryShopUrl(root.slug)} className="inline-flex items-center text-sm font-semibold text-primary hover:underline">
                    View all <ArrowRight className="ml-1 h-4 w-4" />
                  </Link>
                </div>
                <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 sm:gap-5 lg:grid-cols-5 xl:grid-cols-6">
                  {cards.map((category) => (
                    <Link key={category.id} to={categoryShopUrl(category.slug)} className="group overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm transition duration-300 hover:-translate-y-1 hover:shadow-lg focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                      <div className="aspect-[4/3] overflow-hidden bg-gray-100">
                        {category.thumbnail_url ? (
                          <img src={category.thumbnail_url} alt="" loading="lazy" className="h-full w-full object-cover transition duration-500 group-hover:scale-105" />
                        ) : (
                          <div className="flex h-full items-center justify-center bg-gradient-to-br from-slate-100 to-stone-200"><PackageSearch className="h-8 w-8 text-slate-400" /></div>
                        )}
                      </div>
                      <div className="p-3 sm:p-4">
                        <h4 className="line-clamp-2 text-sm font-semibold leading-snug text-gray-900 sm:text-base">{category.name}</h4>
                        <p className="mt-1 text-xs text-gray-500">{category.product_count} products</p>
                      </div>
                    </Link>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section id="brands" className="border-y border-stone-200 bg-stone-50 px-4 py-12 sm:py-16">
        <div className="mx-auto max-w-7xl">
          <div className="mb-9 flex flex-col justify-between gap-3 sm:flex-row sm:items-end">
            <div>
              <p className="mb-2 text-xs font-bold uppercase tracking-[0.22em] text-primary/70">Trusted names in our catalog</p>
              <h2 className="text-3xl font-bold text-gray-950 sm:text-4xl">Shop by brand</h2>
            </div>
            <p className="max-w-lg text-sm text-gray-600">Choose a manufacturer to see every available product from that brand.</p>
          </div>
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-8">
            {brands.map((brand) => (
              <Link key={brand.id} to={brandShopUrl(brand.slug)} className="group flex min-h-32 flex-col items-center justify-center rounded-2xl border border-gray-200 bg-white p-4 text-center shadow-sm transition hover:-translate-y-1 hover:border-gray-300 hover:shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                {brand.logo_url ? (
                  <img src={brand.logo_url} alt={`${brand.name} logo`} loading="lazy" className="h-14 w-full object-contain transition group-hover:scale-105" />
                ) : (
                  <span className="text-xl font-bold text-gray-900">{brand.name}</span>
                )}
                <span className="mt-2 text-xs text-gray-500">{brand.product_count} products</span>
              </Link>
            ))}
          </div>
        </div>
      </section>

      <section className="bg-white px-4 py-12 sm:py-16">
        <div className="mx-auto max-w-7xl space-y-14">
          {shelves.map((shelf) => (
            <div key={shelf.id}>
              <div className="mb-6 flex items-end justify-between gap-4">
                <div>
                  <p className="mb-1 text-xs font-bold uppercase tracking-[0.18em] text-gray-400">Discover products</p>
                  <h2 className="text-2xl font-bold text-gray-950 sm:text-3xl">Shop {shelf.name}</h2>
                </div>
                <Link to={categoryShopUrl(shelf.slug)} className="inline-flex items-center whitespace-nowrap text-sm font-semibold text-primary hover:underline">View all <ArrowRight className="ml-1 h-4 w-4" /></Link>
              </div>
              <div className="-mx-4 flex snap-x snap-mandatory gap-4 overflow-x-auto px-4 pb-4 sm:mx-0 sm:grid sm:grid-cols-2 sm:overflow-visible sm:px-0 lg:grid-cols-4">
                {shelf.products.map((product) => (
                  <div key={product.id} className="w-[78vw] max-w-[310px] flex-none snap-start sm:w-auto sm:max-w-none">
                    <ProductCard
                      product={{ ...product, categories: { name: product.category_name, slug: product.category_slug }, brands: { name: product.brand_name, slug: product.brand_slug } }}
                      isInWishlist={isInWishlist(product.id)}
                      onWishlistToggle={toggleWishlist}
                    />
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </section>
    </>
  );
};

export default HomeCatalog;
