import assert from 'node:assert/strict';
import test from 'node:test';
import { getProductImages, getProductPrimaryImage, getSavedVariantImage } from '../src/lib/productImages.ts';

test('new gallery image wins over a legacy primary image and old variant image', () => {
  const product = {
    images: ['https://example.test/new.jpg'],
    image_url: 'https://example.test/old.jpg',
    variants: [{ image: 'https://example.test/old.jpg', is_default: true }],
  };
  assert.equal(getProductPrimaryImage(product), 'https://example.test/new.jpg');
  assert.deepEqual(getProductImages(product), ['https://example.test/new.jpg']);
});

test('legacy image and placeholder remain available when no gallery exists', () => {
  assert.deepEqual(getProductImages({ image_url: '/legacy.jpg' }), ['/legacy.jpg']);
  assert.deepEqual(getProductImages({ images: ['', null] }), ['/placeholder.svg']);
});

test('removed gallery image cannot remain attached to a saved option', () => {
  assert.equal(getSavedVariantImage('/old.jpg', ['/new.jpg']), undefined);
  assert.equal(getSavedVariantImage('/new.jpg', ['/new.jpg']), '/new.jpg');
});
