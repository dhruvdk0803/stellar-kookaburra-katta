import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
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
            {/* Example Plumbing Products (Replace with your data) */}
            <div key="1" className="bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all">
              <img src="/images/plumbing/pipe.jpg" alt="Plumbing Pipe" className="w-full h-64 object-cover" />
              <div className="p-4">
                <h3 className="text-xl font-semibold text-gray-900">Plumbing Pipe</h3>
                <p className="text-gray-600">Durable PVC pipes for water supply systems.</p>
                <p className="text-primary font-bold">₹500</p>
                <Button variant="ghost" size="sm" className="rounded-full">
                  <ShoppingCart className="h-4 w-4" />
                  Add to Cart
                </Button>
              </div>
            </div>
            {/* Add more product cards here */}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Plumbing;