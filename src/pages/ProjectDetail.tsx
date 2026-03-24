import React from 'react';
import { useParams } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';
import { ArrowLeft } from 'lucide-react';
import { Link } from 'react-router-dom';

const projectData: { [key: string]: {
    title: string;
    images: string[];
    description: string;
    materials: string[];
    category: string;
}} = {
  '1': {
    title: 'Modern Kitchen Renovation',
    images: ['/images/gallery/sleek-kitchen-dark.png', '/images/gallery/sleek-kitchen-white.png'],
    description: 'Transformed a traditional kitchen into a sleek modern space using premium Sunmica laminates for cabinets and countertops. The gloss finish adds a luxurious touch while maintaining functionality and easy cleaning.',
    materials: ['Kridha 1mm Gloss Finish', 'Thermoluxe 1.3mm Premium'],
    category: 'Sunmica',
  },
  '2': {
    title: 'Office Louver Design',
    images: ['/images/gallery/modern-commercial.png', '/images/products/louvers/charcoal/gl-9407-room.png'],
    description: 'Custom louvers installed for natural light control and privacy in a corporate office. The textured finish complements the modern architecture while providing excellent acoustic properties.',
    materials: ['Charcoal Louvers', 'MDF Panels'],
    category: 'Panels',
  },
  '3': {
    title: 'Luxury Bedroom',
    images: ['/images/gallery/elegant-bedroom.png', '/images/gallery/warm-decor.png'],
    description: 'A serene and luxurious bedroom setup featuring warm wood-finish laminates and textured wall panels for a cozy yet sophisticated ambiance.',
    materials: ['Rockstar Premium Woodgrain', 'Pastel Louvers'],
    category: 'Sunmica',
  },
  '4': {
    title: 'Commercial Space',
    images: ['/images/products/louvers/charcoal/gl-9407-room.png', '/images/gallery/modern-commercial.png'],
    description: 'High-traffic commercial area designed with durable, scratch-resistant panels and striking charcoal louvers to create a memorable customer experience.',
    materials: ['Charcoal Louvers GL-9407', 'Acrylic Sheets'],
    category: 'Panels',
  },
  '5': {
    title: 'Cozy Living Room',
    images: ['/images/gallery/cozy-living.png', '/images/gallery/warm-decor.png'],
    description: 'A warm and inviting living room featuring beautiful wall paneling and custom entertainment unit laminates that serve as the focal point of the home.',
    materials: ['Flexible Louvers', 'Trustlam Pastels'],
    category: 'Panels',
  },
  '6': {
    title: 'Minimalist Kitchen',
    images: ['/images/gallery/sleek-kitchen-white.png', '/images/gallery/sleek-kitchen-dark.png'],
    description: 'Clean lines and bright spaces define this minimalist kitchen, utilizing high-gloss white laminates for an expansive, airy feel.',
    materials: ['Thermoluxe High Gloss White', 'Kridha Solid Colors'],
    category: 'Sunmica',
  }
};

const ProjectDetail = () => {
  const { id } = useParams<{ id: string }>();
  const project = id ? projectData[id] : undefined;

  if (!project) {
    return <div>Project not found</div>;
  }

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-6xl mx-auto">
          {/* Back Button */}
          <Link to="/projects" className="flex items-center mb-8 text-teal-600 hover:text-teal-700 w-fit">
            <ArrowLeft className="h-5 w-5 mr-2" />
            Back to Projects
          </Link>

          <h1 className="text-4xl md:text-5xl font-playfair font-bold text-gray-900 mb-8">{project.title}</h1>

          {/* Images Gallery */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
            {project.images.map((img, idx) => (
              <div key={idx} className="rounded-2xl overflow-hidden shadow-lg h-80 md:h-96">
                <img src={img} alt={`${project.title} ${idx + 1}`} className="w-full h-full object-cover hover:scale-105 transition-transform duration-700" />
              </div>
            ))}
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
            {/* Description */}
            <div className="lg:col-span-2 prose max-w-none">
              <h2 className="text-2xl font-playfair font-bold text-gray-900 mb-4">About the Project</h2>
              <p className="text-lg text-gray-700 leading-relaxed font-poppins">{project.description}</p>
            </div>

            {/* Materials Used */}
            <div className="bg-gray-50 p-8 rounded-2xl h-fit">
              <h2 className="text-xl font-playfair font-bold text-gray-900 mb-6">Materials Used</h2>
              <div className="flex flex-col gap-3 mb-8">
                {project.materials.map((material, idx) => (
                  <div key={idx} className="bg-white px-4 py-3 rounded-lg border border-gray-100 shadow-sm text-gray-700 font-medium">
                    {material}
                  </div>
                ))}
              </div>
              
              <Link to={`/shop?category=${project.category}`}>
                <Button className="w-full py-6 text-lg bg-teal-600 hover:bg-teal-700 rounded-xl shadow-md">
                  Shop {project.category}
                </Button>
              </Link>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default ProjectDetail;