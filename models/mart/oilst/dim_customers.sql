with customers as (
    select * from {{ ref('staging_customers')}}
),

full_states as (
    select * from {{ ref('full_states') }}
)
select
    c.customer_transaction_id,
    c.customer_id,
    c.customer_zip_code,
    c.customer_city,
    fs.state_name as customer_state
from customers c join full_states fs on c.customer_state = fs.state_abbr