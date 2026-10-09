with source as (

    select * from {{ source('oilst', 'order_items') }}

),

renamed as (
    select 
        concat(order_id, '_', order_item_id) as order_item_transaction_id,
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date as shipment_deadline,
        price,
        freight_value from source
)

select * from renamed