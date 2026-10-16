import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { Brand } from '@/lib/catalog';
import { HomeCategoryRow, HomeProductRow, pickHomeCategories, pickNewArrivals } from '@/lib/homeCatalog';

// Short stale time + refetch on focus: a product, brand or category the admin
// adds shows up the next time a visitor opens or returns to the homepage.
const freshness = { staleTime: 60_000, refetchOnWindowFocus: true } as const;

export const useHomeCategories = () =>
  useQuery({
    queryKey: ['home', 'categories'],
    ...freshness,
    queryFn: async () => {
      const [cards, brands] = await Promise.all([
        supabase.from('homepage_category_cards').select('id, name, slug, parent_id, image_url, thumbnail_url, display_order, product_count, root_id, root_name'),
        supabase.from('brands').select('name'),
      ]);
      if (cards.error) throw cards.error;
      // Brand names only decide which roots are brand folders; without them every root still shows.
      const brandNames = (brands.data || []).map((brand) => brand.name as string);
      return pickHomeCategories((cards.data || []) as HomeCategoryRow[], brandNames);
    },
  });

export const useHomeBrands = () =>
  useQuery({
    queryKey: ['home', 'brands'],
    ...freshness,
    queryFn: async () => {
      const { data, error } = await supabase
        .from('homepage_brand_cards')
        .select('id, name, slug, logo_url, display_order, product_count')
        .order('display_order')
        .order('product_count', { ascending: false });
      if (error) throw error;
      return (data || []) as Brand[];
    },
  });

export const useNewArrivals = (limit = 8) =>
  useQuery({
    queryKey: ['home', 'new-arrivals', limit],
    ...freshness,
    queryFn: async () => {
      const { data, error } = await supabase
        .from('products')
        .select('id, name, price, image_url, images, variants, created_at, category_id, brands(name)')
        .eq('is_active', true)
        .order('created_at', { ascending: false })
        .limit(60);
      if (error) throw error;
      return pickNewArrivals((data || []) as unknown as HomeProductRow[], limit);
    },
  });
