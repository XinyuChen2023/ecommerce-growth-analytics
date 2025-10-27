-- =============================================
-- v_product_trends_daily.sql
-- Purpose: Daily trend of product sales for reporting period
-- Input: ecommerce-475102.shopify_clean.sales_by_product
-- Report date range: 2024-10-01 to 2025-09-30
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_product_trends_daily` AS
SELECT
  DATE '2025-09-30' AS report_date,  -- export/report end date
  LOWER(TRIM(product_name)) AS product_name,
  LOWER(TRIM(variant_title)) AS variant_title,
  LOWER(TRIM(sku)) AS sku,
  SUM(units_sold) AS units_sold,
  SUM(net_sales)  AS net_sales,
  SAFE_DIVIDE(SUM(net_sales), SUM(units_sold)) AS avg_unit_price
FROM `ecommerce-475102.shopify_clean.sales_by_product`
GROUP BY product_name, variant_title, sku
ORDER BY net_sales DESC;

