import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ShoppingCart, Heart, Loader2, Star, ShieldCheck, ChevronLeft } from 'lucide-react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { useCart } from '@/contexts/CartContext';
import { useWishlist } from '@/contexts/WishlistContext';
import { cn } from '@/lib/utils';

const pipeImage = "dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg";

const plumbingProductsData: { [key: string]: any } = {
  'pipe-sch80': {
    id: 'pipe-sch80',
    name: 'PIPE SCH-80 (3 MTR./5MTR.)',
    description: 'High-pressure CPVC pipe for water supply systems. Made from high-quality CPVC material, these pipes are designed to withstand high pressure and temperature conditions. Ideal for industrial applications, water distribution systems, and high-pressure plumbing installations.',
    price: 1200,
    image: pipeImage,
    images: [pipeImage],
    category: 'Plumbing',
    subcategory: 'CPVC Pipes',
    stock: 100,
    specs: {
      'Material': 'CPVC',
      'Length': '3 MTR./5MTR.',
      'Pressure Rating': 'High Pressure',
      'Usage': 'Industrial, Water Distribution',
      'Standard': 'ASTM F441'
    },
    sizes: [
      { inches: '2.50"', mm: '65', qty: 8, price: 1200 },
      { inches: '3"', mm: '80', qty: 5, price: 1500 },
      { inches: '4"', mm: '100', qty: 4, price: 2200 },
    ]
  },
  'pipe-sch40': {
    id: 'pipe-sch40',
    name: 'PIPE SCH-40 (3 MTR./5MTR.)',
    description: 'Standard CPVC pipe for residential and commercial use. These pipes offer excellent chemical resistance and durability for various plumbing applications. Perfect for water supply lines, drainage systems, and general plumbing installations.',
    price: 950,
    image: pipeImage,
    images: [pipeImage],
    category: 'Plumbing',
    subcategory: 'CPVC Pipes',
    stock: 150,
    specs: {
      'Material': 'CPVC',
      'Length': '3 MTR./5MTR.',
      'Pressure Rating': 'Standard',
      'Usage': 'Residential, Commercial',
      'Standard': 'ASTM F441'
    },
    sizes: [
      { inches: '2.50"', mm: '65', qty: 8, price: 950 },
      { inches: '3"', mm: '80', qty: 5, price: 1200 },
      { inches: '4"', mm: '100', qty: 4, price: 1800 },
    ]
  },
  'pipe-sdr11': {
    id: 'pipe-sdr11',
    name: 'PIPE SDR-11 (3 MTR./5MTR.)',
    description: 'Light-duty CPVC pipe for low-pressure applications. Designed for residential water supply systems and irrigation applications. Easy to install and provides reliable performance for everyday plumbing needs.',
    price: 700,
    image: pipeImage,
    images: [pipeImage],
    category: 'Plumbing',
    subcategory: 'CPVC Pipes',
    stock: 200,
    specs: {
      'Material': 'CPVC',
      'Length': '3 MTR./5MTR.',
      'Pressure Rating': 'Low Pressure',
      'Usage': 'Residential, Irrigation',
      'Standard': 'ASTM F442'
    },
    sizes: [
      { inches: '1/2"', mm: '15', qty: 50, price: 700 },
      { inches: '3/4"', mm: '20', qty: 50, price: 850 },
      { inches: '1"', mm: '25', qty: 40, price: 1100 },
      { inches: '1.25"', mm: '32', qty: 25, price: 1400 },
      { inches: '1.50"', mm: '40', qty: 10, price: 1700 },
      { inches: '2"', mm: '50', qty: 10, price: 2100 },
    ]
  },
  'pipe-sdr135': {
    id: 'pipe-sdr135',
    name: 'PIPE SDR-13.5 (3 MTR./5MTR.)',
    description: 'Heavy-duty CPVC pipe for industrial applications. Engineered for maximum durability and pressure resistance. Suitable for chemical processing plants, industrial water systems, and high-demand commercial applications.',
    price: 1500,
    image: pipeImage,
    images: [pipeImage],
    category: 'Plumbing',
    subcategory: 'CPVC Pipes',
    stock: 50,
    specs: {
      'Material': 'CPVC',
      'Length': '3 MTR./5MTR.',
      'Pressure Rating': 'Heavy Duty',
      'Usage': 'Industrial, Chemical Processing',
      'Standard': 'ASTM F442'
    },
    sizes: [
      { inches: '1/2"', mm: '15', qty: 50, price: 1500 },
      { inches: '3/4"', mm: '20', qty: 50, price: 1750 },
      { inches: '1"', mm: '25', qty: 40, price: 2100 },
      { inches: '1.25"', mm: '32', qty: 25, price: 2500 },
      { inches: '1.50"', mm: '40', qty: 10, price: 2900 },
      { inches: '2"', mm: '50', qty: 10, price: 3400 },
    ]
  }
};

