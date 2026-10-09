with source as (
    select *
    from {{ source('oilst', 'products') }}
),

renamed as (
    select
        product_id as product_id,
        product_category_name as product_category,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        case
            when product_category_name is null then 'No Category'
            else 'Category present'
        end as product_category_flag
    from source
)

select * from renamed