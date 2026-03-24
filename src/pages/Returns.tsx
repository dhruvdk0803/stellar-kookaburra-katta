import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const Returns = () => {
  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 py-20 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-playfair font-bold text-gray-900 mb-8">Returns & Refunds</h1>
          
          <div className="space-y-8 text-gray-700 leading-relaxed">
            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">1. Return Window</h2>
              <p>We accept returns up to 7 days after delivery, if the item is unused and in its original condition. We will refund the full order amount minus the shipping costs for the return.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">2. Condition of Returned Items</h2>
              <p>To be eligible for a return, your item must be in the same condition that you received it. It must also be in the original packaging. Any sheets or panels that have been cut, glued, or altered in any way cannot be returned.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">3. Damages and Issues</h2>
              <p>Please inspect your order upon reception and contact us immediately if the item is defective, damaged, or if you receive the wrong item, so that we can evaluate the issue and make it right. In the event that your order arrives damaged in any way, please email us as soon as possible at mr.kattas1@gmail.com with your order number and a photo of the item's condition.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">4. Refunds</h2>
              <p>We will notify you once we’ve received and inspected your return, and let you know if the refund was approved or not. If approved, you’ll be automatically refunded on your original payment method within 5-7 business days. Please remember it can take some time for your bank or credit card company to process and post the refund too.</p>
            </section>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Returns;