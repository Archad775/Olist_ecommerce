with orders as (
    select * from {{ ref('staging_orders') }}
),

order_items_agg as (
    select
        order_id,
        sum(price) as total_price,
        sum(freight_value) as total_freight_value,
        count(order_item_id) as total_items
    from {{ ref('staging_order_items') }}
    group by order_id
),

payments_agg as (
    select
        order_id,
        sum(payment_amount) as total_payment_amount,
        max(payment_installments) as payment_installments
    from {{ ref('staging_payments') }}
    group by order_id
)

select
    o.*,
    oi.total_price,
    oi.total_freight_value,
    oi.total_items,
    p.total_payment_amount,
    p.payment_installments
from orders o
left join order_items_agg oi on o.order_id = oi.order_id
left join payments_agg p on o.order_id = p.order_id