import { useEffect, useMemo, useState } from 'react';
import { ArrowRight, Loader2, PackageSearch } from 'lucide-react';
import { Link } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import BrandLogo from '@/components/BrandLogo';
import { Brand, CategoryCard, brandShopUrl, categoryShopUrl, stripKnownBrandPrefix } from '@/lib/catalog';
import { formatRupees } from '@/lib/money';

interface ShelfProduct {
  id: string;
  name: string;
  price: number;
  image_url?: string | null;
  images?: string[] | null;
  brand_name: string;
  root_id: string;
  root_name: string;
  shelf_rank: number;
}

const directCategoryConfig = [
  { slug: 'sunmica', label: 'Laminates & Sunmica' },
  { slug: 'louvers-panels', label: 'Louvers & Wall Panels' },
  // CPVC and uPVC/SWR products now share one category (the database row carries the same name).
  // The slug keeps its original spelling so existing links keep working.
  { slug: 'apollo-cpvc-fittings-pipes', label: 'CPVC & UPVC Fittings' },
  // Hinges, drawer slides, lift-ups and sliding channels all live under this one parent.
  { slug: 'furniture-fitting', label: 'Furniture Fitting' },
  { slug: 'kitchen-hardware', label: 'Kitchen Hardware' },
  { slug: 'ebco-digital-locks', label: 'Digital Locks' },
  { slug: 'jivanjor-adhesives', label: 'Adhesives' },
  { slug: 'doorskin-rockstar', label: 'Decorative Doorskins' },
  { slug: 'flexible-interlocking', label: 'Flexible Wall Panels' },
] as const;

// Cover photos for cards where the automatically picked product photo is not
// representative. A photo the admin sets on the category itself always wins; the
// catalog migration also stores this one on the Furniture Fitting row, and this
// map keeps the card correct if that column is ever emptied.
const categoryCoverImages: Record<string, string> = {
  'furniture-fitting': '/images/categories/furniture-fitting.jpg',
};

