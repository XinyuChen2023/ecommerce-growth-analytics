-- =============================================
-- v_product_performance.sql
-- Purpose: Summarize sales metrics by product and variant
-- Input: ecommerce-475102.shopify_clean.sales_by_product
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_product_performance` AS
SELECT
  LOWER(TRIM(product_name)) AS product_name,
  LOWER(TRIM(variant_title)) AS variant_title,
  LOWER(TRIM(sku)) AS sku,
  SUM(units_sold) AS total_units_sold,
  SUM(gross_sales) AS total_gross_sales,
  SUM(discounts) AS total_discounts,
  SUM(returns) AS total_returns,
  SUM(net_sales) AS total_net_sales,
  SUM(taxes) AS total_taxes,
  SUM(total_sales) AS total_sales,
  SAFE_DIVIDE(SUM(net_sales), SUM(units_sold)) AS avg_unit_price,
  SAFE_DIVIDE(SUM(discounts) * -1, SUM(gross_sales)) AS discount_rate,
  SAFE_DIVIDE(SUM(returns) * -1, SUM(net_sales)) AS return_rate
FROM `ecommerce-475102.shopify_clean.sales_by_product`
GROUP BY product_name, variant_title, sku
ORDER BY total_net_sales DESC;
