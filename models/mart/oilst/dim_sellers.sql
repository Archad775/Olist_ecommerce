with sellers as (
    select * from {{ ref('staging_sellers') }}
),

full_states as (
    select * from {{ ref('full_states') }}
)

select
    s.seller_id,
    s.seller_zip_code,
    s.seller_city,
    s.seller_state as seller_state_abbr,
    fs.state_name as seller_state
from sellers s
left join full_states fs on s.seller_state = fs.state_abbr