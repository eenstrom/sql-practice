-- 03_aggregations.sql — GROUP BY, window functions, CTEs

-- Revenue by product category
SELECT
    category,
    COUNT(*) AS orders,
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value
FROM orders
WHERE status = 'completed'
GROUP BY category
ORDER BY total_revenue DESC;

-- Monthly order trend
SELECT
    DATE_TRUNC('month', order_date::DATE) AS month,
    COUNT(*) AS orders,
    SUM(amount) AS revenue
FROM orders
WHERE status = 'completed'
GROUP BY 1
ORDER BY 1;

-- Running total revenue with window functions
WITH daily_revenue AS (
    SELECT
        order_date::DATE AS day,
        SUM(amount) AS daily_revenue
    FROM orders
    WHERE status = 'completed'
    GROUP BY 1
)
SELECT
    day,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY day) AS running_total
FROM daily_revenue
ORDER BY day;

-- Rank customers by total spend
SELECT
    c.name,
    SUM(o.amount) AS total_spend,
    RANK() OVER (ORDER BY SUM(o.amount) DESC) AS spend_rank
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name
ORDER BY spend_rank;
