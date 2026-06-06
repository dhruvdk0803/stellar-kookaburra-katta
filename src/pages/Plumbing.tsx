import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import ShopFilters from '@/components/ShopFilters';
import { Link } from 'react-router-dom';

const pipeImage = "dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg";

const plumbingProducts = [
  {
    id: 'pipe-sch80',
    name: 'PIPE SCH-80 (3 MTR./5MTR.)',
    description: 'High-pressure CPVC pipe for water supply systems. Made from high-quality CPVC material, these pipes are designed to withstand high pressure and temperature conditions. Ideal for industrial applications, water distribution systems, and high-pressure plumbing installations.',
    price: 1200,
    image: pipeImage,
  },
  {
    id: 'pipe-sch40',
    name: 'PIPE SCH-40 (3 MTR./5MTR.)',
    description: 'Standard CPVC pipe for residential and commercial use. These pipes offer excellent chemical resistance and durability for various plumbing applications. Perfect for water supply lines, drainage systems, and general plumbing installations.',
    price: 950,
    image: pipeImage,
  },
  {
    id: 'pipe-sdr11',
    name: 'PIPE SDR-11 (3 MTR./5MTR.)',
    description: 'Light-duty CPVC pipe for low-pressure applications. Designed for residential water supply systems and irrigation applications. Easy to install and provides reliable performance for everyday plumbing needs.',
    price: 700,
    image: pipeImage,
  },
  {
    id: 'pipe-sdr135',
    name: 'PIPE SDR-13.5 (3 MTR./5MTR.)',
    description: 'Heavy-duty CPVC pipe for industrial applications. Engineered for maximum durability and pressure resistance. Suitable for chemical processing plants, industrial water systems, and high-demand commercial applications.',
    price: 1500,
    image: pipeImage,
  }
];

const Plumbing = () => {
  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-4 gap-8">
          <aside className="hidden lg:block lg:col-span-1 space-y-6">
            <h2 className="text-2xl font-playfair font-bold text-gray-900">Filters</h2>
            <ShopFilters 
              categories={[{ id: 'plumbing', name: 'Plumbing' }]} 
              onFilterChange={() => {}} 
              initialFilters={{}} 
            />
          </aside>
          
          <main className="lg:col-span-3">
            <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-8">Plumbing Products</h1>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
              {plumbingProducts.map((product) => (
                <Link key={product.id} to={`/plumbing/${product.id}`}>
                  <div className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all overflow-hidden group h-full flex flex-col">
                    <div className="relative overflow-hidden">
                      <img 
                        src={product.image} 
                        alt={product.name} 
                        className="w-full h-56 sm:h-64 object-cover group-hover:scale-105 transition-transform duration-500" 
                      />
                    </div>
                    <div className="p-4 flex flex-col flex-grow">
                      <h3 className="text-lg font-semibold text-gray-800 line-clamp-2 leading-tight mb-1 group-hover:text-primary transition-colors">{product.name}</h3>
                      <p className="text-sm text-gray-500 line-clamp-2 mb-3 flex-grow">{product.description}</p>
                      <div className="mt-auto pt-3 border-t border-gray-50">
                        <span className="text-xl font-bold text-primary">Starting ₹{product.price.toLocaleString()}</span>
                      </div>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </main>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Plumbing;