import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const PrivacyPolicy = () => {
  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 py-20 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-playfair font-bold text-gray-900 mb-8">Privacy Policy</h1>
          
          <div className="space-y-8 text-gray-700 leading-relaxed">
            <p>Last updated: {new Date().toLocaleDateString()}</p>
            
            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">1. Information We Collect</h2>
              <p>We collect information that you provide directly to us. For example, we collect information when you create an account, place an order, subscribe to our newsletter, or communicate with us. The types of information we may collect include your name, email address, postal address, phone number, and payment information.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">2. How We Use Your Information</h2>
              <p className="mb-4">We use the information we collect to:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Process your transactions and send you related information, including order confirmations and receipts.</li>
                <li>Send you technical notices, updates, security alerts, and support messages.</li>
                <li>Respond to your comments, questions, and customer service requests.</li>
                <li>Communicate with you about products, services, offers, and events offered by Katta Interiors.</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">3. Sharing of Information</h2>
              <p>We do not share or sell your personal information to third parties for their marketing purposes. We may share your information with third-party vendors, consultants, and other service providers who need access to such information to carry out work on our behalf (such as payment processors and shipping companies).</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">4. Security</h2>
              <p>We take reasonable measures to help protect information about you from loss, theft, misuse, and unauthorized access, disclosure, alteration, and destruction.</p>
            </section>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default PrivacyPolicy;