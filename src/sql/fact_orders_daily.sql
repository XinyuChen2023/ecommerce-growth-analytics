-- ===========================================
--  FACT_ORDERS_DAILY
--  Description: Aggregates paid, not-cancelled Shopify orders into daily metrics.
--  Source Table: ecommerce-475102.shopify_clean.orders  (line-item level)
--  Output View : ecommerce-475102.shopify_clean.fact_orders_daily
--  Last updated: 2025-10-14
-- ===========================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.fact_orders_daily` AS
WITH order_lines AS (
  SELECT
    name,                                        -- order id (e.g., #3317)
    TIMESTAMP_TRUNC(created_at, DAY) AS order_date,
    currency,
    total,                                       -- repeated on each line; we dedupe later
    lineitem_quantity,
    financial_status,
    cancelled_at
  FROM `ecommerce-475102.shopify_clean.orders`
  WHERE financial_status = 'paid'
    AND cancelled_at IS NULL
),
order_level AS (
  -- one row per order id + date
  SELECT
    name,
    order_date,
    ANY_VALUE(currency) AS currency,
    ANY_VALUE(total)    AS order_total,          -- safe because total is identical across lines
    SUM(lineitem_quantity) AS units_in_order
  FROM order_lines
  GROUP BY name, order_date
)
SELECT
  order_date,
  COUNT(*) AS orders,
  SUM(order_total) AS revenue,
  SUM(units_in_order) AS units,
  SAFE_DIVIDE(SUM(order_total), COUNT(*)) AS aov
FROM order_level
GROUP BY order_date
ORDER BY order_date;


