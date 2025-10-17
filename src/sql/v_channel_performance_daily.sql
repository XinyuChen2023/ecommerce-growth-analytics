--Which traffic channels drive the most sessions, orders, and revenue?

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_channel_performance_daily` AS
WITH sessions AS (
  SELECT
    DATE(date) AS date,
    LOWER(TRIM(referrer_source)) AS channel,
    SUM(sessions) AS sessions
  FROM `ecommerce-475102.shopify_clean.sessions_over_time`
  GROUP BY date, channel
),
orders AS (
  SELECT
    DATE(created_at) AS date,
    LOWER(TRIM(source)) AS channel,
    COUNTIF(LOWER(financial_status) = 'paid' AND cancelled_at IS NULL) AS orders,
    SUM(IF(LOWER(financial_status) = 'paid' AND cancelled_at IS NULL, total, 0)) AS revenue
  FROM `ecommerce-475102.shopify_clean.orders`
  GROUP BY date, channel
)
SELECT
  COALESCE(s.date, o.date) AS date,
  COALESCE(s.channel, o.channel, 'unknown') AS channel,
  s.sessions,
  o.orders,
  o.revenue,
  SAFE_DIVIDE(o.orders, s.sessions)  AS conv_rate,
  SAFE_DIVIDE(o.revenue, s.sessions) AS rev_per_session
FROM sessions s
FULL OUTER JOIN orders o USING (date, channel)
ORDER BY date DESC, channel;
