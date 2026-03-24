import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const Shipping = () => {
  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 py-20 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-playfair font-bold text-gray-900 mb-8">Shipping Policy</h1>
          
          <div className="space-y-8 text-gray-700 leading-relaxed">
            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">1. Order Processing Time</h2>
              <p>All orders are processed within 1 to 3 business days (excluding weekends and holidays) after receiving your order confirmation email. You will receive another notification when your order has shipped.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">2. Domestic Shipping Rates and Estimates</h2>
              <p className="mb-4">Shipping charges for your order will be calculated and displayed at checkout. We offer the following shipping options within India:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li><strong>Standard Shipping:</strong> 5-7 business days. Free for orders over ₹5,000.</li>
                <li><strong>Express Shipping:</strong> 2-3 business days. Additional charges apply.</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">3. Bulk and Heavy Items</h2>
              <p>Due to the nature of our products (Sunmica sheets, Louvers, and Panels), bulk orders or oversized items may require special freight shipping. Our team will contact you directly to arrange the best delivery method and confirm any additional freight charges before processing the order.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">4. How do I check the status of my order?</h2>
              <p>When your order has shipped, you will receive an email notification from us which will include a tracking number you can use to check its status. Please allow 48 hours for the tracking information to become available.</p>
            </section>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Shipping;