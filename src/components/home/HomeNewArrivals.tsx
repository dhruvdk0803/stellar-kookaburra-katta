import { Link } from 'react-router-dom';
import { useNewArrivals } from '@/hooks/useHomeCatalog';
import { stripKnownBrandPrefix } from '@/lib/catalog';
import { cardPrice, isNewProduct, productBrand } from '@/lib/homeCatalog';
import { getProductPrimaryImage, handleImageError } from '@/lib/productImages';
import { formatRupees } from '@/lib/money';
import SectionHeader from './SectionHeader';
import { container, focusRing, section } from './styles';

const zoomOnHover = 'transition-transform duration-500 ease-out group-hover:scale-[1.03] motion-reduce:transition-none motion-reduce:group-hover:scale-100';
const skeleton = 'animate-pulse rounded bg-home-line/60 motion-reduce:animate-none';

const HomeNewArrivals = () => {
  const { data: products, isPending, isError } = useNewArrivals(8);

  // The category grid above already offers a way into the shop if this fails.
  if (!isPending && !products?.length) return null;
  // Only call them "new" while at least one really is.
  const title = products?.some((product) => isNewProduct(product.created_at)) ? 'New arrivals' : 'Latest additions';

  return (
    <section aria-labelledby="home-new" className={section}>
      <div className={container}>
        <SectionHeader id="home-new" title={title} linkTo="/shop" linkLabel="View all" />
        <ul aria-busy={isPending} className="grid grid-cols-2 gap-x-4 gap-y-10 sm:gap-x-6 lg:grid-cols-4">
          {isPending
            ? Array.from({ length: 8 }, (_, index) => (
              <li key={index} aria-hidden="true">
                <div className={`aspect-square ${skeleton}`} />
                <div className={`mt-4 h-5 w-1/3 ${skeleton}`} />
                <div className={`mt-1 h-12 w-4/5 ${skeleton}`} />
                <div className={`mt-2 h-6 w-1/4 ${skeleton}`} />
              </li>
            ))
            : products.map((product) => {
              const brand = productBrand(product);
              const price = cardPrice(product);
              const name = brand ? stripKnownBrandPrefix(product.name, [{ name: brand }]) : product.name;
              return (
                <li key={product.id}>
                  <Link to={`/product/${product.id}`} className={`${focusRing} group block`}>
                    <div className="relative aspect-square overflow-hidden rounded bg-home-tile p-5 sm:p-7">
                      <img
                        src={getProductPrimaryImage(product)}
                        alt=""
                        onError={handleImageError}
                        width={400}
                        height={400}
                        loading="lazy"
                        decoding="async"
                        className={`h-full w-full object-contain mix-blend-multiply ${zoomOnHover}`}
                      />
                      {isNewProduct(product.created_at) && (
                        <span className="absolute left-3 top-3 rounded bg-home-bg px-2 py-1 text-xs font-medium">New</span>
                      )}
                    </div>
                    {brand && <p className="mt-4 truncate text-sm text-home-muted">{brand}</p>}
                    <h3 className={`${brand ? 'mt-1' : 'mt-4'} line-clamp-2 break-words text-base font-medium leading-snug underline-offset-4 group-hover:underline`}>{name}</h3>
                    {price && (
                      <p className="mt-2 text-base tabular-nums">
                        {price.from && <span className="text-home-muted">From </span>}₹{formatRupees(price.amount)}
                      </p>
                    )}
                  </Link>
                </li>
              );
            })}
        </ul>
      </div>
    </section>
  );
};

export default HomeNewArrivals;
