export interface Brand {
  id: string;
  name: string;
  slug: string;
  logo_url?: string | null;
  display_order?: number;
  product_count?: number;
}

export interface CategoryCard {
  id: string;
  name: string;
  slug: string;
  parent_id?: string | null;
  image_url?: string | null;
  thumbnail_url?: string | null;
  display_order?: number;
  product_count: number;
  root_id: string;
  root_name: string;
  root_slug: string;
  root_display_order?: number;
}

export const ensureBrandPrefix = (name: string, brandName: string): string => {
  const escaped = brandName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  let base = name.trim();
  const prefix = new RegExp(`^${escaped}\\s+`, 'i');
  while (prefix.test(base)) base = base.replace(prefix, '').trim();
  return base ? `${brandName} ${base}` : brandName;
};

export const stripKnownBrandPrefix = (name: string, brands: Pick<Brand, 'name'>[]): string => {
  const match = [...brands]
    .sort((a, b) => b.name.length - a.name.length)
    .find((brand) => new RegExp(`^${brand.name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s+`, 'i').test(name.trim()));
  return match ? name.trim().slice(match.name.length).trim() : name.trim();
};

export const categoryShopUrl = (slug: string) =>
  `/shop?category=${encodeURIComponent(slug)}`;

export const brandShopUrl = (slug: string) =>
  `/shop?brand=${encodeURIComponent(slug)}`;
