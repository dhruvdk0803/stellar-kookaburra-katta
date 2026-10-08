import { useEffect, useState } from 'react';
import { keepPreviousData, useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { MAX_DISCOUNT_PERCENT } from '@/lib/discounts';

export const CART_DISCOUNT_QUERY_KEY = ['cart-discount'] as const;

/** Wait this long after the last cart change before asking the server. */
const DEBOUNCE_MS = 250;

interface CartLine {
  id: string;
  quantity: number;
}

/** Canonical, order-independent key for a cart: sorted `id:qty` joined with `|`. '' for an empty cart. */
export const cartDiscountKey = (cart: ReadonlyArray<CartLine>): string =>
  cart
    .filter((item) => item.quantity > 0)
    .map((item) => `${item.id}:${item.quantity}`)
    .sort()
    .join('|');

/** Parse a canonical key back into RPC lines (ids may contain ':' for variants, so split on the LAST one). */
const keyToItems = (key: string): { product_id: string; quantity: number }[] =>
  key === ''
    ? []
    : key.split('|').map((part) => {
        const at = part.lastIndexOf(':');
        return { product_id: part.slice(0, at), quantity: Number(part.slice(at + 1)) };
      });

const fetchCartDiscount = async (key: string): Promise<number> => {
  const { data, error } = await supabase.rpc('get_cart_discount_percent', { p_items: keyToItems(key) });
  if (error) {
    console.error('Could not load the automatic random discount:', error);
    throw error;
  }
  const percent = Number(data);
  return Number.isFinite(percent) ? Math.min(Math.max(percent, 0), MAX_DISCOUNT_PERCENT) : 0;
};

/**
 * The server-decided Automatic Random Discount for this cart.
 *
 * - Identical carts share a cached answer; any change (add/remove/quantity)
 *   asks the server again, debounced so rapid quantity clicks send one request.
 * - `isLoading` is true while the percent for the CURRENT cart is not yet known
 *   (debounce pending or request in flight); `percent` then holds the previous
 *   cart's value, so show it dimmed and never use it to charge. Checkout blocks
 *   submitting while `isLoading`.
 * - Empty cart: 0, no request. RPC error (e.g. migration not applied): 0 and
 *   `isError`, so the UI shows no discount instead of breaking; the order edge
 *   functions stay authoritative and answer a stale total with HTTP 409 (then
 *   invalidate CART_DISCOUNT_QUERY_KEY).
 */
export const useCartDiscount = (
  cart: ReadonlyArray<CartLine>,
): { percent: number; isLoading: boolean; isError: boolean } => {
  const liveKey = cartDiscountKey(cart);
  const [debouncedKey, setDebouncedKey] = useState(liveKey);

  useEffect(() => {
    if (liveKey === debouncedKey) return;
    if (liveKey === '') {
      setDebouncedKey('');
      return;
    }
    const timer = setTimeout(() => setDebouncedKey(liveKey), DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [liveKey, debouncedKey]);

  const { data, isFetching, isError, isPlaceholderData } = useQuery({
    queryKey: [...CART_DISCOUNT_QUERY_KEY, debouncedKey],
    queryFn: () => fetchCartDiscount(debouncedKey),
    enabled: debouncedKey !== '',
    staleTime: 10 * 60 * 1000,
    retry: 1,
    placeholderData: keepPreviousData,
  });

  if (liveKey === '') return { percent: 0, isLoading: false, isError: false };

  const settled = liveKey === debouncedKey && !isFetching && !isPlaceholderData;
  if (isError && liveKey === debouncedKey) return { percent: 0, isLoading: false, isError: true };
  return { percent: data ?? 0, isLoading: !settled, isError: false };
};
