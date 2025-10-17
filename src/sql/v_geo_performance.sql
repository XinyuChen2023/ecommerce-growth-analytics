-- Which countries and cities perform best?
CREATE OR REPLACE VIEW `ecommerce-475102.shopify_clean.v_geo_performance` AS
SELECT
  country,
  city,
  device_type,
  referrer_source,
  SUM(sessions) AS sessions
FROM `ecommerce-475102.shopify_clean.sessions_over_time`
GROUP BY country, city, device_type, referrer_source
ORDER BY sessions DESC;
