import React from 'react';
import { Checkbox } from '@/components/ui/checkbox';
import { Slider } from '@/components/ui/slider';

interface CategoryFilterItem {
  id: string;
  name: string;
  slug?: string;
  parent_id?: string | null;
}

interface ShopFilterState {
  category: string[];
  brand: string[];
  price: number[];
}

interface ShopFiltersProps {
  categories: CategoryFilterItem[];
  onFilterChange: (filters: ShopFilterState) => void;
  filters: ShopFilterState;
  priceMax: number;
  availableBrands?: { name: string; slug: string }[];
}

const ShopFilters = ({ categories, onFilterChange, filters, priceMax, availableBrands = [] }: ShopFiltersProps) => {
  const handleCategoryChange = (categoryItem: CategoryFilterItem) => {
    const aliases = [categoryItem.name, categoryItem.slug].filter(Boolean);
    const isSelected = filters.category.some((selected: string) => aliases.includes(selected));
    const category = isSelected
      ? filters.category.filter((selected: string) => !aliases.includes(selected))
      : [...filters.category, categoryItem.slug || categoryItem.name];
    onFilterChange({ ...filters, category });
  };

  const handleBrandChange = (brand: string) => {
    const brandArr = filters.brand || [];
    const selected = brandArr.some((item: string) => item.toLowerCase() === brand.toLowerCase());
    const next = selected
      ? brandArr.filter((item: string) => item.toLowerCase() !== brand.toLowerCase())
      : [...brandArr, brand];
    onFilterChange({ ...filters, brand: next });
  };

  const handlePriceChange = (value: number[]) => {
    onFilterChange({ ...filters, price: value });
  };

  // Group categories for display (Main categories and their subcategories)
  const mainCategories = categories.filter(c => !c.parent_id);
  const renderCategory = (category: CategoryFilterItem, depth = 0, ancestors = new Set<string>()): React.ReactNode => {
    if (depth > 10 || ancestors.has(category.id)) return null;
    const childAncestors = new Set(ancestors).add(category.id);
    const children = categories.filter((candidate) => candidate.parent_id === category.id);
    const aliases = [category.name, category.slug].filter(Boolean);
    return (
      <div key={category.id} className={depth === 0 ? 'space-y-2' : 'space-y-2 border-l border-gray-100 pl-4'}>
        <div className="flex items-center space-x-2">
          <Checkbox
            id={`category-${category.id}`}
            checked={filters.category.some((selected) => aliases.includes(selected))}
            onCheckedChange={() => handleCategoryChange(category)}
          />
          <label htmlFor={`category-${category.id}`} className={`cursor-pointer ${depth === 0 ? 'text-sm font-semibold text-gray-900' : 'text-sm text-gray-600'}`}>
            {category.name}
          </label>
        </div>
        {children.length > 0 && (
          <div className="space-y-2 pl-5">
            {children.map((child) => renderCategory(child, depth + 1, childAncestors))}
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="space-y-8">
      <div>
        <h3 className="font-semibold text-gray-900 mb-4">Categories</h3>
        {mainCategories.length === 0 ? (
          <p className="text-sm text-gray-500">No categories available.</p>
        ) : (
          <div className="space-y-4">
            {mainCategories.map((category) => renderCategory(category))}
          </div>
        )}
      </div>

      {(availableBrands.length > 1 || (filters.brand || []).length > 0) && (
        <div>
          <h3 className="font-semibold text-gray-900 mb-4">Brand</h3>
          <div className="flex flex-wrap gap-2">
            {availableBrands.map(brand => (
              <button
                key={brand.slug}
                onClick={() => handleBrandChange(brand.slug)}
                className={`px-3 py-1.5 rounded-full text-sm border transition-colors ${
                  (filters.brand || []).some((selected: string) => selected.toLowerCase() === brand.slug.toLowerCase())
                    ? 'bg-primary text-primary-foreground border-primary'
                    : 'bg-white text-gray-700 border-gray-200 hover:border-primary/50'
                }`}
              >
                {brand.name}
              </button>
            ))}
          </div>
        </div>
      )}

      <div>
        <h3 className="font-semibold text-gray-900 mb-4">Price Range</h3>
        <Slider
          value={filters.price}
          onValueChange={handlePriceChange}
          max={priceMax}
          step={100}
          className="w-full"
        />
        <div className="flex justify-between text-sm text-gray-600 mt-3 font-medium">
          <span>₹{filters.price[0]}</span>
          <span>₹{filters.price[1]}+</span>
        </div>
      </div>
    </div>
  );
};

export default ShopFilters;
