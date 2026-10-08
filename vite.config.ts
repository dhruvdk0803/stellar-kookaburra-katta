import { defineConfig } from "vite";
import dyadComponentTagger from "@dyad-sh/react-vite-component-tagger";
import react from "@vitejs/plugin-react-swc";
import path from "path";

export default defineConfig(() => ({
  server: {
    host: "::",
    port: 8080,
  },
  plugins: [dyadComponentTagger(), react()],
  build: {
    rollupOptions: {
      output: {
        // Stable vendor groups: they change rarely, so browsers keep them cached
        // across deploys while the (frequently changing) app code is re-fetched.
        manualChunks(rawId: string) {
          const id = rawId.split("\\").join("/");
          // Rollup's shared CommonJS helper must live in the always-loaded chunk, otherwise the
          // entry ends up importing it from a heavy lazy-only vendor chunk (e.g. charts).
          if (id.includes("commonjsHelpers")) return "vendor-react";
          const m = id.match(/\/node_modules\/((?:@[^/]+\/)?[^/]+)(?=\/)/g);
          if (!m) return undefined;
          // Package name = the last node_modules segment (works with pnpm's nested layout).
          const pkg = m[m.length - 1].slice("/node_modules/".length);
          if (["react", "react-dom", "scheduler", "react-router", "react-router-dom", "@remix-run/router", "clsx", "tailwind-merge", "class-variance-authority", "tslib"].includes(pkg)) return "vendor-react";
          if (pkg === "@supabase/supabase-js" || /^@supabase\/(auth|postgrest|realtime|storage|functions)-js$/.test(pkg) || pkg === "@supabase/node-fetch") return "vendor-supabase";
          if (pkg.startsWith("@tanstack/")) return "vendor-query";
          if (pkg === "recharts" || pkg === "recharts-scale" || pkg === "victory-vendor" || pkg.startsWith("d3-")) return "vendor-charts";
          return undefined;
        },
      },
    },
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
}));
