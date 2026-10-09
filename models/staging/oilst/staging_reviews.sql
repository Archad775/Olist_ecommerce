with source as (

    select * from {{ source('oilst', 'order_reviews') }}

),

renamed as (

    select 
        concat(order_id, '_', review_id) as order_review_transaction_id,
        order_id,
        review_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp
    from source

)
select * from renamed

