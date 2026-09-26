type ProductMedia = {
  images?: unknown;
  image_url?: unknown;
  image?: unknown;
};

export const getProductImages = (product: ProductMedia): string[] => {
  const gallery = Array.isArray(product.images)
    ? product.images.filter((image): image is string => typeof image === 'string' && image.trim().length > 0)
    : [];
  if (gallery.length) return gallery;
  for (const fallback of [product.image_url, product.image]) {
    if (typeof fallback === 'string' && fallback.trim()) return [fallback];
  }
  return ['/placeholder.svg'];
};

export const getProductPrimaryImage = (product: ProductMedia): string =>
  getProductImages(product)[0];

export const getSavedVariantImage = (image: unknown, gallery: string[]): string | undefined =>
  typeof image === 'string' && gallery.includes(image) ? image : undefined;
