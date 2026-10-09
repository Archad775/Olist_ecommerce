with reviews as (

    select * from {{ ref('staging_reviews') }}

)

select 
    order_review_transaction_id,
    order_id,
    review_id,
    review_score,
    review_creation_date,
    review_answer_timestamp

from reviews