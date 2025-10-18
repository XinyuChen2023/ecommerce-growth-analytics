-- =============================================
-- v_channel_performance_daily
-- Purpose: Daily traffic performance by source
-- Input:  ecommerce-475102.shopify_clean.v_orders_by_traffic_source
-- Output: one row per (date, traffic_source)
-- Notes: merges null/invalid/(not set) into 'other' for reporting
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_channel_performance_daily` AS
SELECT
  date,
  CASE
    WHEN traffic_source IS NULL THEN 'other'
    WHEN LOWER(traffic_source) IN ('unknown','invalid','(not set)','not_set','') THEN 'other'
    ELSE traffic_source
  END AS traffic_source,
  SUM(sessions) AS total_sessions,
  SUM(orders)   AS total_orders,
  SUM(revenue)  AS total_revenue,
  SAFE_DIVIDE(SUM(orders),  SUM(sessions)) AS conversion_rate,
  SAFE_DIVIDE(SUM(revenue), SUM(sessions)) AS revenue_per_session
FROM `ecommerce-475102.shopify_clean.v_orders_by_traffic_source`
GROUP BY date, traffic_source
ORDER BY date DESC, traffic_source;
