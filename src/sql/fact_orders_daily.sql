-- Fact table for daily order aggregations
-- This SQL file contains queries to create daily order fact tables

SELECT 
    DATE(created_at) as order_date,
    COUNT(*) as total_orders,
    SUM(total_price) as total_revenue,
    AVG(total_price) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY order_date DESC;

