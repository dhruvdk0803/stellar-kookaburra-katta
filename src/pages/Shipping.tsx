import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const Shipping = () => {
  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 py-12 px-4 sm:py-20">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl sm:text-4xl font-playfair font-bold text-gray-900 mb-8">Shipping Policy</h1>
          
          <div className="space-y-8 text-gray-700 leading-relaxed">
            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">1. Order Processing</h2>
              <p>We begin processing orders after confirmation. We will contact you if an item is unavailable or your order needs special delivery arrangements.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">2. Delivery Timeline</h2>
              <p className="mb-4">For available items delivered locally in Jaipur, we try to deliver in under 2 hours. This is an aim, not a guaranteed delivery time. Availability, order size, delivery location, and transport conditions may affect timing.</p>
              <p>We will confirm delivery arrangements for orders outside the local area or for items that need special transport. Shipping charges are displayed at checkout.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">3. Minimum Order Value</h2>
              <p>We accept online orders with a minimum order value of <strong>₹2,000</strong> (excluding shipping charges). Orders below this value cannot be placed through the website — please contact us for smaller requirements.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">4. Bulk and Heavy Items</h2>
              <p>Due to the nature of our products (Sunmica sheets, Louvers, and Panels), bulk orders or oversized items may require special freight shipping. Our team will contact you directly to arrange the best delivery method and confirm any additional freight charges before processing the order.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">5. How do I check the status of my order?</h2>
              <p>Check your order status in your account or contact our team for a delivery update. Tracking details will be shared when available.</p>
            </section>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Shipping;
