import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

export default function ScrollToTop() {
  const { pathname } = useLocation();

  useEffect(() => {
    // The browser's own scroll restoration fights the SPA on Back: it reapplies
    // the saved offset while the page is still in its short loading state,
    // clamps it to the bottom, and the position sticks once the content
    // renders. Disable it so this component owns all scrolling.
    if ('scrollRestoration' in history) history.scrollRestoration = 'manual';
    window.scrollTo(0, 0);
  }, [pathname]);

  return null;
}