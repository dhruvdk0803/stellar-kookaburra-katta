import React, { useState, useEffect } from 'react';
import { Checkbox } from '@/components/ui/checkbox';
import { Slider } from '@/components/ui/slider';

interface ShopFiltersProps {
  categories: any[];
  onFilterChange: (filters: any) => void;
  initialFilters?: any;
}

const ShopFilters = ({ categories, onFilterChange, initialFilters = {} }: ShopFiltersProps) => {
  const [filters, setFilters] = useState({
    category: initialFilters.category || [],
    price: initialFilters.price || [0, 10000],
  });

  useEffect(() => {
    onFilterChange(filters);
  }, [filters]);

  const handleCategoryChange = (categoryName: string) => {
    setFilters(prev => ({
      ...prev,
      category: prev.category.includes(categoryName)
        ? prev.category.filter((c: string) => c !== categoryName)
        : [...prev.category, categoryName],
    }));
  };

  const handlePriceChange = (value: number[]) => {
    setFilters(prev => ({ ...prev, price: value }));
  };

  // Group categories for display (Main categories and their subcategories)
  const mainCategories = categories.filter(c => !c.parent_id);

  return (
    <div className="space-y-8">
      <div>
        <h3 className="font-semibold text-gray-900 mb-4">Categories</h3>
        {mainCategories.length === 0 ? (
          <p className="text-sm text-gray-500">No categories available.</p>
        ) : (
          <div className="space-y-4">
            {mainCategories.map(mainCat => {
              const subCats = categories.filter(c => c.parent_id === mainCat.id);
              return (
                <div key={mainCat.id} className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <Checkbox
                      id={mainCat.name}
                      checked={filters.category.includes(mainCat.name)}
                      onCheckedChange={() => handleCategoryChange(mainCat.name)}
                    />
                    <label htmlFor={mainCat.name} className="text-sm font-semibold text-gray-900 cursor-pointer">
                      {mainCat.name}
                    </label>
                  </div>
                  {subCats.length > 0 && (
                    <div className="pl-6 space-y-2">
                      {subCats.map(subCat => (
                        <div key={subCat.id} className="flex items-center space-x-2">
                          <Checkbox
                            id={subCat.name}
                            checked={filters.category.includes(subCat.name)}
                            onCheckedChange={() => handleCategoryChange(subCat.name)}
                          />
                          <label htmlFor={subCat.name} className="text-sm text-gray-600 cursor-pointer">
                            {subCat.name}
                          </label>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      <div>
        <h3 className="font-semibold text-gray-900 mb-4">Price Range</h3>
        <Slider
          value={filters.price}
          onValueChange={handlePriceChange}
          max={10000}
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