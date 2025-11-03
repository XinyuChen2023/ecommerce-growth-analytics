-- =============================================
-- v_customer_cohort.sql
-- Purpose: Cohort retention & revenue by months since first purchase
-- Source : ecommerce-475102.shopify_clean.orders
-- Notes  : Uses email as customer_id. Only paid, non-cancelled orders.
-- =============================================

CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_customer_cohort` AS
WITH orders AS (
  SELECT
    LOWER(TRIM(email))              AS customer_id,          -- identifier
    DATE(created_at)                AS order_date,
    DATE_TRUNC(DATE(created_at), MONTH) AS order_month,
    CAST(total AS FLOAT64)          AS order_revenue
  FROM `ecommerce-475102.shopify_clean.orders`
  WHERE email IS NOT NULL
    AND financial_status = 'paid'
    AND cancelled_at IS NULL
),

-- First purchase per customer → defines the cohort
first_purchase AS (
  SELECT
    customer_id,
    MIN(order_date)                               AS first_order_date,
    DATE_TRUNC(MIN(order_date), MONTH)            AS cohort_month
  FROM orders
  GROUP BY customer_id
),

-- Attach cohort to every order and compute months since cohort
orders_with_cohort AS (
  SELECT
    o.customer_id,
    fp.cohort_month,
    o.order_month,
    DATE_DIFF(o.order_month, fp.cohort_month, MONTH) AS months_since,
    o.order_revenue
  FROM orders o
  JOIN first_purchase fp
    ON o.customer_id = fp.customer_id
),

-- Cohort size = customers who placed at least one order in month 0
cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_size
  FROM orders_with_cohort
  WHERE months_since = 0
  GROUP BY cohort_month
),

-- Activity and revenue per cohort x months_since
cohort_activity AS (
  SELECT
    cohort_month,
    months_since,
    COUNT(DISTINCT customer_id)        AS active_customers,
    COUNT(*)                           AS orders,
    SUM(order_revenue)                 AS revenue
  FROM orders_with_cohort
  GROUP BY cohort_month, months_since
)

SELECT
  ca.cohort_month,                                   -- e.g., 2025-03-01
  ca.months_since,                                   -- 0,1,2,...
  cs.cohort_size,
  ca.active_customers,
  SAFE_DIVIDE(ca.active_customers, cs.cohort_size)   AS retention_rate,      -- % of original cohort active this month
  ca.orders,
  ca.revenue,
  SAFE_DIVIDE(ca.revenue, ca.orders)                 AS aov,                 -- avg order value in this cell
  SAFE_DIVIDE(ca.revenue, ca.active_customers)       AS revenue_per_active_customer,
  SAFE_DIVIDE(ca.revenue, cs.cohort_size)            AS revenue_per_original_customer
FROM cohort_activity ca
JOIN cohort_size cs
  ON ca.cohort_month = cs.cohort_month
ORDER BY cohort_month, months_since;
