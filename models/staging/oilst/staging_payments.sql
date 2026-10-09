with source as (

    select * from {{ source('oilst', 'order_payments') }}

),

renamed as (

    select 
        concat(order_id, '_', payment_sequential) as order_payment_transaction_id,
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value as payment_amount
    from source

)

select * from renamed