const PlumbingProductDetail = () => {
  const { id } = useParams<{ id: string }>();
  const product = id ? plumbingProductsData[id] : null;
  const [selectedSize, setSelectedSize] = useState(0);
  const [quantity, setQuantity] = useState(1);
  const [selectedImage, setSelectedImage] = useState(0);
  
  const { addToCart } = useCart();
  const { isInWishlist, toggleWishlist } = useWishlist();

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [id]);

  if (!product) {
    return (
      <div className="min-h-screen bg-white flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center">
          <h2 className="text-2xl font-playfair">Product not found</h2>
        </div>
        <Footer />
      </div>
    );
  }

  const currentSize = product.sizes[selectedSize];
  const currentPrice = currentSize.price;

  const handleAddToCart = () => {
    addToCart({ 
      id: `${product.id}-${currentSize.inches}`, 
      name: `${product.name} - ${currentSize.inches} (${currentSize.mm}mm)`, 
      price: currentPrice, 
      image: product.image 
    }, quantity);
  };

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-8 md:py-12 px-4">
        <div className="max-w-6xl mx-auto">
          {/* Breadcrumb */}
          <Link to="/plumbing" className="flex items-center text-gray-500 hover:text-primary mb-6 text-sm">
            <ChevronLeft className="h-4 w-4 mr-1" />
            Back to Plumbing Products
          </Link>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 md:gap-12">
            
            {/* Image Gallery */}
            <div className="space-y-4">
              <div className="aspect-square md:aspect-auto md:h-[500px] w-full rounded-2xl overflow-hidden border border-gray-100 shadow-sm bg-gray-50">
                <img src={product.images[selectedImage]} alt={product.name} className="w-full h-full object-contain" />
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
                  <Heart className={cn('h-5 w-5 md:h-6 md:w-6', isInWishlist(product.id) ? 'text-red-500 fill-red-500' : 'text-gray-400')} />
                </Button>
              </div>

              <p className="text-gray-500 mb-2 text-sm">Category: {product.subcategory}</p>
              
              <p className="text-primary font-bold text-3xl md:text-4xl mb-6">₹{currentPrice.toLocaleString()}</p>
              
              <p className="text-gray-600 mb-6 font-poppins text-sm md:text-base whitespace-pre-wrap">
                {product.description}
              </p>

              {/* Size Selector */}
              <div className="mb-6 bg-gray-50 p-4 rounded-xl">
                <h3 className="font-semibold text-gray-900 mb-3 flex items-center">
                  Size & Packaging
                  <span className="ml-2 text-xs font-normal text-gray-500">(Select size for pricing)</span>
                </h3>
                <div className="overflow-x-auto">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="text-xs text-gray-500 uppercase border-b border-gray-200">
                        <th className="px-3 py-2 text-left">Select</th>
                        <th className="px-3 py-2 text-left">Inches</th>
                        <th className="px-3 py-2 text-left">mm</th>
                        <th className="px-3 py-2 text-left">Pack Qty</th>
                        <th className="px-3 py-2 text-right">Price</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {product.sizes.map((size: any, idx: number) => (
                        <tr 
                          key={idx} 
                          onClick={() => setSelectedSize(idx)}
                          className={cn(
                            "cursor-pointer transition-colors",
                            selectedSize === idx ? "bg-primary/5" : "hover:bg-gray-100"
                          )}
                        >
                          <td className="px-3 py-3">
                            <input
                              type="radio"
                              name="size"
                              checked={selectedSize === idx}
                              onChange={() => setSelectedSize(idx)}
                              className="h-4 w-4 text-primary focus:ring-primary"
                            />
                          </td>
                          <td className="px-3 py-3 font-medium text-gray-900">{size.inches}</td>
                          <td className="px-3 py-3 text-gray-700">{size.mm}</td>
                          <td className="px-3 py-3 text-gray-700">{size.qty}</td>
                          <td className="px-3 py-3 text-right font-bold text-primary">₹{size.price.toLocaleString()}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Quick Specs */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4 mb-6 bg-gray-50 p-4 rounded-xl">
                {Object.entries(product.specs).map(([key, value]: [string, any]) => (
                  <div key={key} className="text-sm flex flex-col border-b sm:border-0 border-gray-200 pb-2 sm:pb-0 last:border-0 last:pb-0">
                    <span className="font-semibold text-gray-700">{key}</span> 
                    <span className="text-gray-600 mt-0.5">{value}</span>
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
                  onChange={(e) => setQuantity(Math.max(1, Number(e.target.value)))}
                  className="w-24 p-2 border border-gray-300 rounded-lg text-center focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all"
                />
                <span className="text-sm text-gray-500">{product.stock} in stock</span>
              </div>
              
              <div className="flex flex-col sm:flex-row gap-3 mb-4">
                <Button onClick={handleAddToCart} className="flex-1 rounded-full bg-primary hover:bg-primary/90 text-primary-foreground text-base md:text-lg py-6 sm:py-4 shadow-md">
                  <ShoppingCart className="mr-2 h-5 w-5" />
                  Add to Cart
                </Button>
                <Button variant="outline" className="flex-1 rounded-full text-base md:text-lg py-6 sm:py-4 border-2">
                  Request Quote
                </Button>
              </div>

              {/* Trust Badges */}
              <div className="flex items-start gap-3 bg-green-50/50 border border-green-100 p-4 rounded-xl mt-4">
                <ShieldCheck className="h-5 w-5 text-green-600 flex-shrink-0 mt-0.5" />
                <p className="text-sm text-gray-700">
                  <span className="font-semibold text-gray-900">Quality Assured:</span> All CPVC pipes meet industry standards with manufacturer warranty.
                </p>
              </div>
            </div>
          </div>

          {/* Tabs Section */}
          <div className="max-w-6xl mx-auto mt-12">
            <Tabs defaultValue="description" className="w-full">
              <TabsList className="flex w-full overflow-x-auto h-auto gap-2 bg-transparent justify-start pb-2">
                <TabsTrigger value="description" className="flex-shrink-0 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full py-2 px-5 border border-gray-200 data-[state=active]:border-primary text-sm">Description</TabsTrigger>
                <TabsTrigger value="specifications" className="flex-shrink-0 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full py-2 px-5 border border-gray-200 data-[state=active]:border-primary text-sm">Specifications</TabsTrigger>
                <TabsTrigger value="sizes" className="flex-shrink-0 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full py-2 px-5 border border-gray-200 data-[state=active]:border-primary text-sm">Size Chart</TabsTrigger>
              </TabsList>
              <div className="bg-white border border-gray-100 rounded-2xl p-4 sm:p-6 mt-4 shadow-sm">
                <TabsContent value="description" className="mt-0">
                  <h3 className="text-xl font-semibold text-gray-900 mb-3">Product Overview</h3>
                  <p className="text-gray-700 font-poppins leading-relaxed text-sm sm:text-base mb-4">{product.description}</p>
                  
                  <h4 className="text-lg font-semibold text-gray-900 mb-2 mt-6">Key Features</h4>
                  <ul className="list-disc pl-5 space-y-1 text-gray-700 text-sm sm:text-base">
                    <li>High-quality CPVC material construction</li>
                    <li>Excellent chemical and corrosion resistance</li>
                    <li>Suitable for hot and cold water applications</li>
                    <li>Long service life with minimal maintenance</li>
                    <li>Easy installation with standard fittings</li>
                    <li>Available in multiple sizes for various applications</li>
                  </ul>
                </TabsContent>
                <TabsContent value="specifications" className="mt-0">
                  <ul className="space-y-3">
                    {Object.entries(product.specs).map(([key, value]: [string, any]) => (
                      <li key={key} className="flex flex-col sm:flex-row sm:justify-between text-sm border-b border-gray-100 pb-3 last:border-0 last:pb-0 gap-1">
                        <span className="font-medium text-gray-700">{key}</span>
                        <span className="text-gray-600 sm:text-right">{value}</span>
                      </li>
                    ))}
                    <li className="flex flex-col sm:flex-row sm:justify-between text-sm border-b border-gray-100 pb-3 last:border-0 last:pb-0 gap-1">
                      <span className="font-medium text-gray-700">Stock Status</span>
                      <span className="text-green-600 sm:text-right">In Stock</span>
                    </li>
                  </ul>
                </TabsContent>
                <TabsContent value="sizes" className="mt-0">
                  <h3 className="text-lg font-semibold text-gray-900 mb-4">Available Sizes & Packaging</h3>
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm border-collapse">
                      <thead>
                        <tr className="bg-gray-100 text-gray-700">
                          <th className="px-4 py-3 text-left border border-gray-200">Inches</th>
                          <th className="px-4 py-3 text-left border border-gray-200">mm</th>
                          <th className="px-4 py-3 text-left border border-gray-200">Standard Packaging Quantity</th>
                          <th className="px-4 py-3 text-right border border-gray-200">Price (₹)</th>
                        </tr>
                      </thead>
                      <tbody>
                        {product.sizes.map((size: any, idx: number) => (
                          <tr key={idx} className="hover:bg-gray-50">
                            <td className="px-4 py-3 border border-gray-200 font-medium">{size.inches}</td>
                            <td className="px-4 py-3 border border-gray-200">{size.mm}</td>
                            <td className="px-4 py-3 border border-gray-200">{size.qty}</td>
                            <td className="px-4 py-3 border border-gray-200 text-right font-bold text-primary">₹{size.price.toLocaleString()}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </TabsContent>
              </div>
            </Tabs>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default PlumbingProductDetail;