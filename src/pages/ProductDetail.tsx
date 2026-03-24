import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Textarea } from '@/components/ui/textarea';
import { ShoppingCart, Heart, MessageCircle, Loader2, Star, ShieldCheck } from 'lucide-react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import ProductCard from '@/components/ProductCard';
import { useCart } from '@/contexts/CartContext';
import { useWishlist } from '@/contexts/WishlistContext';
import { useAuth } from '@/contexts/AuthContext';
import { cn } from '@/lib/utils';
import { supabase } from '@/integrations/supabase/client';
import { toast } from 'sonner';

const ProductDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const [product, setProduct] = useState<any>(null);
  const [relatedProducts, setRelatedProducts] = useState<any[]>([]);
  const [reviews, setReviews] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [quantity, setQuantity] = useState(1);
  const [selectedImage, setSelectedImage] = useState<string>('');
  
  // Review Form State
  const [newRating, setNewRating] = useState(5);
  const [newComment, setNewComment] = useState('');
  const [isSubmittingReview, setIsSubmittingReview] = useState(false);
  
  const { addToCart } = useCart();
  const { isInWishlist, toggleWishlist } = useWishlist();

  useEffect(() => {
    const fetchProductAndReviews = async () => {
      if (!id) return;
      setLoading(true);
      
      // Fetch Product
      const { data: prodData } = await supabase
        .from('products')
        .select('*, categories(name)')
        .eq('id', id)
        .single();
      
      if (prodData) {
        setProduct(prodData);
        const imgs = (prodData.images && prodData.images.length > 0) ? prodData.images : (prodData.image_url ? [prodData.image_url] : ['https://via.placeholder.com/800x800.png?text=No+Image']);
        setSelectedImage(imgs[0]);
        
        if (prodData.category_id) {
          const { data: related } = await supabase
            .from('products')
            .select('*, categories(name)')
            .eq('category_id', prodData.category_id)
            .neq('id', prodData.id)
            .eq('is_active', true)
            .limit(4);
          if (related) setRelatedProducts(related);
        }
      }

      // Fetch Reviews
      const { data: revData } = await supabase
        .from('reviews')
        .select('*, profiles(name)')
        .eq('product_id', id)
        .order('created_at', { ascending: false });
        
      if (revData) setReviews(revData);

      setLoading(false);
    };
    
    fetchProductAndReviews();
    setQuantity(1);
    window.scrollTo(0, 0);
  }, [id]);

  const handleSubmitReview = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) {
      toast.error("You must be logged in to leave a review.");
      return;
    }
    if (!newComment.trim()) {
      toast.error("Please write a comment.");
      return;
    }

    setIsSubmittingReview(true);
    const { data, error } = await supabase
      .from('reviews')
      .insert([{
        product_id: id,
        user_id: user.id,
        rating: newRating,
        comment: newComment
      }])
      .select('*, profiles(name)')
      .single();

    setIsSubmittingReview(false);

    if (error) {
      toast.error(error.message);
    } else if (data) {
      toast.success("Review submitted successfully!");
      setReviews([data, ...reviews]);
      setNewComment('');
      setNewRating(5);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-white flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="min-h-screen bg-white flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center">
          <h2 className="text-2xl font-playfair">Product not found</h2>
        </div>
      </div>
    );
  }

  const allImages = (product.images && product.images.length > 0) ? product.images : (product.image_url ? [product.image_url] : ['https://via.placeholder.com/800x800.png?text=No+Image']);
  const categoryName = product.categories?.name || product.subcategory || 'Uncategorized';
  
  const specs = product.specs || {
    'Category': categoryName,
    'Stock Status': product.stock > 0 ? 'In Stock' : 'Out of Stock',
    'Material': 'Premium Quality'
  };

  const averageRating = reviews.length > 0 
    ? (reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length).toFixed(1) 
    : 0;

  const handleAddToCart = () => {
    addToCart({ id: product.id, name: product.name, price: product.price, image: allImages[0] }, quantity);
  };

  const handleBulkOrder = () => {
    window.open('mailto:info@kattainteriors.com?subject=Bulk Order Inquiry: ' + product.name, '_blank');
  };

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-8 md:py-12 px-4">
        <div className="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-8 md:gap-12">
          
          {/* Image Gallery */}
          <div className="space-y-4">
            <div className="aspect-square md:aspect-auto md:h-[500px] w-full rounded-2xl overflow-hidden border border-gray-100 shadow-sm bg-gray-50">
              <img src={selectedImage} alt={product.name} className="w-full h-full object-contain" />
            </div>
            {allImages.length > 1 && (
              <div className="flex gap-3 overflow-x-auto pb-2 snap-x">
                {allImages.map((img: string, idx: number) => (
                  <button 
                    key={idx}
                    onClick={() => setSelectedImage(img)}
                    className={cn(
                      "flex-shrink-0 w-20 h-20 rounded-xl overflow-hidden border-2 transition-all snap-start",
                      selectedImage === img ? "border-primary shadow-md" : "border-transparent hover:border-gray-300"
                    )}
                  >
                    <img src={img} alt={`Thumbnail ${idx}`} className="w-full h-full object-cover" />
                  </button>
                ))}
              </div>
            )}
          </div>

          <div>
            <div className="flex justify-between items-start mb-2">
              <h1 className="text-2xl md:text-3xl font-playfair font-bold text-gray-900 pr-4">{product.name}</h1>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => toggleWishlist(product.id)}
                className="rounded-full border-2 border-gray-200 hover:border-primary/50 flex-shrink-0"
              >
                <Heart className={cn('h-5 w-5 md:h-6 md:w-6', isInWishlist(product.id) ? 'text-red-500 fill-red-500' : 'text-gray-400')} />
              </Button>
            </div>
            
            {/* Rating Summary */}
            {reviews.length > 0 && (
              <div className="flex items-center space-x-2 mb-4">
                <div className="flex items-center">
                  {[...Array(5)].map((_, i) => (
                    <Star key={i} className={cn("h-4 w-4", i < Math.round(Number(averageRating)) ? "text-amber-400 fill-amber-400" : "text-gray-300")} />
                  ))}
                </div>
                <span className="text-sm font-medium text-gray-700">{averageRating}</span>
                <span className="text-sm text-gray-500">({reviews.length} reviews)</span>
              </div>
            )}

            <p className="text-primary font-bold text-3xl md:text-4xl mb-6">₹{product.price}</p>
            
            {/* Added whitespace-pre-wrap to support multi-line descriptions */}
            <p className="text-gray-600 mb-6 font-poppins text-sm md:text-base whitespace-pre-wrap line-clamp-6">
              {product.description || 'No description available.'}
            </p>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6 bg-gray-50 p-4 rounded-xl">
              {Object.entries(specs).map(([key, value]) => (
                <div key={key} className="text-sm flex justify-between sm:block border-b sm:border-0 border-gray-200 pb-2 sm:pb-0 last:border-0 last:pb-0">
                  <span className="font-semibold text-gray-700">{key}:</span> <span className="text-gray-600">{value as string}</span>
                </div>
              ))}
            </div>

            <div className="flex items-center space-x-4 mb-6">
              <label className="text-sm font-medium text-gray-700">Quantity:</label>
              <input
                type="number"
                min="1"
                max={product.stock || 100}
                value={quantity}
                onChange={(e) => setQuantity(Number(e.target.value))}
                className="w-24 p-2 border border-gray-300 rounded-lg text-center focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all"
              />
            </div>
            
            <div className="flex flex-col sm:flex-row gap-3 mb-4">
              <Button onClick={handleAddToCart} disabled={product.stock <= 0} className="flex-1 rounded-full bg-primary hover:bg-primary/90 text-primary-foreground text-base md:text-lg py-6 sm:py-4 shadow-md">
                <ShoppingCart className="mr-2 h-5 w-5" />
                {product.stock > 0 ? 'Add to Cart' : 'Out of Stock'}
              </Button>
              <Button variant="outline" onClick={handleBulkOrder} className="flex-1 rounded-full text-base md:text-lg py-6 sm:py-4 border-2">
                Order Bulk
                <MessageCircle className="ml-2 h-5 w-5" />
              </Button>
            </div>

            {/* Return Policy Notice */}
            <div className="flex items-start gap-3 bg-green-50/50 border border-green-100 p-4 rounded-xl mt-4">
              <ShieldCheck className="h-5 w-5 text-green-600 flex-shrink-0 mt-0.5" />
              <p className="text-sm text-gray-700">
                <span className="font-semibold text-gray-900">Return Policy:</span> If a damaged product is received, it can be returned within 2 days of delivery.
              </p>
            </div>
          </div>
        </div>

        <div className="max-w-6xl mx-auto mt-12">
          <Tabs defaultValue="description" className="w-full">
            <TabsList className="grid w-full grid-cols-2 sm:grid-cols-3 h-auto gap-2 bg-transparent">
              <TabsTrigger value="description" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full py-2 border border-gray-200 data-[state=active]:border-primary">Description</TabsTrigger>
              <TabsTrigger value="specs" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full py-2 border border-gray-200 data-[state=active]:border-primary">Specs</TabsTrigger>
              <TabsTrigger value="reviews" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full py-2 border border-gray-200 data-[state=active]:border-primary">Reviews ({reviews.length})</TabsTrigger>
            </TabsList>
            <div className="bg-white border border-gray-100 rounded-2xl p-6 mt-4 shadow-sm">
              <TabsContent value="description" className="mt-0">
                {/* Added whitespace-pre-wrap here as well */}
                <p className="text-gray-700 font-poppins leading-relaxed whitespace-pre-wrap">{product.description}</p>
              </TabsContent>
              <TabsContent value="specs" className="mt-0">
                <ul className="space-y-3">
                  {Object.entries(specs).map(([key, value]) => (
                    <li key={key} className="flex justify-between text-sm border-b border-gray-100 pb-2 last:border-0 last:pb-0">
                      <span className="font-medium text-gray-700">{key}</span>
                      <span className="text-gray-600">{value as string}</span>
                    </li>
                  ))}
                </ul>
              </TabsContent>
              <TabsContent value="reviews" className="mt-0 space-y-8">
                
                {/* Write a Review Form */}
                <div className="bg-gray-50 p-6 rounded-xl border border-gray-100">
                  <h3 className="text-lg font-semibold text-gray-900 mb-4">Write a Review</h3>
                  {user ? (
                    <form onSubmit={handleSubmitReview} className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">Rating</label>
                        <div className="flex space-x-1">
                          {[1, 2, 3, 4, 5].map((star) => (
                            <button
                              key={star}
                              type="button"
                              onClick={() => setNewRating(star)}
                              className="focus:outline-none"
                            >
                              <Star className={cn("h-6 w-6 transition-colors", star <= newRating ? "text-amber-400 fill-amber-400" : "text-gray-300 hover:text-amber-200")} />
                            </button>
                          ))}
                        </div>
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">Your Review</label>
                        <Textarea 
                          placeholder="What did you think about this product?" 
                          value={newComment}
                          onChange={(e) => setNewComment(e.target.value)}
                          rows={4}
                          className="bg-white"
                        />
                      </div>
                      <Button type="submit" disabled={isSubmittingReview} className="rounded-full">
                        {isSubmittingReview ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        Submit Review
                      </Button>
                    </form>
                  ) : (
                    <div className="text-center py-4">
                      <p className="text-gray-600 mb-4">Please log in to leave a review.</p>
                      <Link to="/login">
                        <Button variant="outline" className="rounded-full">Log In</Button>
                      </Link>
                    </div>
                  )}
                </div>

                {/* Reviews List */}
                <div>
                  <h3 className="text-lg font-semibold text-gray-900 mb-6">Customer Reviews</h3>
                  {reviews.length === 0 ? (
                    <p className="text-gray-500 italic">No reviews yet. Be the first to review this product!</p>
                  ) : (
                    <div className="space-y-6">
                      {reviews.map((review) => (
                        <div key={review.id} className="border-b border-gray-100 pb-6 last:border-0 last:pb-0">
                          <div className="flex items-center justify-between mb-2">
                            <div className="flex items-center space-x-3">
                              <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center text-primary font-bold">
                                {(review.profiles?.name || 'U').charAt(0).toUpperCase()}
                              </div>
                              <div>
                                <p className="font-medium text-gray-900">{review.profiles?.name || 'Anonymous User'}</p>
                                <p className="text-xs text-gray-500">{new Date(review.created_at).toLocaleDateString()}</p>
                              </div>
                            </div>
                            <div className="flex">
                              {[...Array(5)].map((_, i) => (
                                <Star key={i} className={cn("h-4 w-4", i < review.rating ? "text-amber-400 fill-amber-400" : "text-gray-200")} />
                              ))}
                            </div>
                          </div>
                          <p className="text-gray-700 mt-3 pl-13">{review.comment}</p>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

              </TabsContent>
            </div>
          </Tabs>
        </div>

        {/* Related Products Section */}
        {relatedProducts.length > 0 && (
          <div className="max-w-6xl mx-auto mt-24">
            <h2 className="text-3xl font-playfair font-bold text-gray-900 mb-8 text-center md:text-left">You Might Also Like</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {relatedProducts.map((rp) => (
                <ProductCard
                  key={rp.id}
                  product={rp}
                  isInWishlist={isInWishlist(rp.id)}
                  onWishlistToggle={toggleWishlist}
                />
              ))}
            </div>
          </div>
        )}
      </div>
      <Footer />
    </div>
  );
};

export default ProductDetail;