import React from 'react';
import { useWishlist } from '@/contexts/WishlistContext';
import { products } from '@/data/products';
import ProductCard from '@/components/ProductCard';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Link } from 'react-router-dom';

const Wishlist = () => {
  const { wishlist, toggleWishlist } = useWishlist();
  const wishlistProducts = products.filter(product => wishlist.includes(product.id));

  if (wishlistProducts.length === 0) {
    return (
      <div className="min-h-screen bg-white font-poppins">
        <Navigation />
        <div className="py-20 text-center">
          <h2 className="text-3xl font-playfair font-bold text-gray-900 mb-4">Your Wishlist is Empty</h2>
          <p className="text-gray-600 mb-8">Add items you love to your wishlist.</p>
          <Link to="/shop">
            <button className="px-8 py-4 text-lg font-medium bg-primary hover:bg-primary/90 text-primary-foreground rounded-full shadow-lg">
              Start Shopping
            </button>
          </Link>
        </div>
        <Footer />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-6xl mx-auto">
          <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-8">Wishlist</h1>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {wishlistProducts.map((product) => (
              <ProductCard
                key={product.id}
                product={product}
                isInWishlist={true}
                onWishlistToggle={toggleWishlist}
              />
            ))}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Wishlist;