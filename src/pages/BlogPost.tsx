import React, { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import { ArrowLeft, Calendar, User } from 'lucide-react';
import { Link } from 'react-router-dom';

const blogPostData: { [key: string]: {
    title: string;
    content: string;
    date: string;
    author: string;
    image: string;
    related: number[];
}} = {
  '1': {
    title: 'Top Sunmica Trends for 2024',
    image: '/images/gallery/sleek-kitchen-dark.png',
    content: `
      <p>Sunmica laminates continue to dominate interior design in 2024 with innovative textures and sustainable materials. Here's what architects and designers are loving this year.</p>
      
      <h2>Matte Finishes Take Center Stage</h2>
      <p>Goodbye gloss, hello matte! The subtle elegance of matte Sunmica is perfect for modern minimalist spaces. Brands like Rockstar offer durable options that resist fingerprints and maintain their look over time.</p>
      
      <h2>Sustainable Choices</h2>
      <p>With eco-conscious clients on the rise, recycled laminates and low-VOC options are trending. Trustlam's pastel collection combines sustainability with soft-touch finishes.</p>
      
      <h2>Textured Innovations</h2>
      <p>From wood-grain effects to stone textures, Sunmica is mimicking natural materials better than ever. Ideal for accent walls and furniture that feels premium without the premium price.</p>
      
      <p>Ready to incorporate these trends? Explore our collection and elevate your next project.</p>
    `,
    date: 'January 15, 2024',
    author: 'Design Team',
    related: [2, 3],
  },
  '2': {
    title: 'How to Choose Panels for Your Home',
    image: '/images/products/louvers/charcoal/gl-9407-room.png',
    content: `
      <p>Panels can transform any space, but choosing the right one depends on your needs. Here's a guide to help you decide between louvers, sheets, and more.</p>
      
      <h2>Louvers for Light Control</h2>
      <p>Aluminum or wooden louvers are perfect for windows and partitions. They offer privacy while allowing natural light to filter through.</p>
      
      <h2>Sheets for Versatility</h2>
      <p>PVC and acrylic sheets work great for false ceilings, wall cladding, and custom installations. Choose based on thickness and finish for your specific application.</p>
      
      <h2>Installation Tips</h2>
      <p>Always consult a professional for load-bearing panels. Proper installation ensures longevity and safety.</p>
    `,
    date: 'January 10, 2024',
    author: 'Interior Expert',
    related: [1, 3],
  },
  '3': {
    title: 'Sustainable Interior Materials',
    image: '/images/gallery/cozy-living.png',
    content: `
      <p>As environmental awareness grows, the demand for sustainable interior materials has skyrocketed. Here is how you can make eco-friendly choices without sacrificing style.</p>
      
      <h2>Eco-Friendly Laminates</h2>
      <p>Many modern laminates are now produced using recycled materials and sustainable manufacturing processes. Look for certifications that guarantee low emissions and responsible sourcing.</p>
      
      <h2>Longevity is Sustainability</h2>
      <p>Choosing high-quality, durable materials like premium Sunmica means less frequent replacements. A product that lasts 20 years is inherently more sustainable than one that needs replacing every 5 years.</p>
      
      <h2>Smart Paneling</h2>
      <p>Modern wall panels not only look great but can also provide excellent insulation, reducing the energy needed to heat or cool your home.</p>
    `,
    date: 'January 5, 2024',
    author: 'Eco Design Team',
    related: [1, 2],
  }
};

const BlogPost = () => {
  const { id } = useParams<{ id: string }>();
  const post = id ? blogPostData[id] : undefined;

  // Scroll to top when post changes
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [id]);

  if (!post) {
    return (
      <div className="min-h-screen bg-white font-poppins flex flex-col">
        <Navigation />
        <div className="flex-1 flex items-center justify-center">
          <div className="text-center">
            <h2 className="text-2xl font-playfair font-bold mb-4">Blog post not found</h2>
            <Link to="/blog" className="text-teal-600 hover:underline">Return to Blog</Link>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <div className="py-12 px-4">
        <div className="max-w-4xl mx-auto">
          {/* Back Button */}
          <Link to="/blog" className="flex items-center mb-8 text-teal-600 hover:text-teal-700 w-fit">
            <ArrowLeft className="h-5 w-5 mr-2" />
            Back to Blog
          </Link>

          <article>
            <header className="mb-8">
              <h1 className="text-4xl md:text-5xl font-playfair font-bold text-gray-900 mb-6 leading-tight">{post.title}</h1>
              <div className="flex items-center space-x-6 text-gray-500 text-sm font-medium">
                <div className="flex items-center">
                  <Calendar className="h-4 w-4 mr-2 text-teal-600" />
                  {post.date}
                </div>
                <div className="flex items-center">
                  <User className="h-4 w-4 mr-2 text-teal-600" />
                  {post.author}
                </div>
              </div>
            </header>

            {/* Featured Image */}
            <div className="w-full h-64 md:h-[400px] rounded-2xl overflow-hidden mb-12 shadow-md">
              <img src={post.image} alt={post.title} className="w-full h-full object-cover" />
            </div>

            {/* Content */}
            <div 
              className="prose prose-lg max-w-none mb-16 prose-headings:font-playfair prose-headings:text-gray-900 prose-p:text-gray-700 prose-p:leading-relaxed prose-a:text-teal-600"
              dangerouslySetInnerHTML={{ __html: post.content }}
            />

            {/* Related Posts */}
            <div className="mb-12 pt-12 border-t border-gray-100">
              <h2 className="text-3xl font-playfair font-bold text-gray-900 mb-8">Related Posts</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                {post.related.map((relId) => {
                  const relPost = blogPostData[relId.toString()];
                  if (!relPost) return null;
                  return (
                    <Link key={relId} to={`/blog/${relId}`} className="block group hover:shadow-xl transition-all duration-300 rounded-2xl overflow-hidden border border-gray-100 bg-white">
                      <div className="h-56 overflow-hidden">
                        <img 
                          src={relPost.image} 
                          alt={relPost.title} 
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" 
                        />
                      </div>
                      <div className="p-6">
                        <p className="text-teal-600 text-sm font-medium mb-2">{relPost.date}</p>
                        <h3 className="font-playfair font-bold text-xl text-gray-900 mb-2 group-hover:text-teal-600 transition-colors">{relPost.title}</h3>
                      </div>
                    </Link>
                  );
                })}
              </div>
            </div>
          </article>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default BlogPost;