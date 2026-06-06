import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
import { ShoppingCart } from 'lucide-react';
import ShopFilters from '@/components/ShopFilters';
import ProductCard from '@/components/ProductCard';

const Plumbing = () => {
  return (
    <div className="min-h-screen bg-gray-50 font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-3xl font-playfair font-bold text-gray-900 mb-16">Plumbing Products</h1>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* CPVC Pipes */}
            <div key="pipe-sch80" className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all">
              <img 
                src="dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg" 
                alt="CPVC Pipe SCH-80" 
                className="w-full h-64 object-cover" 
              />
              <div className="p-4">
                <h3 className="text-xl font-semibold text-gray-900">PIPE SCH-80 (3 MTR./5MTR.)</h3>
                <p className="text-gray-600">High-pressure CPVC pipe for water supply systems.</p>
                <p className="text-primary font-bold">₹1,200</p>
                <Button variant="ghost" size="sm" className="rounded-full">
                  <ShoppingCart className="h-4 w-4" />
                  Add to Cart
                </Button>
              </div>
            </div>

            <div key="pipe-sch40" className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all">
              <img 
                src="dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg" 
                alt="CPVC Pipe SCH-40" 
                className="w-full h-64 object-cover" 
              />
              <div className="p-4">
                <h3 className="text-xl font-semibold text-gray-900">PIPE SCH-40 (3 MTR./5MTR.)</h3>
                <p className="text-gray-600">Standard CPVC pipe for residential and commercial use.</p>
                <p className="text-primary font-bold">₹950</p>
                <Button variant="ghost" size="sm" className="rounded-full">
                  <ShoppingCart className="h-4 w-4" />
                  Add to Cart
                </Button>
              </div>
            </div>

            <div key="pipe-sdr11" className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all">
              <img 
                src="dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg" 
                alt="CPVC Pipe SDR-11" 
                className="w-full h-64 object-cover" 
              />
              <div className="p-4">
                <h3 className="text-xl font-semibold text-gray-900">PIPE SDR-11 (3 MTR./5MTR.)</h3>
                <p className="text-gray-600">Light-duty CPVC pipe for low-pressure applications.</p>
                <p className="text-primary font-bold">₹700</p>
                <Button variant="ghost" size="sm" className="rounded-full">
                  <ShoppingCart className="h-4 w-4" />
                  Add to Cart
                </Button>
              </div>
            </div>

            <div key="pipe-sdr135" className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all">
              <img 
                src="dyad-media://media/stellar-kookaburra-hop/.dyad/media/0f75e9a4369e2217dc5b167061baa7f6ee28a6fc4b855a7ca28e02adc57671b0.jpg" 
                alt="CPVC Pipe SDR-13.5" 
                className="w-full h-64 object-cover" 
              />
              <div className="p-4">
                <h3 className="text-xl font-semibold text-gray-900">PIPE SDR-13.5 (3 MTR./5MTR.)</h3>
                <p className="text-gray-600">Heavy-duty CPVC pipe for industrial applications.</p>
                <p className="text-primary font-bold">₹1,500</p>
                <Button variant="ghost" size="sm" className="rounded-full">
                  <ShoppingCart className="h-4 w-4" />
                  Add to Cart
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Plumbing;