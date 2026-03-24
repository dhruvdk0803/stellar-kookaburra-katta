import { Link } from 'react-router-dom';
import { Button } from './ui/button';
import { ShoppingCart, Heart } from 'lucide-react';
import { useCart } from '@/contexts/CartContext';
import { cn } from '@/lib/utils';

interface ProductCardProps {
  product: any;
  isInWishlist: boolean;
  onWishlistToggle: (id: string) => void;
}

const ProductCard = ({ product, isInWishlist, onWishlistToggle }: ProductCardProps) => {
  const { cart, addToCart, updateQuantity, removeFromCart } = useCart();

  // Use the first image from the array, fallback to legacy image_url, then placeholder
  const imageUrl = (product.images && product.images.length > 0) 
    ? product.images[0] 
    : (product.image_url || product.image || 'https://via.placeholder.com/400x400.png?text=No+Image');
    
  const categoryName = product.categories?.name || product.subcategory || 'Uncategorized';

  // Check if product is already in cart
  const cartItem = cart.find(item => item.id === product.id);

  const handleAddToCart = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
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

  return (
    <div className="group relative bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100 flex flex-col h-full">
      <Link to={`/product/${product.id}`} className="block relative overflow-hidden">
        <img src={imageUrl} alt={product.name} className="w-full h-56 sm:h-64 object-cover group-hover:scale-105 transition-transform duration-500" />
        <div className="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors duration-300" />
      </Link>
      <Button
        size="icon"
        variant="ghost"
        onClick={handleWishlistClick}
        className="absolute top-3 right-3 bg-white/80 backdrop-blur-sm hover:bg-white rounded-full h-9 w-9 z-10 shadow-sm"
      >
        <Heart className={cn('h-5 w-5 transition-all', isInWishlist ? 'text-red-500 fill-red-500' : 'text-gray-500')} />
      </Button>
      <div className="p-4 flex flex-col flex-grow">
        <div className="flex-grow">
          <h3 className="text-lg font-semibold text-gray-800 line-clamp-2 leading-tight mb-1">{product.name}</h3>
          <p className="text-sm text-gray-500">{categoryName}</p>
        </div>
        <div className="mt-4 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 sm:gap-0 pt-3 border-t border-gray-50">
          <span className="text-xl font-bold text-primary">₹{product.price}</span>
          
          {cartItem ? (
            <div className="flex items-center space-x-1 bg-gray-100 rounded-full p-1 w-full sm:w-auto justify-between sm:justify-start">
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 rounded-full bg-white shadow-sm hover:bg-gray-50 text-gray-700"
                onClick={(e) => handleUpdateQuantity(e, cartItem.quantity - 1)}
              >
                -
              </Button>
              <span className="w-8 text-center font-semibold text-sm">{cartItem.quantity}</span>
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 rounded-full bg-white shadow-sm hover:bg-gray-50 text-gray-700"
                onClick={(e) => handleUpdateQuantity(e, cartItem.quantity + 1)}
              >
                +
              </Button>
            </div>
          ) : (
            <Button onClick={handleAddToCart} size="sm" className="rounded-full w-full sm:w-auto bg-primary/10 text-primary hover:bg-primary hover:text-white transition-colors">
              <ShoppingCart className="h-4 w-4 mr-2" />
              Add
            </Button>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProductCard;