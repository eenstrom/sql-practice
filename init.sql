-- Load CSV data into DuckDB tables (run once to initialize the database)
CREATE OR REPLACE TABLE customers AS
SELECT * FROM read_csv_auto('data/customers.csv');

CREATE OR REPLACE TABLE orders AS
SELECT * FROM read_csv_auto('data/orders.csv');

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;
