-- =============================================
-- v_orders_by_traffic_source.sql
-- Source-level diagnostic view joining sessions + orders
-- Uses lowercase field names: date, referrer_source
-- Keeps all traffic sources separated (including null/unknown)
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_orders_by_traffic_source` AS
WITH traffic AS (
  SELECT
    date,
    LOWER(TRIM(referrer_source)) AS traffic_source,
    SUM(sessions) AS sessions
  FROM `ecommerce-475102.shopify_clean.sessions_over_time`
  GROUP BY date, traffic_source
),

orders AS (
  SELECT
    DATE(created_at) AS date,
    COUNTIF(LOWER(financial_status) = 'paid' AND cancelled_at IS NULL) AS orders,
    SUM(IF(LOWER(financial_status) = 'paid' AND cancelled_at IS NULL, total, 0)) AS revenue
  FROM `ecommerce-475102.shopify_clean.orders`
  GROUP BY date
)

SELECT
  t.date,
  t.traffic_source,
  t.sessions,
  o.orders,
  o.revenue,
  SAFE_DIVIDE(o.orders, t.sessions)  AS conversion_rate,
  SAFE_DIVIDE(o.revenue, t.sessions) AS revenue_per_session
FROM traffic t
LEFT JOIN orders o USING (date)
ORDER BY t.date DESC, t.traffic_source;
