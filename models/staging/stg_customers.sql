select
    customer_id,
    name as customer_name,
    city,
    country,
    cast(signup_date as date) as signup_date
from {{ source('raw', 'customers') }}
