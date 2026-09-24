export const formatRupees = (amount: number | string, showPaise = false) =>
  Number(amount).toLocaleString('en-IN', {
    maximumFractionDigits: 2,
    ...(showPaise ? { minimumFractionDigits: 2 } : {}),
  });
