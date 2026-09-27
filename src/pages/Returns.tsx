import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const Returns = () => {
  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 py-12 px-4 sm:py-20">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl sm:text-4xl font-playfair font-bold text-gray-900 mb-8">Returns & Refunds</h1>
          
          <div className="space-y-8 text-gray-700 leading-relaxed">
            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">1. Return Window</h2>
              <p>Eligible items can be returned within 2 days of delivery if they are unused, in their original condition, and in their original packaging. Doorskins, wall panels, laminates, and digital locks are excluded from this return policy.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">2. Condition of Returned Items</h2>
              <p>Returned items must be unused and unaltered, with their original packaging. Contact us within the 2-day window to request a return. Return shipping costs are deducted from an approved refund.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">3. Damages and Issues</h2>
              <p className="mb-4">Please inspect your order when it arrives. If any item, including an excluded item, is damaged, defective, or incorrect, contact us immediately so we can evaluate the issue. Email kattainterior@gmail.com with your order number and a photo of the item's condition.</p>
              <p><strong>For wrong and defective products the replacement delivery timeframe will be 7-14 days.</strong></p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">4. Refunds</h2>
              <p className="mb-4">We will notify you once we’ve received and inspected your return, and let you know if the refund was approved or not.</p>
              <p><strong>The refunded amount will be automatically credited to your account within 5-7 business days.</strong> Please remember it can take some time for your bank or credit card company to process and post the refund too.</p>
            </section>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Returns;
