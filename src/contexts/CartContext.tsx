import React, { createContext, useContext, useReducer, useEffect, useCallback } from 'react';
import { MAX_CART_DISCOUNT_PERCENT, MIN_CART_DISCOUNT_PERCENT } from '@/lib/constants';

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
  image: string;
}

type CartState = CartItem[];

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
        quantity,
        image: typeof item.image === 'string' && item.image ? item.image : '/placeholder.svg',
      }];
    });
  } catch {
    return [];
  }
};

const loadSavedDiscount = () => {
  try {
    const saved = Number(localStorage.getItem('katta-cart-discount'));
    return Number.isInteger(saved) && saved >= MIN_CART_DISCOUNT_PERCENT && saved <= MAX_CART_DISCOUNT_PERCENT
      ? saved
      : nextDiscountPercent(0);
  } catch {
    return nextDiscountPercent(0);
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
      const existingItem = state.find(item => item.id === action.item.id);
      if (existingItem) {
        return state.map(item =>
          item.id === action.item.id
            ? { ...item, quantity: item.quantity + (action.quantity || 1) }
            : item
        );
      }
      return [...state, { ...action.item, quantity: action.quantity || 1 }];
    }
    case 'REMOVE_FROM_CART':
      return state.filter(item => item.id !== action.id);
    case 'UPDATE_QUANTITY':
      return state.map(item =>
        item.id === action.id ? { ...item, quantity: action.quantity } : item
      ).filter(item => item.quantity > 0);
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
  discountPercent: number;
} | null>(null);

const nextDiscountPercent = (current: number) => {
  const choices = Array.from(
    { length: MAX_CART_DISCOUNT_PERCENT - MIN_CART_DISCOUNT_PERCENT + 1 },
    (_, index) => MIN_CART_DISCOUNT_PERCENT + index,
  ).filter((percent) => percent !== current);
  return choices[Math.floor(Math.random() * choices.length)];
};

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within CartProvider');
  }
  return context;
};

export const CartProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [cart, dispatch] = useReducer(cartReducer, [], loadSavedCart);
  const [discountPercent, setDiscountPercent] = React.useState(loadSavedDiscount);

  useEffect(() => {
    try { localStorage.setItem('katta-cart', JSON.stringify(cart)); } catch { /* Storage can be unavailable in private browsing. */ }
  }, [cart]);

  useEffect(() => {
    try { localStorage.setItem('katta-cart-discount', String(discountPercent)); } catch { /* Storage can be unavailable in private browsing. */ }
  }, [discountPercent]);

  const addToCart = useCallback((item: Omit<CartItem, 'quantity'>, quantity = 1) => {
    if (cart.length === 0) setDiscountPercent((current) => nextDiscountPercent(current));
    dispatch({ type: 'ADD_TO_CART', item, quantity });
  }, [cart.length]);

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
    <CartContext.Provider value={{ cart, addToCart, removeFromCart, updateQuantity, clearCart, cartCount, discountPercent }}>
      {children}
    </CartContext.Provider>
  );
};
