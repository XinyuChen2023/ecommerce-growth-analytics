--How do sessions translate into orders and revenue over time?

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_funnel_over_time` AS
WITH sessions AS (
  SELECT
    DATE(date) AS date,
    SUM(sessions) AS sessions
  FROM `ecommerce-475102.shopify_clean.sessions_over_time`
  GROUP BY date
),
orders AS (
  SELECT
    DATE(order_date) AS date,
    SUM(orders) AS orders,
    SUM(revenue) AS revenue
  FROM `ecommerce-475102.shopify_clean.fact_orders_daily`
  GROUP BY date
)
SELECT
  s.date,
  s.sessions,
  o.orders,
  o.revenue,
  SAFE_DIVIDE(o.orders, s.sessions)  AS session_to_order_rate,
  SAFE_DIVIDE(o.revenue, s.sessions) AS revenue_per_session
FROM sessions s
LEFT JOIN orders o USING (date)
ORDER BY s.date;
