-- 02_joins.sql — INNER JOIN, LEFT JOIN, combining tables

-- Orders with customer name and city
SELECT
    o.order_id,
    c.name AS customer_name,
    c.city,
    o.product,
    o.amount,
    o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- All customers and their order count (including customers with zero orders)
SELECT
    c.name,
    c.country,
    COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.country
ORDER BY order_count DESC;

-- Revenue by country (only customers who placed orders)
SELECT
    c.country,
    SUM(o.amount) AS total_revenue,
    COUNT(o.order_id) AS order_count
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.country
ORDER BY total_revenue DESC;
