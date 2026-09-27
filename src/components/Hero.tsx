import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
import { ArrowRight, MessageCircle } from 'lucide-react';

const Hero = () => {
  return (
    <section className="overflow-hidden bg-[#f3f0e9] px-3 py-3 sm:px-6 sm:py-8">
      <div className="mx-auto grid max-w-[1440px] overflow-hidden rounded-[1.5rem] bg-[#17201d] sm:rounded-[2rem] lg:min-h-[620px] lg:grid-cols-[0.9fr_1.1fr]">
        <div className="relative z-10 flex flex-col justify-center px-6 py-10 text-white sm:px-12 sm:py-16 lg:px-16 xl:px-20">
          <p className="mb-4 text-[11px] font-semibold uppercase tracking-[0.24em] text-[#d8c6a2] sm:mb-6">Interior materials · Jaipur</p>
          <h1 className="max-w-xl text-[clamp(2.25rem,9vw,3rem)] font-normal leading-[1.06] sm:text-5xl lg:text-6xl xl:text-[4.5rem]">
            Materials that make a space feel considered.
          </h1>
          <p className="mt-6 max-w-lg text-sm leading-7 text-white/[0.68] sm:text-base">
            Surfaces, hardware and essentials for homes that are made to last.
          </p>

          <div className="mt-7 flex flex-col gap-3 sm:mt-9 sm:flex-row">
            <Button asChild size="lg" className="h-12 rounded-full bg-[#e2cda5] px-7 text-[#17201d] shadow-none hover:bg-[#eddcbc]">
              <Link to="/shop">Explore the collection <ArrowRight className="ml-2 h-4 w-4" /></Link>
            </Button>
            <Button asChild variant="outline" size="lg" className="h-12 rounded-full border-white/25 bg-transparent px-7 text-white hover:bg-white/10 hover:text-white">
              <Link to="/contact"><MessageCircle className="mr-2 h-4 w-4" /> Talk to our team</Link>
            </Button>
          </div>

          <div className="mt-9 flex flex-wrap gap-x-6 gap-y-2 border-t border-white/[0.12] pt-5 text-xs text-white/[0.58] sm:mt-12 sm:gap-8 sm:pt-6">
            <span>Curated brands</span>
            <span>Project quantities</span>
            <span>Expert support</span>
          </div>
        </div>

        <div className="relative min-h-[260px] sm:min-h-[420px] lg:min-h-full">
          <img src="/images/hero-background.png" alt="A curated selection of premium interior surface materials" className="absolute inset-0 h-full w-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-t from-[#17201d]/30 via-transparent to-transparent lg:bg-gradient-to-r lg:from-[#17201d]/[0.35] lg:to-transparent" />
          <div className="absolute bottom-6 right-6 max-w-[220px] rounded-2xl border border-white/30 bg-white/[0.85] p-4 text-[#17201d] shadow-xl backdrop-blur-md sm:bottom-8 sm:right-8">
            <p className="text-[10px] font-semibold uppercase tracking-[0.2em] text-[#7d6a4e]">One trusted source</p>
            <p className="mt-2 text-sm leading-5">From the first sample to the final fitting.</p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
