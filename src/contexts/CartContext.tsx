import React, { createContext, useContext, useReducer, useEffect, useCallback } from 'react';

// Storage key of the retired random "surprise discount" (2026-10-05). Cart
// discounts now come from the server-side discount tiers; any stale value left
// in a returning shopper's browser is removed once on load.
const RETIRED_DISCOUNT_STORAGE_KEY = 'katta-cart-discount';

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
  image: string;
}

type CartState = CartItem[];

// Matches the per-line limit enforced by the razorpay-create-order function.
const MAX_ITEM_QUANTITY = 100;
const normalizeQuantity = (quantity: number) =>
  Number.isFinite(quantity) ? Math.min(MAX_ITEM_QUANTITY, Math.max(0, Math.floor(quantity))) : 0;

const loadSavedCart = (): CartState => {
  try {
    const saved = localStorage.getItem('katta-cart');
    if (!saved) return [];
    const parsed: unknown = JSON.parse(saved);
    if (!Array.isArray(parsed)) return [];

    return parsed.flatMap((entry): CartItem[] => {
      if (!entry || typeof entry !== 'object') return [];
      const item = entry as Partial<CartItem>;
      const price = Number(item.price);
      const quantity = Number(item.quantity);
      if (
        typeof item.id !== 'string' || !item.id ||
        typeof item.name !== 'string' || !item.name ||
        !Number.isFinite(price) || price <= 0 ||
        !Number.isInteger(quantity) || quantity <= 0
      ) return [];

      return [{
        id: item.id,
        name: item.name,
        price,
        quantity: normalizeQuantity(quantity),
        image: typeof item.image === 'string' && item.image ? item.image : '/placeholder.svg',
      }];
    });
  } catch {
    return [];
  }
};

type CartAction =
  | { type: 'ADD_TO_CART'; item: Omit<CartItem, 'quantity'>; quantity?: number }
  | { type: 'REMOVE_FROM_CART'; id: string }
  | { type: 'UPDATE_QUANTITY'; id: string; quantity: number }
  | { type: 'CLEAR_CART' };

const cartReducer = (state: CartState, action: CartAction): CartState => {
  switch (action.type) {
    case 'ADD_TO_CART': {
      // Invalid amounts (0, NaN, negative, fractional from a free-typed input) never
      // reach the cart as-is: they fall back to 1 and are capped at the server limit.
      const addQuantity = normalizeQuantity(action.quantity ?? 1) || 1;
      const existingItem = state.find(item => item.id === action.item.id);
      if (existingItem) {
        return state.map(item =>
          item.id === action.item.id
            ? { ...item, quantity: Math.min(MAX_ITEM_QUANTITY, item.quantity + addQuantity) }
            : item
        );
      }
      return [...state, { ...action.item, quantity: addQuantity }];
    }
    case 'REMOVE_FROM_CART':
      return state.filter(item => item.id !== action.id);
    case 'UPDATE_QUANTITY': {
      const quantity = normalizeQuantity(action.quantity);
      return state.map(item =>
        item.id === action.id ? { ...item, quantity } : item
      ).filter(item => item.quantity > 0);
    }
    case 'CLEAR_CART':
      return [];
    default:
      return state;
  }
};

const CartContext = createContext<{
  cart: CartState;
  addToCart: (item: Omit<CartItem, 'quantity'>, quantity?: number) => void;
  removeFromCart: (id: string) => void;
  updateQuantity: (id: string, quantity: number) => void;
  clearCart: () => void;
  cartCount: number;
} | null>(null);

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within CartProvider');
  }
  return context;
};

export const CartProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [cart, dispatch] = useReducer(cartReducer, [], loadSavedCart);

  useEffect(() => {
    try { localStorage.setItem('katta-cart', JSON.stringify(cart)); } catch { /* Storage can be unavailable in private browsing. */ }
  }, [cart]);

  useEffect(() => {
    try { localStorage.removeItem(RETIRED_DISCOUNT_STORAGE_KEY); } catch { /* Storage can be unavailable in private browsing. */ }
  }, []);

  const addToCart = useCallback((item: Omit<CartItem, 'quantity'>, quantity = 1) => {
    dispatch({ type: 'ADD_TO_CART', item, quantity });
  }, []);

  const removeFromCart = useCallback((id: string) => {
    dispatch({ type: 'REMOVE_FROM_CART', id });
  }, []);

  const updateQuantity = useCallback((id: string, quantity: number) => {
    dispatch({ type: 'UPDATE_QUANTITY', id, quantity });
  }, []);

  const clearCart = useCallback(() => {
    dispatch({ type: 'CLEAR_CART' });
  }, []);

  const cartCount = cart.reduce((sum, item) => sum + item.quantity, 0);

  return (
    <CartContext.Provider value={{ cart, addToCart, removeFromCart, updateQuantity, clearCart, cartCount }}>
      {children}
    </CartContext.Provider>
  );
};