const HomeCatalogPremium = () => {
  const [categories, setCategories] = useState<CategoryCard[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [products, setProducts] = useState<ShelfProduct[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    let active = true;
    const load = async () => {
      const [categoryResult, brandResult, productResult] = await Promise.all([
        supabase.from('homepage_category_cards').select('*').order('display_order').order('name'),
        supabase.from('homepage_brand_cards').select('*').order('display_order').order('name'),
        supabase.from('homepage_product_shelves').select('id, name, price, image_url, images, brand_name, root_id, root_name, shelf_rank').order('root_display_order').order('root_name').order('shelf_rank'),
      ]);

      if (!active) return;
      if (categoryResult.error || brandResult.error || productResult.error) {
        setError(true);
      } else {
        setCategories((categoryResult.data || []) as CategoryCard[]);
        setBrands((brandResult.data || []) as Brand[]);
        setProducts((productResult.data || []) as ShelfProduct[]);
      }
      setLoading(false);
    };

    load();
    return () => { active = false; };
  }, []);

  const featuredCategories = useMemo(() => {
    return directCategoryConfig.flatMap(({ slug, label }) => {
      const category = categories.find((item) => item.slug === slug);
      if (!category) return [];

      const fallbackImage = categories.find(
        (item) => item.root_id === category.root_id && item.thumbnail_url,
      )?.thumbnail_url;

      return [{
        ...category,
        displayName: label,
        thumbnail_url: category.image_url || categoryCoverImages[slug] || category.thumbnail_url || fallbackImage,
      }];
    });
  }, [categories]);

  const featuredProducts = useMemo(() => {
    const picks: ShelfProduct[] = [];
    const seenRoots = new Set<string>();
    products.forEach((product) => {
      if (picks.length < 4 && !seenRoots.has(product.root_id)) {
        picks.push(product);
        seenRoots.add(product.root_id);
      }
    });
    products.forEach((product) => {
      if (picks.length < 4 && !picks.some((pick) => pick.id === product.id)) picks.push(product);
    });
    return picks;
  }, [products]);

  if (loading) {
    return <div className="flex min-h-[360px] items-center justify-center bg-[#f3f0e9]"><Loader2 className="h-7 w-7 animate-spin text-[#826f50]" /></div>;
  }

  if (error) {
    return (
      <section className="bg-[#f3f0e9] px-4 py-20">
        <div className="mx-auto max-w-2xl text-center">
          <PackageSearch className="mx-auto h-8 w-8 text-[#826f50]" />
          <h2 className="mt-4 text-3xl text-[#17201d]">The collection is being refreshed.</h2>
          <Link to="/shop" className="mt-6 inline-flex items-center text-sm font-semibold text-[#826f50]">Browse all products <ArrowRight className="ml-2 h-4 w-4" /></Link>
        </div>
      </section>
    );
  }

  return (
    <>
      <section id="categories" className="bg-[#f3f0e9] px-4 py-20 sm:px-6 sm:py-24">
        <div className="mx-auto max-w-7xl">
          <div className="mb-10 flex flex-col justify-between gap-5 sm:flex-row sm:items-end">
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.24em] text-[#8b7655]">Browse by product</p>
              <h2 className="mt-3 text-3xl font-normal text-[#17201d] sm:text-4xl">Shop by category</h2>
            </div>
            <Link to="/shop" className="inline-flex items-center text-sm font-medium text-[#17201d] hover:text-[#8b7655]">View the full collection <ArrowRight className="ml-2 h-4 w-4" /></Link>
          </div>

          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 sm:gap-5 lg:grid-cols-5">
            {featuredCategories.map((category) => (
              <Link key={category.id} to={categoryShopUrl(category.slug)} className="group">
                <div className="aspect-square overflow-hidden rounded-[1.4rem] bg-[#faf9f5] p-3 sm:p-5">
                  {category.thumbnail_url ? (
                    <img src={category.thumbnail_url} alt="" width={320} height={320} loading="lazy" decoding="async" className="h-full w-full object-contain transition duration-700 group-hover:scale-105" />
                  ) : (
                    <div className="flex h-full items-center justify-center"><PackageSearch className="h-8 w-8 text-[#968e80]" /></div>
                  )}
                </div>
                <div className="mt-3 flex items-start justify-between gap-2 px-1">
                  <h3 className="text-sm font-medium leading-5 text-[#17201d] sm:text-base">{category.displayName}</h3>
                  <ArrowRight className="mt-1 h-4 w-4 shrink-0 text-[#8b7655] transition group-hover:translate-x-1" />
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      <section className="bg-white px-4 py-20 sm:px-6 sm:py-24">
        <div className="mx-auto max-w-7xl">
          <div className="mb-10 max-w-xl">
            <p className="text-[11px] font-semibold uppercase tracking-[0.24em] text-[#8b7655]">A thoughtful shortlist</p>
            <h2 className="mt-3 text-3xl font-normal text-[#17201d] sm:text-4xl">Selected for your next project</h2>
          </div>

          <div className="grid gap-x-5 gap-y-10 sm:grid-cols-2 lg:grid-cols-4">
            {featuredProducts.map((product) => {
              const image = product.images?.[0] || product.image_url || '/placeholder.svg';
              return (
                <Link key={product.id} to={`/product/${product.id}`} className="group block">
                  <div className="aspect-square overflow-hidden rounded-[1.5rem] bg-[#f5f4f0] p-5">
                    <img src={image} alt={product.name} width={320} height={320} loading="lazy" decoding="async" className="h-full w-full object-contain transition duration-700 group-hover:scale-[1.04]" />
                  </div>
                  <div className="mt-4 flex items-start justify-between gap-3">
                    <div className="min-w-0">
                      <p className="text-[10px] font-semibold uppercase tracking-[0.16em] text-[#94856d]">{product.brand_name || product.root_name}</p>
                      <h3 className="mt-1 line-clamp-2 text-sm font-medium leading-5 text-[#17201d] sm:text-base">{stripKnownBrandPrefix(product.name, [{ name: product.brand_name || product.root_name }])}</h3>
                      <p className="mt-2 text-sm font-semibold text-[#17201d]">₹{formatRupees(product.price)}</p>
                    </div>
                    <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full border border-[#d8d3c8] transition group-hover:border-[#17201d] group-hover:bg-[#17201d] group-hover:text-white"><ArrowRight className="h-4 w-4" /></span>
                  </div>
                </Link>
              );
            })}
          </div>
        </div>
      </section>

      <section id="brands" className="border-y border-[#dedbd3] bg-[#f8f7f3] px-4 py-14 sm:px-6">
        <div className="mx-auto max-w-7xl">
          <div className="mb-8 flex items-center justify-between gap-4">
            <p className="text-sm font-medium text-[#17201d]">Brands professionals trust</p>
            <Link to="/shop" className="text-xs font-medium text-[#8b7655] hover:underline">Shop all brands</Link>
          </div>
          {/* Every brand with live products is shown: capping the list silently dropped the last one alphabetically. */}
          <div className="grid grid-cols-3 gap-3 sm:grid-cols-4 xl:grid-cols-8">
            {brands.map((brand) => (
              <Link key={brand.id} to={brandShopUrl(brand.slug)} aria-label={brand.name} className="flex h-24 items-center justify-center rounded-xl border border-[#d8d2c7] bg-white p-3 shadow-sm transition hover:-translate-y-0.5 hover:border-[#9b8e78] hover:shadow-md">
                <BrandLogo name={brand.name} logoUrl={brand.logo_url} className="max-h-14 w-full" />
              </Link>
            ))}
          </div>
        </div>
      </section>
    </>
  );
};

export default HomeCatalogPremium;
