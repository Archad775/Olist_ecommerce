with source as (
    select *
    from {{ source('oilst', 'product_category_translation') }}
),

renamed as (
    select
        product_category_name as product_category,
        product_category_name_english as product_category_english
    from source
)

select * from renamed