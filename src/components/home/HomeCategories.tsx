import { Link } from 'react-router-dom';
import { useHomeCategories } from '@/hooks/useHomeCatalog';
import { categoryShopUrl } from '@/lib/catalog';
import { handleImageError } from '@/lib/productImages';
import SectionHeader from './SectionHeader';
import { container, focusRing, section, textLink } from './styles';

const zoomOnHover = 'transition-transform duration-500 ease-out group-hover:scale-[1.03] motion-reduce:transition-none motion-reduce:group-hover:scale-100';
const skeleton = 'animate-pulse rounded bg-home-line/60 motion-reduce:animate-none';

const HomeCategories = () => {
  const { data: categories, isPending, isError } = useHomeCategories();

  // Keep showing loaded data if a background refetch fails; only an empty result falls back.
  if (!isPending && !categories?.length) {
    return (
      <section className={section}>
        <p className={`${container} text-home-muted`}>
          {isError ? 'The categories could not be loaded right now.' : 'New categories are on their way.'}{' '}
          <Link to="/shop" className={textLink}>Browse all products</Link>
        </p>
      </section>
    );
  }

  return (
    <section aria-labelledby="home-categories" className={section}>
      <div className={container}>
        <SectionHeader id="home-categories" title="Shop by category" linkTo="/shop" linkLabel="All products" />
        <ul aria-busy={isPending} className="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 sm:gap-y-10 lg:grid-cols-4 xl:grid-cols-5">
          {isPending
            ? Array.from({ length: 8 }, (_, index) => (
              <li key={index} aria-hidden="true">
                <div className={`aspect-square ${skeleton}`} />
                <div className={`mt-4 h-6 w-2/3 ${skeleton}`} />
                <div className={`mt-1 h-5 w-1/3 ${skeleton}`} />
              </li>
            ))
            : categories.map((category) => (
              <li key={category.id}>
                <Link to={categoryShopUrl(category.slug)} className={`${focusRing} group block`}>
                  <div className="aspect-square overflow-hidden rounded bg-home-tile p-4 sm:p-6">
                    {category.image ? (
                      <img
                        src={category.image}
                        alt=""
                        width={400}
                        height={400}
                        loading="lazy"
                        onError={handleImageError}
                        decoding="async"
                        className={`h-full w-full object-contain mix-blend-multiply ${zoomOnHover}`}
                      />
                    ) : (
                      <div aria-hidden="true" className="flex h-full items-center justify-center text-5xl font-medium text-home-line">
                        {category.name.charAt(0)}
                      </div>
                    )}
                  </div>
                  <h3 className="mt-4 line-clamp-2 break-words text-base font-medium leading-snug underline-offset-4 group-hover:underline">{category.name}</h3>
                  <p className="mt-1 text-sm tabular-nums text-home-muted">
                    {category.productCount} {category.productCount === 1 ? 'product' : 'products'}
                  </p>
                </Link>
              </li>
            ))}
        </ul>
      </div>
    </section>
  );
};

export default HomeCategories;
