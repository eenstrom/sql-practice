select
    order_id,
    customer_id,
    customer_name,
    city,
    country,
    order_date,
    product,
    category,
    amount
from {{ ref('int_orders_enriched') }}
where status = 'completed'
