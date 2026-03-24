import React from 'react';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Link } from 'react-router-dom';

const projects = [
  { id: 1, title: 'Modern Kitchen Renovation', image: '/images/gallery/sleek-kitchen-dark.png', category: 'Sunmica' },
  { id: 2, title: 'Office Louver Design', image: '/images/gallery/modern-commercial.png', category: 'Panels' },
  { id: 3, title: 'Luxury Bedroom', image: '/images/gallery/elegant-bedroom.png', category: 'Sunmica' },
  { id: 4, title: 'Commercial Space', image: '/images/products/louvers/charcoal/gl-9407-room.png', category: 'Panels' },
  { id: 5, title: 'Cozy Living Room', image: '/images/gallery/cozy-living.png', category: 'Panels' },
  { id: 6, title: 'Minimalist Kitchen', image: '/images/gallery/sleek-kitchen-white.png', category: 'Sunmica' },
];

const Projects = () => {
  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <section className="py-20 px-4">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-4xl font-playfair font-bold text-center text-gray-900 mb-16">Projects & Inspiration</h1>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {projects.map((project) => (
              <Link key={project.id} to={`/projects/${project.id}`} className="block group">
                <div className="relative overflow-hidden rounded-2xl shadow-sm hover:shadow-xl transition-all">
                  <img src={project.image} alt={project.title} className="w-full h-72 object-cover group-hover:scale-105 transition-transform duration-500" />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                  <div className="absolute bottom-6 left-6 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300 transform translate-y-4 group-hover:translate-y-0">
                    <h3 className="text-xl font-semibold mb-1">{project.title}</h3>
                    <p className="text-sm text-teal-200 font-medium">{project.category}</p>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
};

export default Projects;