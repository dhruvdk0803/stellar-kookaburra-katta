import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
import { ShoppingCart } from 'lucide-react';
import ShopFilters from '@/components/ShopFilters';
import ProductCard from '@/components/ProductCard';

const pipeImage = "dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg";

const plumbingProducts = [
  {
    id: 'pipe-sch80',
    name: 'PIPE SCH-80 (3 MTR./5MTR.)',
    description: 'High-pressure CPVC pipe for water supply systems. Made from high-quality CPVC material, these pipes are designed to withstand high pressure and temperature conditions. Ideal for industrial applications, water distribution systems, and high-pressure plumbing installations.',
    price: 1200,
    image: pipeImage,
    category: 'Plumbing',
    stock: 100
  },
  {
    id: 'pipe-sch40',
    name: 'PIPE SCH-40 (3 MTR./5MTR.)',
    description: 'Standard CPVC pipe for residential and commercial use. These pipes offer excellent chemical resistance and durability for various plumbing applications. Perfect for water supply lines, drainage systems, and general plumbing installations.',
    price: 950,
    image: pipeImage,
    category: 'Plumbing',
    stock: 150
  },
  {
    id: 'pipe-sdr11',
    name: 'PIPE SDR-11 (3 MTR./5MTR.)',
    description: 'Light-duty CPVC pipe for low-pressure applications. Designed for residential water supply systems and irrigation applications. Easy to install and provides reliable performance for everyday plumbing needs.',
    price: 700,
    image: pipeImage,
    category: 'Plumbing',
    stock: 200
  },
  {
    id: 'pipe-sdr135',
    name: 'PIPE SDR-13.5 (3 MTR./5MTR.)',
    description: 'Heavy-duty CPVC pipe for industrial applications. Engineered for maximum durability and pressure resistance. Suitable for chemical processing plants, industrial water systems, and high-demand commercial applications.',
    price: 1500,
    image: pipeImage,
    category: 'Plumbing',
    stock: 50
  }
];

const Plumbing = () => {
  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-16">Plumbing Products</h1>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {plumbingProducts.map((product) => (
              <Link key={product.id} to={`/product/${product.id}`}>
                <div className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all overflow-hidden group">
                  <img 
                    src={product.image} 
                    alt={product.name} 
                    className="w-full h-64 object-cover group-hover:scale-105 transition-transform duration-300" 
                  />
                  <div className="p-6">
                    <h3 className="text-xl font-semibold text-gray-900 mb-2">{product.name}</h3>
                    <p className="text-gray-600 text-sm mb-4 line-clamp-3">{product.description}</p>
                    <div className="flex justify-between items-center">
                      <p className="text-primary font-bold text-lg">₹{product.price}</p>
                      <Button variant="ghost" size="sm" className="rounded-full">
                        <ShoppingCart className="h-4 w-4" />
                        View Details
                      </Button>
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Plumbing;