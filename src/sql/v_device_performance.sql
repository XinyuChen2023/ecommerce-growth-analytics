-- =============================================
-- v_device_performance.sql
-- Purpose: Analyze traffic performance by device type (sessions only)
-- Orders and revenue are country-level only, so this focuses on session data.
-- =============================================
CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_device_performance_weekly` AS
SELECT
  DATE_TRUNC(SAFE_CAST(date AS DATE), WEEK(MONDAY)) AS week_start,
  LOWER(TRIM(device_type))     AS device_type,
  LOWER(TRIM(referrer_source)) AS traffic_source,
  SUM(sessions)                AS total_sessions
FROM `ecommerce-475102.shopify_clean.sessions_over_time`
WHERE device_type IS NOT NULL
  AND SAFE_CAST(date AS DATE) IS NOT NULL
GROUP BY week_start, device_type, traffic_source
ORDER BY week_start DESC, total_sessions DESC;

