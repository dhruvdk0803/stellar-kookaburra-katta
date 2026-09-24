import React, { useState } from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Send, Phone, MapPin, Mail } from 'lucide-react';

const Contact = () => {
  const [formData, setFormData] = useState({ name: '', email: '', phone: '', message: '' });
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const inquiry = [
      'Hello Katta Interiors, I have a product inquiry.',
      `Name: ${formData.name}`,
      `Email: ${formData.email}`,
      `Phone: ${formData.phone}`,
      `Message: ${formData.message}`,
    ].join('\n');
    window.open(`https://wa.me/918005708058?text=${encodeURIComponent(inquiry)}`, '_blank', 'noopener,noreferrer');
    setSubmitted(true);
  };

  const handleWhatsApp = () => {
    window.open('https://wa.me/918005708058?text=Inquiry from Katta Interiors website', '_blank', 'noopener,noreferrer');
  };

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <section className="py-20 px-4">
        <div className="max-w-4xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-12">
          <div>
            <h1 className="text-4xl font-playfair font-bold text-gray-900 mb-8">Contact Us</h1>
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-2">
                <label htmlFor="contact-name" className="block text-sm font-medium text-gray-700">Your Name</label>
                <Input
                  id="contact-name"
                  autoComplete="name"
                  placeholder="Your Name"
                  value={formData.name}
                  onChange={(e) => { setFormData({ ...formData, name: e.target.value }); setSubmitted(false); }}
                  required
                />
              </div>
              <div className="space-y-2">
                <label htmlFor="contact-email" className="block text-sm font-medium text-gray-700">Email</label>
                <Input
                  id="contact-email"
                  autoComplete="email"
                  type="email"
                  placeholder="Your Email"
                  value={formData.email}
                  onChange={(e) => { setFormData({ ...formData, email: e.target.value }); setSubmitted(false); }}
                  required
                />
              </div>
              <div className="space-y-2">
                <label htmlFor="contact-phone" className="block text-sm font-medium text-gray-700">Phone</label>
                <Input
                  id="contact-phone"
                  autoComplete="tel"
                  type="tel"
                  placeholder="Your Phone"
                  value={formData.phone}
                  onChange={(e) => { setFormData({ ...formData, phone: e.target.value }); setSubmitted(false); }}
                  required
                />
              </div>
              <div className="space-y-2">
                <label htmlFor="contact-message" className="block text-sm font-medium text-gray-700">How can we help?</label>
                <Textarea
                  id="contact-message"
                  placeholder="Your Message"
                  value={formData.message}
                  onChange={(e) => { setFormData({ ...formData, message: e.target.value }); setSubmitted(false); }}
                  rows={5}
                  required
                />
              </div>
              <Button type="submit" className="w-full rounded-full bg-primary hover:bg-primary/90 text-primary-foreground">
                <Send className="mr-2 h-5 w-5" />
                Send Message
              </Button>
            </form>
            {submitted && <p className="mt-4 text-sm text-green-700" role="status" aria-live="polite">WhatsApp is ready with your inquiry. Review the details and tap Send to contact our team.</p>}
          </div>

          <div className="space-y-6">
            <div>
              <h2 className="text-2xl font-playfair font-bold text-gray-900 mb-4">Get in Touch</h2>
              <Button onClick={handleWhatsApp} className="w-full rounded-full bg-primary hover:bg-primary/90 mb-4 text-primary-foreground">
                <Phone className="mr-2 h-5 w-5" />
                WhatsApp Inquiry
              </Button>
              <div className="bg-gray-50 p-6 rounded-xl space-y-3">
                <div className="flex items-start">
                  <MapPin className="h-5 w-5 text-primary mr-3 mt-1 flex-shrink-0" />
                  <span>Jaipur, Rajasthan, India</span>
                </div>
                <div className="flex items-center">
                  <Phone className="h-5 w-5 text-primary mr-3" />
                  <a href="tel:+918005708058" className="hover:text-primary">+91 8005708058</a>
                </div>
                <div className="flex items-center">
                  <Mail className="h-5 w-5 text-primary mr-3" />
                  <a href="mailto:kattainterior@gmail.com" className="break-all hover:text-primary">kattainterior@gmail.com</a>
                </div>
              </div>
            </div>

            {/* Map Link */}
            <a 
              href="https://www.google.com/maps/search/?api=1&query=Jaipur,Rajasthan,India" 
              target="_blank" 
              rel="noopener noreferrer"
              className="block h-64 bg-gray-200 rounded-xl flex items-center justify-center text-gray-500 hover:bg-gray-300 hover:text-gray-700 transition-colors"
            >
              <MapPin className="h-12 w-12" />
              <p className="ml-2 font-semibold">View on Google Maps</p>
            </a>
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
};

export default Contact;
