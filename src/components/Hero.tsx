import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
import { ArrowRight, MessageCircle, Search } from 'lucide-react';

const Hero = () => {
  return (
    <section className="relative flex min-h-[500px] items-center overflow-hidden bg-slate-950 md:min-h-[560px]">
      <div className="absolute inset-0 bg-cover bg-center opacity-55" style={{ backgroundImage: "url('/images/hero-background.png')" }} />
      <div className="absolute inset-0 bg-gradient-to-r from-slate-950 via-slate-950/80 to-slate-900/20" />
      
      <div className="relative z-10 mx-auto w-full max-w-7xl px-6 py-20">
        <div className="max-w-3xl text-left text-white">
        <p className="mb-4 text-xs font-bold uppercase tracking-[0.24em] text-white/70">Katta Plywood and Hardware</p>
        <h1 className="text-4xl font-bold leading-[1.08] sm:text-5xl md:text-6xl">
          Every material your space needs, in one trusted catalog
        </h1>
        <p className="mt-5 max-w-2xl text-base leading-relaxed text-white/80 sm:text-lg">
          Explore laminates, decorative panels, furniture hardware, adhesives, digital locks, and plumbing products from leading brands.
        </p>
        
        <div className="mt-8 flex flex-col gap-3 sm:flex-row">
          <Button asChild size="lg" className="rounded-full bg-white px-7 text-slate-950 shadow-lg hover:bg-white/90">
            <Link to="/shop">
              <Search className="mr-2 h-4 w-4" /> Shop all products <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
          <Button asChild variant="outline" size="lg" className="rounded-full border-white/50 bg-white/10 px-7 text-white backdrop-blur-sm hover:bg-white/20 hover:text-white">
            <Link to="/contact">
              <MessageCircle className="mr-2 h-4 w-4" /> Bulk order enquiry
            </Link>
          </Button>
        </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
