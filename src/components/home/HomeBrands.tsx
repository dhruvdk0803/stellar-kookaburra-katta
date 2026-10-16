import { Link } from 'react-router-dom';
import BrandLogo from '@/components/BrandLogo';
import { useHomeBrands } from '@/hooks/useHomeCatalog';
import { brandShopUrl } from '@/lib/catalog';
import { container, focusRing } from './styles';

const HomeBrands = () => {
  const { data: brands } = useHomeBrands();
  // A supporting row: nothing renders until it loads, and nothing if it fails.
  if (!brands?.length) return null;

  return (
    <section aria-labelledby="home-brands" className="border-y border-home-line bg-home-surface py-14 sm:py-16">
      <div className={container}>
        <h2 id="home-brands" className="text-balance text-center text-[15px] font-medium text-home-muted">Brands we stock</h2>
        <ul className="mt-8 flex flex-wrap items-center justify-center gap-x-6 gap-y-4 sm:gap-x-8">
          {brands.map((brand) => (
            <li key={brand.id}>
              <Link
                to={brandShopUrl(brand.slug)}
                aria-label={brand.product_count ? `${brand.name}, ${brand.product_count} ${brand.product_count === 1 ? 'product' : 'products'}` : brand.name}
                className={`${focusRing} flex h-16 w-28 items-center justify-center opacity-70 grayscale transition-opacity duration-300 motion-reduce:transition-none hover:opacity-100 hover:grayscale-0`}
              >
                <BrandLogo name={brand.name} logoUrl={brand.logo_url} className="max-h-10 w-full object-contain" />
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
};

export default HomeBrands;
