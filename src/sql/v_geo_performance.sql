-- =============================================
-- v_geo_performance.sql
-- Purpose: Country-level sessions + orders + revenue
-- Fixes double-counting caused by mismatched granularity
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_geo_performance` AS
WITH sessions_country AS (
  SELECT
    LOWER(TRIM(country)) AS country_name,
    SUM(sessions) AS total_sessions
  FROM `ecommerce-475102.shopify_clean.sessions_over_time`
  GROUP BY country_name
),

orders_country AS (
  SELECT
    LOWER(TRIM(shipping_country)) AS country_code,
    COUNT(DISTINCT name) AS total_orders,
    SUM(total) AS total_revenue
  FROM `ecommerce-475102.shopify_clean.orders`
  WHERE financial_status = 'paid' AND cancelled_at IS NULL
  GROUP BY country_code
),

country_map AS (
  SELECT * FROM UNNEST([
    STRUCT('united states' AS country_name, 'us' AS country_code),
    STRUCT('canada' AS country_name, 'ca' AS country_code),
    STRUCT('australia' AS country_name, 'au' AS country_code),
    STRUCT('united kingdom' AS country_name, 'gb' AS country_code)
  ])
)

SELECT
  COALESCE(o.country_code, cm.country_code, s.country_name) AS country,
  s.total_sessions,
  COALESCE(o.total_orders, 0) AS total_orders,
  COALESCE(o.total_revenue, 0) AS total_revenue,
  SAFE_DIVIDE(o.total_orders, s.total_sessions) AS conversion_rate,
  SAFE_DIVIDE(o.total_revenue, s.total_sessions) AS revenue_per_session
FROM sessions_country s
LEFT JOIN country_map cm
  ON s.country_name = cm.country_name
LEFT JOIN orders_country o
  ON o.country_code = cm.country_code OR o.country_code = s.country_name
ORDER BY total_revenue DESC, total_sessions DESC;
