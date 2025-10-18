-- =============================================
-- v_channel_performance_monthly.sql
-- Purpose: Monthly rollup of traffic and order performance
-- Input:   v_channel_performance_daily
-- Output:  one row per (month, traffic_source)
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_channel_performance_monthly` AS
SELECT
  FORMAT_DATE('%Y-%m', DATE(date)) AS month,   -- Format like '2025-01'
  traffic_source,
  SUM(total_sessions) AS monthly_sessions,
  SUM(total_orders)   AS monthly_orders,
  SUM(total_revenue)  AS monthly_revenue,
  SAFE_DIVIDE(SUM(total_orders),  SUM(total_sessions)) AS conversion_rate,
  SAFE_DIVIDE(SUM(total_revenue), SUM(total_sessions)) AS revenue_per_session
FROM `ecommerce-475102.shopify_clean.v_channel_performance_daily`
GROUP BY month, traffic_source
ORDER BY month DESC, traffic_source;
