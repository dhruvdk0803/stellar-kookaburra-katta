import Navigation from '@/components/Navigation';
import Hero from '@/components/Hero';
import HomeCatalog from '@/components/HomeCatalog';
import WhyChooseKatta from '@/components/WhyChooseKatta';
import InspirationGallery from '@/components/InspirationGallery';
import Footer from '@/components/Footer';

const Index = () => {
  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <Hero />
      <HomeCatalog />
      <WhyChooseKatta />
      <InspirationGallery />
      <Footer />
    </div>
  );
};

export default Index;
