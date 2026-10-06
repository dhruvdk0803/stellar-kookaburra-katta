import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { sortTiers, type DiscountTier } from '@/lib/discounts';

export const DISCOUNT_TIERS_QUERY_KEY = ['discount-tiers'] as const;

const NO_TIERS: DiscountTier[] = [];

const fetchDiscountTiers = async (): Promise<DiscountTier[]> => {
  const { data, error } = await supabase
    .from('discount_tiers')
    .select('min_subtotal, discount_percent')
    .eq('is_active', true)
    .order('min_subtotal', { ascending: true });
  if (error) {
    console.error('Could not load discount tiers:', error);
    throw error;
  }
  return sortTiers(
    (data ?? []).map((row) => ({
      min_subtotal: Number(row.min_subtotal),
      discount_percent: Number(row.discount_percent),
    })),
  );
};

/**
 * Active cart-value discount tiers, ascending by `min_subtotal`.
 *
 * On error (or before the table exists) this returns no tiers, so the UI shows
 * no discount; the order edge functions stay authoritative and answer a stale
 * total with HTTP 409 plus the server's figures. After such a 409, invalidate
 * DISCOUNT_TIERS_QUERY_KEY to refresh.
 */
export const useDiscountTiers = (): { tiers: DiscountTier[]; isLoading: boolean } => {
  const { data, isLoading } = useQuery({
    queryKey: DISCOUNT_TIERS_QUERY_KEY,
    queryFn: fetchDiscountTiers,
    staleTime: 5 * 60 * 1000,
    retry: 1,
  });
  return { tiers: data ?? NO_TIERS, isLoading };
};
