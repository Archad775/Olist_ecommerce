with source as (
    select *
    from {{ source('oilst', 'customers') }}
),
renamed as (
    select
        customer_id as customer_transaction_id,
        customer_unique_id as customer_id,
        customer_zip_code_prefix as customer_zip_code,
        customer_city,
        customer_state
    from source
)
select * from renamed