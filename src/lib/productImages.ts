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

// A photo repeated on every option does not describe a particular option.
// Prefer the current gallery photo in that case: older imported option photos
// can otherwise replace an updated product image as soon as a size is chosen.
export const getVariantDisplayImage = (
  variant: { image?: unknown },
  variants: { image?: unknown }[],
  primaryImage: string,
): string => {
  const image = typeof variant.image === 'string' && variant.image.trim() ? variant.image : undefined;
  if (!image) return primaryImage;
  const sharedByEveryOption = variants.length > 1 && variants.every((option) => option.image === image);
  return sharedByEveryOption && primaryImage !== '/placeholder.svg' ? primaryImage : image;
};
