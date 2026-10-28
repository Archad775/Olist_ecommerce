with order_items as (
    select * from {{ ref('staging_order_items') }}
)

select 
    order_item_transaction_id
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipment_deadline,
    price,
    freight_value,
    price + freight_value as total_item_value
from order_items