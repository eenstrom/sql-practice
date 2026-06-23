-- 01_basics.sql — SELECT, filtering, sorting, limiting

-- Preview all customers
SELECT * FROM customers;

-- Customers in Sweden
SELECT name, city, signup_date
FROM customers
WHERE country = 'Sweden';

-- Orders over 100 EUR, most recent first
SELECT order_id, product, amount, order_date
FROM orders
WHERE amount > 100
ORDER BY order_date DESC;

-- Top 5 highest-value orders
SELECT product, category, amount
FROM orders
ORDER BY amount DESC
LIMIT 5;
