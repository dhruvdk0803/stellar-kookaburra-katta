import { Link } from 'react-router-dom';
import { container, section, textLink } from './styles';

const values = [
  { title: 'Named brands', text: 'Branded products with clear specifications on every product page.' },
  { title: 'Project-ready range', text: 'From a single hinge to a complete material schedule for the site.' },
  { title: 'People who can help', text: 'Practical advice when you need to compare finishes, sizes or prices.' },
];

const HomeStory = () => (
  <section aria-labelledby="home-story" className={section}>
    <div className={`${container} grid items-center gap-10 lg:grid-cols-12 lg:gap-16`}>
      <div className="lg:col-span-6">
        <div className="aspect-[8/7] overflow-hidden rounded bg-home-surface">
          <img
            src="/images/home/materials-studio.webp"
            alt="Wood, stone-finish and fluted panels arranged in a studio"
            width={1024}
            height={880}
            loading="lazy"
            decoding="async"
            className="h-full w-full object-cover"
          />
        </div>
      </div>
      <div className="lg:col-span-6">
        <h2 id="home-story" className="max-w-md text-balance text-2xl font-medium sm:text-[2rem] sm:leading-tight">
          One store for the whole fit-out.
        </h2>
        <p className="mt-5 max-w-lg text-pretty leading-7 text-home-muted">
          From the first laminate sample to the last fitting, Katta Interiors brings the materials and hardware for a project together in one place.
        </p>
        <dl className="mt-10 divide-y divide-home-line border-y border-home-line">
          {values.map((value) => (
            <div key={value.title} className="grid gap-1 py-5 sm:grid-cols-[11rem_1fr] sm:gap-6">
              <dt className="font-medium">{value.title}</dt>
              <dd className="text-home-muted">{value.text}</dd>
            </div>
          ))}
        </dl>
        <div className="mt-8 flex flex-wrap gap-x-7 gap-y-3">
          <Link to="/projects" className={textLink}>See our projects</Link>
          <Link to="/about" className={textLink}>About Katta</Link>
        </div>
        <p className="mt-8 text-sm leading-6 text-home-muted">
          For available items in Jaipur we try to deliver in under 2 hours. Delivery times are not guaranteed.
        </p>
      </div>
    </div>
  </section>
);

export default HomeStory;
