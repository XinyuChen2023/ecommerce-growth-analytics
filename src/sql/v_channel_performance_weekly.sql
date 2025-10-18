-- =============================================
-- v_channel_performance_weekly.sql
-- Purpose: Weekly rollup of traffic and order performance
-- Input:   v_channel_performance_daily
-- Output:  one row per (week, traffic_source)
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_channel_performance_weekly` AS
SELECT
  FORMAT_DATE('%G-W%V', DATE(date)) AS week,   -- ISO week format like '2025-W02'
  traffic_source,
  SUM(total_sessions) AS weekly_sessions,
  SUM(total_orders)   AS weekly_orders,
  SUM(total_revenue)  AS weekly_revenue,
  SAFE_DIVIDE(SUM(total_orders),  SUM(total_sessions)) AS conversion_rate,
  SAFE_DIVIDE(SUM(total_revenue), SUM(total_sessions)) AS revenue_per_session
FROM `ecommerce-475102.shopify_clean.v_channel_performance_daily`
GROUP BY week, traffic_source
ORDER BY week DESC, traffic_source;
