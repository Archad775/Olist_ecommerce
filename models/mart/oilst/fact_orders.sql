with orders as (
    select 
    *,
    total_price + total_freight_value as total_order_value
    from {{ ref('int_order_financials') }}
)

select 
    order_id,
    customer_transaction_id,
    order_status,
    order_purchase_timestamp,
    order_approval_timestamp,
    order_shipping_timestamp,
    delivery_timestamp,
    order_estimated_delivery_date,
    is_missing_delivery_date,
    is_missing_approval,
    is_missing_shipping_date,
    is_approval_before_purchase,
    is_carrier_before_approval,
    is_delivered_before_shipping,
    total_price,
    total_freight_value,
    total_order_value,
    total_items,
    total_payment_amount,
    payment_installments,
    order_shipping_timestamp::date - order_purchase_timestamp::date as operations_days,
    order_approval_timestamp::date - order_purchase_timestamp::date as approval_days,
    delivery_timestamp::date - order_shipping_timestamp::date as logistic_days,
    delivery_timestamp::date - order_purchase_timestamp::date as total_days,
    order_estimated_delivery_date::date - order_purchase_timestamp::date as estimated_days,
    case
        when delivery_timestamp::date < order_estimated_delivery_date::date then 'early'
        when delivery_timestamp::date = order_estimated_delivery_date::date then 'on_time'
        when delivery_timestamp::date > order_estimated_delivery_date::date then 'late'
        else null end as deliverY_timeliness,
    delivery_timestamp::date - order_estimated_delivery_date::date as delivery_delay_days,
    case
    when total_payment_amount is null then 'unpaid'
    when abs(total_payment_amount - total_order_value) <= 0.01 then 'fully_paid'
    when total_payment_amount < total_order_value then 'partially_paid'
    when total_payment_amount > total_order_value then 'overpaid'
    else null
end as payment_status

    
from orders