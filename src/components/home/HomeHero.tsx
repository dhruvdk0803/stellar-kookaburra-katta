import { Link } from 'react-router-dom';
import { MessageCircle, Timer, Truck } from 'lucide-react';
import { container, focusRing, textLink } from './styles';

const promises = [
  { icon: Truck, text: 'Free shipping on every order' },
  { icon: Timer, text: 'Fast delivery across Jaipur' },
  { icon: MessageCircle, text: 'Help on WhatsApp when you need it' },
];

const HomeHero = () => (
  <section aria-labelledby="home-title" className="pt-4 sm:pt-10">
    <div className={`${container} grid items-center gap-8 lg:grid-cols-12 lg:gap-12`}>
      <div className="order-2 lg:order-none lg:col-span-5">
        <h1 id="home-title" className="text-balance text-[2.25rem] font-medium leading-[1.05] sm:text-5xl lg:text-[3.5rem]">
          Materials and hardware for interiors that last.
        </h1>
        <p className="mt-5 max-w-md text-pretty text-base leading-7 text-home-muted sm:text-lg sm:leading-8">
          Laminates, panels, fittings and plumbing for homes and projects, all in one place.
        </p>
        <div className="mt-8 flex flex-wrap items-center gap-x-6 gap-y-4">
          <Link
            to="/shop"
            className={`${focusRing} inline-flex h-12 items-center bg-home-accent px-6 text-base font-medium text-white hover:bg-home-ink`}
          >
            Shop the collection
          </Link>
          <a href="https://wa.me/918005708058?text=Inquiry%20from%20Katta%20Interiors%20website" target="_blank" rel="noreferrer" className={textLink}>
            Ask us on WhatsApp
          </a>
        </div>
      </div>

      <div className="order-1 lg:order-none lg:col-span-7">
        <div className="aspect-[3/2] overflow-hidden rounded bg-home-surface sm:aspect-[4/3] lg:max-h-[78vh]">
          <img
            src="/images/home/hero-panels.webp"
            alt="Laminate and panel samples suspended in a softly lit studio"
            width={1280}
            height={650}
            fetchPriority="high"
            decoding="async"
            className="h-full w-full object-cover"
          />
        </div>
      </div>
    </div>

    <div className={`${container} mt-10 sm:mt-14`}>
      <ul className="grid gap-3 border-y border-home-line py-5 text-[15px] text-home-muted sm:grid-cols-3 sm:gap-6">
        {promises.map(({ icon: Icon, text }) => (
          <li key={text} className="flex items-center gap-3">
            <Icon aria-hidden="true" className="h-[18px] w-[18px] shrink-0 text-home-accent" strokeWidth={1.5} />
            {text}
          </li>
        ))}
      </ul>
    </div>
  </section>
);

export default HomeHero;
