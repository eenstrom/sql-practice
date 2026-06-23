select
    country,
    count(*) as order_count,
    round(sum(amount), 2) as total_revenue,
    round(avg(amount), 2) as avg_order_value
from {{ ref('int_orders_enriched') }}
where status = 'completed'
group by country
order by total_revenue desc
