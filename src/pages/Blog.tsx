import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Card, CardContent } from '@/components/ui/card';
import { Link } from 'react-router-dom';

const blogPosts = [
  { 
    id: 1, 
    title: 'Top Sunmica Trends for 2024', 
    excerpt: 'Discover the latest in laminate designs and how they are transforming modern interiors.', 
    date: 'Jan 15, 2024', 
    image: '/images/gallery/sleek-kitchen-dark.png' 
  },
  { 
    id: 2, 
    title: 'How to Choose Panels for Your Home', 
    excerpt: 'A comprehensive guide to selecting the perfect panels for different rooms and aesthetics.', 
    date: 'Jan 10, 2024', 
    image: '/images/products/louvers/charcoal/gl-9407-room.png' 
  },
  { 
    id: 3, 
    title: 'Sustainable Interior Materials', 
    excerpt: 'Explore eco-friendly options with Sunmica and panels that do not compromise on luxury.', 
    date: 'Jan 5, 2024', 
    image: '/images/gallery/cozy-living.png' 
  },
];

const Blog = () => {
  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <section className="py-20 px-4">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-playfair font-bold text-center text-gray-900 mb-16">Blog & Ideas</h1>
          <div className="space-y-12">
            {blogPosts.map((post) => (
              <Card key={post.id} className="overflow-hidden border-0 shadow-sm hover:shadow-xl transition-all duration-300 group rounded-2xl">
                <Link to={`/blog/${post.id}`} className="block relative h-64 sm:h-80 overflow-hidden">
                  <img 
                    src={post.image} 
                    alt={post.title} 
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700" 
                  />
                  <div className="absolute inset-0 bg-black/5 group-hover:bg-transparent transition-colors duration-300" />
                </Link>
                <CardContent className="p-8">
                  <div className="flex text-sm text-teal-600 font-medium mb-3">{post.date}</div>
                  <Link to={`/blog/${post.id}`} className="block">
                    <h2 className="text-2xl md:text-3xl font-playfair font-bold text-gray-900 hover:text-teal-600 transition-colors mb-4">
                      {post.title}
                    </h2>
                  </Link>
                  <p className="text-gray-600 text-lg leading-relaxed">{post.excerpt}</p>
                  <Link to={`/blog/${post.id}`} className="inline-block mt-6 text-teal-600 font-semibold hover:text-teal-700">
                    Read More →
                  </Link>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
};

export default Blog;