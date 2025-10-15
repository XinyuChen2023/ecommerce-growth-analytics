

-- 1) Daily KPIs with 7-day rolling averages and WoW deltas
CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_daily_performance` AS
WITH base AS (
  SELECT
    DATE(order_date) AS d,
    orders,
    revenue,
    units,
    aov
  FROM `ecommerce-475102.shopify_clean.fact_orders_daily`
),
rolled AS (
  SELECT
    d,
    orders,
    revenue,
    units,
    aov,

    -- 7-day rolling sums
    SUM(revenue) OVER (ORDER BY d ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS revenue_7d,
    SUM(orders)  OVER (ORDER BY d ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS orders_7d,
    SUM(units)   OVER (ORDER BY d ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS units_7d,

    -- 7-day rolling AOV = rolling revenue / rolling orders
    SAFE_DIVIDE(
      SUM(revenue) OVER (ORDER BY d ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),
      NULLIF(SUM(orders) OVER (ORDER BY d ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 0)
    ) AS aov_7d,

    -- Week-over-Week deltas (vs same weekday 7 days prior)
    LAG(revenue, 7) OVER (ORDER BY d) AS revenue_lag_7,
    LAG(orders,  7) OVER (ORDER BY d) AS orders_lag_7,
    LAG(aov,     7) OVER (ORDER BY d) AS aov_lag_7
  FROM base
)
SELECT
  d AS order_date,
  orders,
  revenue,
  units,
  aov,

  revenue_7d,
  orders_7d,
  units_7d,
  aov_7d,

  SAFE_DIVIDE(revenue - revenue_lag_7, NULLIF(revenue_lag_7, 0)) AS revenue_wow_pct,
  SAFE_DIVIDE(orders  - orders_lag_7,  NULLIF(orders_lag_7,  0)) AS orders_wow_pct,
  SAFE_DIVIDE(aov     - aov_lag_7,     NULLIF(aov_lag_7,     0)) AS aov_wow_pct
FROM rolled
ORDER BY order_date;

-- 2) Weekday pattern (useful for spotting weekly seasonality)
CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_weekday_pattern` AS
SELECT
  FORMAT_DATE('%A', DATE(order_date)) AS weekday,
  AVG(revenue) AS avg_revenue,
  AVG(orders)  AS avg_orders,
  AVG(aov)     AS avg_aov
FROM `ecommerce-475102.shopify_clean.fact_orders_daily`
GROUP BY weekday
ORDER BY
  (CASE weekday
     WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
     WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6
     WHEN 'Sunday' THEN 7 END);

-- 3) Last-30-day KPI tiles (single row)
CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_last_30_kpis` AS
WITH last30 AS (
  SELECT *
  FROM `ecommerce-475102.shopify_clean.fact_orders_daily`
  WHERE order_date >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
)
SELECT
  SUM(revenue) AS revenue_last_30d,
  SUM(orders)  AS orders_last_30d,
  SAFE_DIVIDE(SUM(revenue), NULLIF(SUM(orders), 0)) AS aov_last_30d,
  SUM(units)   AS units_last_30d
FROM last30;
