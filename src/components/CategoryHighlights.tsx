import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { supabase } from '@/integrations/supabase/client';

const CategoryHighlights = () => {
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCategories = async () => {
      // Fetch top-level categories (no parent_id)
      const { data } = await supabase
        .from('categories')
        .select('*')
        .is('parent_id', null)
        .limit(4);
        
      if (data) setCategories(data);
      setLoading(false);
    };
    
    fetchCategories();
  }, []);

  if (loading) {
    return (
      <section className="py-20 px-4 bg-white flex justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </section>
    );
  }

  if (categories.length === 0) return null;

  return (
    <section className="py-20 px-4 bg-white">
      <div className="max-w-7xl mx-auto">
        <h2 className="text-4xl font-playfair font-bold text-center text-gray-900 mb-16">Explore Our Collections</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {categories.map((category, index) => (
            <div key={category.id} className="group relative overflow-hidden rounded-2xl bg-gray-100 aspect-square md:aspect-[4/3]">
              <div
                className="absolute inset-0 bg-cover bg-center opacity-60 group-hover:opacity-40 transition-opacity duration-300"
                style={{ 
                  backgroundImage: index % 2 === 0 
                    ? "url('/images/sunmica-materials.png')" 
                    : "url('/images/panels-materials.png')",
                  backgroundColor: '#111827' // Fallback color
                }}
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
              <div className="relative p-8 text-white h-full flex flex-col justify-end">
                <h3 className="text-3xl font-playfair font-bold mb-4">{category.name}</h3>
                <Link to={`/shop?category=${category.name}`}>
                  <Button variant="ghost" className="border-white hover:bg-white/20 rounded-full text-white">
                    Explore {category.name}
                    <ArrowRight className="ml-2 h-5 w-5 group-hover:translate-x-1 transition-transform" />
                  </Button>
                </Link>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default CategoryHighlights;