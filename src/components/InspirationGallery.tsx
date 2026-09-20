import { Button } from '@/components/ui/button';
import { ArrowRight } from 'lucide-react';
import { Link } from 'react-router-dom';

const InspirationGallery = () => {
  return (
    <section className="bg-[#f3f0e9] px-4 py-20 sm:px-6 sm:py-24">
      <div className="mx-auto max-w-7xl">
        <div className="mb-10 flex flex-col justify-between gap-5 sm:flex-row sm:items-end">
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.24em] text-[#8b7655]">In real spaces</p>
            <h2 className="mt-3 max-w-lg text-3xl font-normal leading-tight text-[#17201d] sm:text-4xl">See how the right materials change the room.</h2>
          </div>
          <Button asChild variant="outline" className="w-fit rounded-full border-[#bfb7a8] bg-transparent px-6 text-[#17201d] hover:bg-white">
            <Link to="/projects">View projects <ArrowRight className="ml-2 h-4 w-4" /></Link>
          </Button>
        </div>

        <div className="grid gap-4 md:grid-cols-[1.35fr_0.65fr]">
          <Link to="/projects/6" className="group relative min-h-[420px] overflow-hidden rounded-[2rem] sm:min-h-[560px]">
            <img src="/images/gallery/warm-decor.png" alt="Warm living space finished with rich wood surfaces" loading="lazy" className="absolute inset-0 h-full w-full object-cover transition duration-700 group-hover:scale-[1.03]" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/55 via-transparent to-transparent" />
            <p className="absolute bottom-7 left-7 text-xl text-white">Warm, tactile living</p>
          </Link>
          <Link to="/projects/2" className="group relative min-h-[360px] overflow-hidden rounded-[2rem] md:min-h-full">
            <img src="/images/gallery/sleek-kitchen-white.png" alt="Minimal white kitchen with refined surfaces" loading="lazy" className="absolute inset-0 h-full w-full object-cover transition duration-700 group-hover:scale-[1.03]" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/45 via-transparent to-transparent" />
            <p className="absolute bottom-7 left-7 text-xl text-white">Quiet, modern kitchens</p>
          </Link>
        </div>
      </div>
    </section>
  );
};

export default InspirationGallery;
