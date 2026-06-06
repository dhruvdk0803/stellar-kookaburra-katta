import React from 'react';
import { useParams, Link } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { ShoppingCart, ArrowLeft, ShieldCheck } from 'lucide-react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { cn } from '@/lib/utils';
import { Input } from '@/components/ui/input';
import { useCart } from '@/contexts/CartContext';
import { useWishlist } from '@/contexts/WishlistContext';

const pipeImage = "dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg";

const plumbingProducts = [
  {
    id: 'pipe-sch80',
    name: 'PIPE SCH-80 (3 MTR./5MTR.)',
    description: 'High-pressure CPVC pipe for water supply systems. Made from high-quality CPVC material, these pipes are designed to withstand high pressure and temperature conditions. Ideal for industrial applications, water distribution systems, and high-pressure plumbing installations.',
    price: 1200,
    image: pipeImage,
    category: 'Plumbing',
    stock: 100,
    specs: {
      Thickness: '1.5 mm',
      Material: 'CPVC',
      Length: '3 m / 5 m',
      Pressure: 'Up to 10 bar',
    },
  },
  {
    id: 'pipe-sch40',
    name: 'PIPE SCH-40 (3 MTR./5MTR.)',
    description: 'Standard CPVC pipe for residential and commercial use. These pipes offer excellent chemical resistance and durability for various plumbing applications. Perfect for water supply lines, drainage systems, and general plumbing installations.',
    price: 950,
    image: pipeImage,
    category: 'Plumbing',
    stock: 150,
    specs: {
      Thickness: '1.2 mm',
      Material: 'CPVC',
      Length: '3 m / 5 m',
      Pressure: 'Up to 8 bar',
    },
  },
  {
    id: 'pipe-sdr11',
    name: 'PIPE SDR-11 (3 MTR./5MTR.)',
    description: 'Light-duty CPVC pipe for low-pressure applications. Designed for residential water supply systems and irrigation applications. Easy to install and provides reliable performance for everyday plumbing needs.',
    price: 700,
    image: pipeImage,
    category: 'Plumbing',
    stock: 200,
    specs: {
      Thickness: '0.9 mm',
      Material: 'CPVC',
      Length: '3 m / 5 m',
      Pressure: 'Up to 5 bar',
    },
  },
  {
    id: 'pipe-sdr135',
    name: 'PIPE SDR-13.5 (3 MTR./5MTR.)',
    description: 'Heavy-duty CPVC pipe for industrial applications. Engineered for maximum durability and pressure resistance. Suitable for chemical processing plants, industrial water systems, and high-demand commercial applications.',
    price: 1500,
    image: pipeImage,
    category: 'Plumbing',
    stock: 50,
    specs: {
      Thickness: '2.0 mm',
      Material: 'CPVC',
      Length: '3 m / 5 m',
      Pressure: 'Up to 12 bar',
    },
  },
];

const PlumbingProductDetail = () => {
  const { id } = useParams<{ id: string }>();
  const product = plumbingProducts.find((p) => p.id === id);
  const { addToCart } = useCart();
  const { isInWishlist, toggleWishlist } = useWishlist();

  const [quantity, setQuantity] = React.useState(1);

  if (!product) {
    return (
      <div className="<div className="min-h-screen bg-white font-poppins flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center py-20 px-4">
          <div className="text-center">
            <h2 className="text-2xl font-playfair font-bold mb-4">Product not found</h2>
            <Link to="/plumbing" className="text-teal-600 hover:underline">Back to Plumbing</Link>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  const handleAddToCart = () => {
    addToCart({ id: product.id, name: product.name, price: product.price, image: product.image }, quantity);
  };

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-8 md:py-12 px-4">
        <div className="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-8 md:gap-12">
          
          {/* Image Gallery */}
          <div className="space-y-4">
            <div className="aspect-square md:aspect-auto md:h-[500px] w-full rounded-2xl overflow-hidden border border-gray-100 shadow-sm bg-gray-50">
              <img src={product.image} alt={product.name} className="w-full h-full object-contain" />
            </div>
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
                <svg className={cn('h-5 w-5 md:h-6 md:w-6', isInWishlist(product.id) ? 'text-red-500 fill-red-500' : 'text-gray-400')} viewBox="0 0 24 24" fill="currentColor"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
              </Button>
            </div>
            
            <p className="text-primary font-bold text-3xl md:text-4xl mb-6">₹{product.price}</p>
            
            <p className="text-gray-600 mb-6 font-poppins text-sm md:text-base whitespace-pre-wrap line-clamp-6">
              {product.description}
            </p>

            {/* Quick Specs */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4 mb-6 bg-gray-50 p-4 rounded-xl">
              {Object.entries(product.specs).map(([key, value]) => (
                <div key={key} className="text-sm flex flex-col border-b sm:border-0 border-gray-200 pb-2 sm:pb-0 last:border-0 last:pb-0">
                  <span className="font-semibold text-gray-700">{key}</span> 
                  <span className="text-gray-600 mt-0.5">{value as string}</span>
                </div>
              ))}
            </div>

            <div className="flex items-center space-x-4 mb-6">
              <label className="text-sm font-medium text-gray-700">Quantity:</label>
              <input
                type="number"
                min="1"
                max={product.stock}
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
              <Button variant="outline" className="flex-1 rounded-full text-base md:text-lg py-6 sm:py-4 border-2">
                Order Bulk
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
      </div>
      <Footer />
    </div>
  );
};

export default PlumbingProductDetail;