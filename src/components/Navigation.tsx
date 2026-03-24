import React, { useState, useEffect, useRef } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Search, Heart, ShoppingCart, User, Menu, ChevronDown, ChevronUp, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from '@/components/ui/dropdown-menu';
import { Input } from '@/components/ui/input';
import { Sheet, SheetContent, SheetTrigger, SheetHeader, SheetTitle } from '@/components/ui/sheet';
import { useCart } from '@/contexts/CartContext';
import { supabase } from '@/integrations/supabase/client';

const navItems = [
  { label: 'Home', path: '/' },
  { label: 'Projects / Inspiration', path: '/projects' },
  { label: 'About Us', path: '/about' },
  { label: 'Blog / Ideas', path: '/blog' },
  { label: 'Contact', path: '/contact' },
];

const Navigation = () => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isMobileShopOpen, setIsMobileShopOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<any[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  
  // Dynamic Categories State
  const [shopCategories, setShopCategories] = useState<{ [key: string]: any[] }>({});
  const [loadingCategories, setLoadingCategories] = useState(true);
  
  const searchRef = useRef<HTMLDivElement>(null);
  const { cartCount } = useCart();
  const navigate = useNavigate();

  // Fetch Categories from Database
  useEffect(() => {
    const fetchCategories = async () => {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('name');
        
      if (!error && data) {
        const mainCats = data.filter(c => !c.parent_id);
        const grouped: { [key: string]: any[] } = {};
        
        mainCats.forEach(mc => {
          grouped[mc.name] = data.filter(c => c.parent_id === mc.id);
        });
        
        setShopCategories(grouped);
      }
      setLoadingCategories(false);
    };
    
    fetchCategories();
  }, []);

  // Handle click outside to close search dropdown
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (searchRef.current && !searchRef.current.contains(event.target as Node)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Live Search Effect
  useEffect(() => {
    const searchProducts = async () => {
      if (searchQuery.trim().length < 2) {
        setSearchResults([]);
        setIsSearching(false);
        return;
      }

      setIsSearching(true);
      const { data, error } = await supabase
        .from('products')
        .select('id, name, image_url, images, price')
        .ilike('name', `%${searchQuery}%`)
        .eq('is_active', true)
        .limit(5);

      if (!error && data) {
        setSearchResults(data);
      }
      setIsSearching(false);
    };

    const debounceTimer = setTimeout(searchProducts, 300);
    return () => clearTimeout(debounceTimer);
  }, [searchQuery]);

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate('/shop', { state: { search: searchQuery } });
      setShowDropdown(false);
      if (isMobileMenuOpen) setIsMobileMenuOpen(false);
    }
  };

  const handleProductClick = (productId: string) => {
    navigate(`/product/${productId}`);
    setSearchQuery('');
    setShowDropdown(false);
    if (isMobileMenuOpen) setIsMobileMenuOpen(false);
  };

  const getProductImage = (product: any) => {
    if (product.images && product.images.length > 0) return product.images[0];
    if (product.image_url) return product.image_url;
    return 'https://via.placeholder.com/40';
  };

  return (
    <nav className="sticky top-0 z-50 w-full bg-white/95 backdrop-blur-md border-b border-gray-200/50 shadow-sm transition-all duration-300">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex justify-between items-center py-3">
          {/* Logo */}
          <Link to="/" className="text-2xl font-bold font-playfair text-gray-900 hover:text-primary transition-colors duration-200">
            Katta Interiors
          </Link>

          {/* Desktop Menu */}
          <div className="hidden lg:flex items-center space-x-4">
            {/* Nav Links */}
            <div className="flex items-center space-x-4">
              {navItems.map((item) => (
                <Link
                  key={item.path}
                  to={item.path}
                  className="text-gray-700 hover:text-primary font-medium transition-all duration-200 px-2 py-2 rounded-md hover:bg-primary/5"
                >
                  {item.label}
                </Link>
              ))}
              {/* Shop Dropdown */}
              <DropdownMenu>
                <DropdownMenuTrigger className="flex items-center space-x-1 text-gray-700 hover:text-primary font-medium px-2 py-2 rounded-md hover:bg-primary/5 transition-all duration-200">
                  <span>Shop</span>
                  <ChevronDown className="h-4 w-4 transition-transform duration-200" />
                </DropdownMenuTrigger>
                <DropdownMenuContent className="w-56 bg-white border border-gray-200 rounded-xl shadow-lg max-h-[80vh] overflow-y-auto">
                  {loadingCategories ? (
                    <div className="p-4 flex justify-center"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
                  ) : Object.keys(shopCategories).length === 0 ? (
                    <div className="p-4 text-sm text-gray-500 text-center">No categories found</div>
                  ) : (
                    Object.entries(shopCategories).map(([categoryName, subcategories]) => (
                      <div key={categoryName} className="p-2">
                        <div 
                          className="font-semibold text-gray-900 px-2 py-1 text-sm border-b border-gray-100 mb-2 cursor-pointer hover:text-primary"
                          onClick={() => navigate(`/shop?category=${categoryName}`)}
                        >
                          {categoryName}
                        </div>
                        {subcategories.map((sub) => (
                          <DropdownMenuItem 
                            key={sub.id} 
                            onClick={() => navigate(`/shop?category=${sub.name}`)}
                            className="cursor-pointer hover:bg-primary/5 rounded-md px-3 py-2 text-sm text-gray-600"
                          >
                            {sub.name}
                          </DropdownMenuItem>
                        ))}
                      </div>
                    ))
                  )}
                  <div className="p-2 border-t border-gray-100 mt-2">
                    <DropdownMenuItem 
                      onClick={() => navigate('/shop')}
                      className="cursor-pointer bg-primary/5 text-primary font-medium justify-center rounded-md px-3 py-2 text-sm"
                    >
                      View All Products
                    </DropdownMenuItem>
                  </div>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>

            {/* Icons & Search */}
            <div className="flex items-center space-x-2">
              <div className="relative flex-shrink-0" ref={searchRef}>
                <form onSubmit={handleSearchSubmit}>
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
                  <Input
                    type="text"
                    placeholder="Search..."
                    value={searchQuery}
                    onChange={(e) => {
                      setSearchQuery(e.target.value);
                      setShowDropdown(true);
                    }}
                    onFocus={() => setShowDropdown(true)}
                    className="pl-10 w-48 lg:w-64 h-10 border-gray-200 focus:border-primary focus:ring-1 focus:ring-primary/20 rounded-full transition-all duration-200 bg-white/80"
                  />
                </form>
                
                {/* Live Search Dropdown */}
                {showDropdown && searchQuery.trim().length >= 2 && (
                  <div className="absolute top-full mt-2 w-full bg-white border border-gray-100 rounded-xl shadow-xl overflow-hidden z-50">
                    {isSearching ? (
                      <div className="p-4 flex justify-center"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
                    ) : searchResults.length > 0 ? (
                      <div className="max-h-80 overflow-y-auto py-2">
                        {searchResults.map((product) => (
                          <div 
                            key={product.id} 
                            onClick={() => handleProductClick(product.id)}
                            className="flex items-center gap-3 p-3 hover:bg-gray-50 cursor-pointer transition-colors"
                          >
                            <img src={getProductImage(product)} alt={product.name} className="w-10 h-10 rounded object-cover border border-gray-100" />
                            <div className="flex-1 min-w-0">
                              <p className="text-sm font-medium text-gray-900 truncate">{product.name}</p>
                              <p className="text-xs font-bold text-primary">₹{product.price}</p>
                            </div>
                          </div>
                        ))}
                        <div 
                          onClick={handleSearchSubmit}
                          className="p-3 text-center text-sm text-primary font-medium hover:bg-primary/5 cursor-pointer border-t border-gray-50"
                        >
                          View all results
                        </div>
                      </div>
                    ) : (
                      <div className="p-4 text-center text-sm text-gray-500">No products found</div>
                    )}
                  </div>
                )}
              </div>

              <Button variant="ghost" size="icon" asChild className="hover:bg-primary/5 rounded-full transition-all duration-200 h-10 w-10 p-0">
                <Link to="/wishlist">
                  <Heart className="h-5 w-5 text-gray-700 hover:text-primary transition-colors duration-200" />
                </Link>
              </Button>
              <Button variant="ghost" size="icon" asChild className="relative hover:bg-primary/5 rounded-full transition-all duration-200 h-10 w-10 p-0">
                <Link to="/cart">
                  <ShoppingCart className="h-5 w-5 text-gray-700" />
                  {cartCount > 0 && (
                    <span className="absolute -top-1 -right-1 bg-primary text-primary-foreground text-xs rounded-full h-5 w-5 flex items-center justify-center font-medium shadow-lg">
                      {cartCount}
                    </span>
                  )}
                </Link>
              </Button>
              <Button variant="ghost" size="icon" asChild className="hover:bg-primary/5 rounded-full transition-all duration-200 h-10 w-10 p-0">
                <Link to="/account">
                  <User className="h-5 w-5 text-gray-700 hover:text-primary transition-colors duration-200" />
                </Link>
              </Button>
            </div>
          </div>

          {/* Mobile Menu Trigger */}
          <div className="lg:hidden flex items-center space-x-2">
            <Button variant="ghost" size="icon" asChild className="relative hover:bg-primary/5 rounded-full transition-all duration-200 h-10 w-10 p-0">
              <Link to="/cart">
                <ShoppingCart className="h-5 w-5 text-gray-700" />
                {cartCount > 0 && (
                  <span className="absolute -top-1 -right-1 bg-primary text-primary-foreground text-xs rounded-full h-5 w-5 flex items-center justify-center font-medium shadow-lg">
                    {cartCount}
                  </span>
                )}
              </Link>
            </Button>
            <Sheet open={isMobileMenuOpen} onOpenChange={setIsMobileMenuOpen}>
              <SheetTrigger asChild>
                <Button variant="ghost" size="icon" className="hover:bg-primary/5 rounded-full transition-all duration-200 h-10 w-10 p-0">
                  <Menu className="h-6 w-6" />
                </Button>
              </SheetTrigger>
              <SheetContent side="right" className="w-full max-w-sm bg-white border-l border-gray-200 p-0 flex flex-col">
                <SheetHeader className="p-4 border-b flex flex-row justify-between items-center space-y-0 text-left">
                  <SheetTitle className="text-lg font-semibold">Menu</SheetTitle>
                  {/* Removed the duplicate custom X button here */}
                </SheetHeader>
                <div className="flex-1 overflow-y-auto p-4">
                  
                  {/* Mobile Search */}
                  <div className="relative mb-6">
                    <form onSubmit={handleSearchSubmit}>
                      <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
                      <Input
                        type="text"
                        placeholder="Search products..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        className="pl-10 border-gray-200 focus:border-primary focus:ring-2 focus:ring-primary/20 rounded-full transition-all duration-200"
                      />
                    </form>
                    {/* Mobile Live Search Results */}
                    {searchQuery.trim().length >= 2 && (
                      <div className="mt-2 bg-white border border-gray-100 rounded-xl shadow-sm overflow-hidden">
                        {isSearching ? (
                          <div className="p-4 flex justify-center"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
                        ) : searchResults.length > 0 ? (
                          <div className="max-h-60 overflow-y-auto py-2">
                            {searchResults.map((product) => (
                              <div 
                                key={product.id} 
                                onClick={() => handleProductClick(product.id)}
                                className="flex items-center gap-3 p-3 hover:bg-gray-50 cursor-pointer"
                              >
                                <img src={getProductImage(product)} alt={product.name} className="w-10 h-10 rounded object-cover" />
                                <div className="flex-1 min-w-0">
                                  <p className="text-sm font-medium text-gray-900 truncate">{product.name}</p>
                                  <p className="text-xs font-bold text-primary">₹{product.price}</p>
                                </div>
                              </div>
                            ))}
                          </div>
                        ) : (
                          <div className="p-4 text-center text-sm text-gray-500">No products found</div>
                        )}
                      </div>
                    )}
                  </div>

                  <div className="flex flex-col space-y-2">
                    {navItems.map((item) => (
                      <Link
                        key={item.path}
                        to={item.path}
                        className="text-gray-700 hover:text-primary hover:bg-primary/5 py-3 px-3 rounded-md transition-all duration-200 text-lg font-medium"
                        onClick={() => setIsMobileMenuOpen(false)}
                      >
                        {item.label}
                      </Link>
                    ))}
                    
                    {/* Mobile Shop Accordion */}
                    <div className="flex flex-col">
                      <button 
                        onClick={() => setIsMobileShopOpen(!isMobileShopOpen)}
                        className="w-full text-left py-3 px-3 rounded-md hover:bg-primary/5 transition-all text-lg font-medium flex justify-between items-center text-gray-700"
                      >
                        <span>Shop</span>
                        {isMobileShopOpen ? <ChevronUp className="h-5 w-5" /> : <ChevronDown className="h-5 w-5" />}
                      </button>
                      
                      {isMobileShopOpen && (
                        <div className="pl-4 pr-2 py-2 space-y-4 bg-gray-50 rounded-lg mt-1">
                          {loadingCategories ? (
                            <div className="p-4 flex justify-center"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
                          ) : Object.keys(shopCategories).length === 0 ? (
                            <div className="p-4 text-sm text-gray-500">No categories found</div>
                          ) : (
                            Object.entries(shopCategories).map(([categoryName, subcategories]) => (
                              <div key={categoryName}>
                                <div 
                                  className="font-semibold text-gray-900 px-3 py-2 text-base border-b border-gray-200 mb-1 cursor-pointer"
                                  onClick={() => {
                                    navigate(`/shop?category=${categoryName}`);
                                    setIsMobileMenuOpen(false);
                                  }}
                                >
                                  {categoryName}
                                </div>
                                <div className="flex flex-col space-y-1">
                                  {subcategories.map((sub) => (
                                    <button
                                      key={sub.id} 
                                      onClick={() => {
                                        navigate(`/shop?category=${sub.name}`);
                                        setIsMobileMenuOpen(false);
                                      }}
                                      className="text-left text-gray-600 hover:text-primary hover:bg-primary/5 px-3 py-2 rounded-md text-sm transition-colors"
                                    >
                                      {sub.name}
                                    </button>
                                  ))}
                                </div>
                              </div>
                            ))
                          )}
                          <button
                            onClick={() => {
                              navigate('/shop');
                              setIsMobileMenuOpen(false);
                            }}
                            className="w-full text-left text-primary font-medium hover:bg-primary/5 px-3 py-2 rounded-md text-sm transition-colors mt-2"
                          >
                            View All Products
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
                <div className="p-4 border-t border-gray-200 grid grid-cols-2 gap-4">
                  <Button variant="outline" asChild className="flex-col h-auto py-3">
                    <Link to="/wishlist" onClick={() => setIsMobileMenuOpen(false)}>
                      <Heart className="h-5 w-5 mb-1" />
                      Wishlist
                    </Link>
                  </Button>
                  <Button variant="outline" asChild className="flex-col h-auto py-3">
                    <Link to="/account" onClick={() => setIsMobileMenuOpen(false)}>
                      <User className="h-5 w-5 mb-1" />
                      Account
                    </Link>
                  </Button>
                </div>
              </SheetContent>
            </Sheet>
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navigation;