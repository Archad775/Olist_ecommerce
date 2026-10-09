with products as (
    select 
    product_id,
    product_category,
    product_photos_qty,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_weight_g,
    product_category_flag,
    product_length_cm * product_height_cm * product_width_cm as product_volume_cm3
    from {{ ref('staging_products') }}
),

product_categories as (
    select 
    product_category,
    product_category_english
    from {{ ref('staging_product_category_translation') }}
)

select 
p.product_id,
p.product_category,
pc.product_category_english,
p.product_photos_qty,
p.product_length_cm,
p.product_height_cm,
p.product_width_cm,
p.product_weight_g,
p.product_volume_cm3,
case
    when product_weight_g < 1000 then 'Light'
    when product_weight_g <= 5000 then 'Medium'
    when product_weight_g <= 20000 then 'Heavy'
    else 'Very Heavy'
end as product_weight_category,
case
    when product_volume_cm3 < 2880 then 'Small'
    when product_volume_cm3 <= 18480 then 'Medium'
    when product_volume_cm3 <= 100000 then 'Large'
    else 'Very Large'
end as product_size_category
from products p 
left join product_categories pc on p.product_category = pc.product_category
