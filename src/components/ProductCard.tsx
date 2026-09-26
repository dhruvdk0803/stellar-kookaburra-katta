import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Button } from './ui/button';
import { ShoppingCart, Heart, Share2, Check } from 'lucide-react';
import { useCart } from '@/contexts/CartContext';
import { shareProduct } from '@/lib/share';
import { cn } from '@/lib/utils';
import { stripKnownBrandPrefix } from '@/lib/catalog';
import { formatRupees } from '@/lib/money';
import { getProductPrimaryImage } from '@/lib/productImages';

interface ProductCardProps {
  product: any;
  isInWishlist: boolean;
  onWishlistToggle: (id: string) => void;
}

const ProductCard = ({ product, isInWishlist, onWishlistToggle }: ProductCardProps) => {
  const { cart, addToCart, updateQuantity, removeFromCart } = useCart();
  const navigate = useNavigate();
  const [shared, setShared] = useState(false);

  const imageUrl = getProductPrimaryImage(product);
    
  const categoryName = product.categories?.name || product.subcategory || 'Uncategorized';
  const brandName = product.brands?.name || product.brand?.name;
  const displayName = brandName ? stripKnownBrandPrefix(product.name, [{ name: brandName }]) : product.name;

  // Check if product is already in cart
  const cartItem = cart.find(item => item.id === product.id);
  const hasVariants = Array.isArray(product.variants) && product.variants.length > 0;

  const handleAddToCart = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (hasVariants) {
      navigate(`/product/${product.id}`);
      return;
    }
    addToCart({ 
      id: product.id, 
      name: product.name, 
      price: product.price, 
      image: imageUrl 
    });
  };

  const handleUpdateQuantity = (e: React.MouseEvent, newQuantity: number) => {
    e.preventDefault();
    e.stopPropagation();
    if (newQuantity === 0) {
      removeFromCart(product.id);
    } else {
      updateQuantity(product.id, newQuantity);
    }
  };

  const handleWishlistClick = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    onWishlistToggle(product.id);
  };

  const handleShare = async (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    const result = await shareProduct(product.name, `${window.location.origin}/product/${product.id}`);
    if (result === 'copied') {
      setShared(true);
      setTimeout(() => setShared(false), 1500);
    }
  };

  return (
    <div className="group relative bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100 flex flex-col h-full">
      <Link to={`/product/${product.id}`} className="block relative overflow-hidden">
        <img src={imageUrl} alt={product.name} loading="lazy" className="w-full h-56 sm:h-64 object-contain bg-gray-50 p-2 group-hover:scale-105 transition-transform duration-500" />
        <div className="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors duration-300" />
      </Link>
      <Button
        size="icon"
        variant="ghost"
        onClick={handleShare}
        aria-label="Share product"
        className="absolute top-3 right-14 bg-white/80 backdrop-blur-sm hover:bg-white rounded-full h-9 w-9 z-10 shadow-sm"
      >
        {shared ? <Check className="h-5 w-5 text-green-600" /> : <Share2 className="h-5 w-5 text-gray-500" />}
      </Button>
      <Button
        size="icon"
        variant="ghost"
        onClick={handleWishlistClick}
        aria-label={isInWishlist ? 'Remove from wishlist' : 'Add to wishlist'}
        className="absolute top-3 right-3 bg-white/80 backdrop-blur-sm hover:bg-white rounded-full h-9 w-9 z-10 shadow-sm"
      >
        <Heart className={cn('h-5 w-5 transition-all', isInWishlist ? 'text-red-500 fill-red-500' : 'text-gray-500')} />
      </Button>
      <div className="p-4 flex flex-col flex-grow">
        <div className="flex-grow">
          {brandName && displayName !== brandName && <p className="mb-1 text-[11px] font-bold uppercase tracking-[0.16em] text-primary/65">{brandName}</p>}
          <h3 className="text-lg font-semibold text-gray-800 line-clamp-2 leading-tight mb-1">{displayName}</h3>
          <p className="text-sm text-gray-500">{categoryName}</p>
        </div>
        <div className="mt-4 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 sm:gap-0 pt-3 border-t border-gray-50">
          <span className="text-xl font-bold text-primary">₹{formatRupees(product.price)}</span>
          
          {cartItem ? (
            <div className="flex items-center space-x-1 bg-gray-100 rounded-full p-1 w-full sm:w-auto justify-between sm:justify-start">
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 rounded-full bg-white shadow-sm hover:bg-gray-50 text-gray-700"
                aria-label={`Decrease quantity of ${product.name}`}
                onClick={(e) => handleUpdateQuantity(e, cartItem.quantity - 1)}
              >
                -
              </Button>
              <span className="w-8 text-center font-semibold text-sm">{cartItem.quantity}</span>
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 rounded-full bg-white shadow-sm hover:bg-gray-50 text-gray-700"
                aria-label={`Increase quantity of ${product.name}`}
                onClick={(e) => handleUpdateQuantity(e, cartItem.quantity + 1)}
              >
                +
              </Button>
            </div>
          ) : (
            <Button onClick={handleAddToCart} size="sm" className="rounded-full w-full sm:w-auto bg-primary/10 text-primary hover:bg-primary hover:text-white transition-colors">
              {hasVariants ? null : <ShoppingCart className="h-4 w-4 mr-2" />}
              {hasVariants ? 'Choose options' : 'Add'}
            </Button>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProductCard;
