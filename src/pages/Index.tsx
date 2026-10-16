import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';
import HomeHero from '@/components/home/HomeHero';
import HomeCategories from '@/components/home/HomeCategories';
import HomeNewArrivals from '@/components/home/HomeNewArrivals';
import HomeBrands from '@/components/home/HomeBrands';
import HomeStory from '@/components/home/HomeStory';

// Every catalog section reads live rows, so products, brands and categories
// added in the admin panel appear here without a code change.
const Index = () => {
  return (
    <div className="min-h-screen bg-white font-poppins">
      <Navigation />
      <main id="main" className="home">
        <HomeHero />
        <HomeCategories />
        <HomeNewArrivals />
        <HomeBrands />
        <HomeStory />
      </main>
      <Footer />
    </div>
  );
};

export default Index;
