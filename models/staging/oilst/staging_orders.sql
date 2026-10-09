with source as (

    select * from {{ source('oilst', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id as customer_transaction_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at as order_approval_timestamp,
        order_delivered_carrier_date as order_shipping_timestamp,
        order_delivered_customer_date as delivery_timestamp,
        order_estimated_delivery_date,
        case
            when order_status in ('approved','delivered','shipped') and order_approved_at is null then TRUE
            else FALSE
        end as is_missing_approval,
        case
            when order_status = 'delivered' and order_delivered_customer_date is null then TRUE
            else FALSE
        end as is_missing_delivery_date,

        case 
            when order_status in ('shipped', 'delivered') and order_delivered_carrier_date is null then TRUE
            ELSE FALSE
        end as is_missing_shipping_date,
        case
            when order_approved_at > order_delivered_carrier_date then TRUE
            else FALSE
        end as is_carrier_before_approval,
        case
            when order_delivered_carrier_date > order_delivered_customer_date then TRUE
            else FALSE
        end as is_delivered_before_shipping,
        case
            when order_purchase_timestamp > order_approved_at then TRUE
            ELSE FALSE
        end as is_approval_before_purchase

    from source

)

select * from renamed


