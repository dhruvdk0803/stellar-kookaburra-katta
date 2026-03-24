import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const TermsOfService = () => {
  return (
    <div className="min-h-screen bg-white font-poppins flex flex-col">
      <Navigation />
      <div className="flex-1 py-20 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-playfair font-bold text-gray-900 mb-8">Terms of Service</h1>
          
          <div className="space-y-8 text-gray-700 leading-relaxed">
            <p>Last updated: {new Date().toLocaleDateString()}</p>
            
            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">1. Agreement to Terms</h2>
              <p>By accessing or using our website, you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this site.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">2. Use License</h2>
              <p>Permission is granted to temporarily download one copy of the materials (information or software) on Katta Interiors' website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">3. Product Descriptions</h2>
              <p>We attempt to be as accurate as possible. However, Katta Interiors does not warrant that product descriptions, colors, textures, or other content of this site is accurate, complete, reliable, current, or error-free. Colors and textures may appear differently on different monitors.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">4. Pricing and Availability</h2>
              <p>All prices are subject to change without notice. We reserve the right to modify or discontinue any product at any time. We shall not be liable to you or to any third-party for any modification, price change, suspension, or discontinuance of a product.</p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">5. Limitation of Liability</h2>
              <p>In no event shall Katta Interiors or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Katta Interiors' website.</p>
            </section>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default TermsOfService;