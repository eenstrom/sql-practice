select
    customer_id,
    customer_name,
    city,
    country,
    signup_date
from {{ ref('stg_customers') }}
