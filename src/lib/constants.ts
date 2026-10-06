// The ₹2,000 minimum order and the random 1-5% "surprise" cart discount were
// retired on 2026-10-05. Cart discounts now come from the discount_tiers table:
// see src/lib/discounts.ts (storefront) and
// supabase/functions/_shared/pricing.ts (authoritative server pricing).
export {};
