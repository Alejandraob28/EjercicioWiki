 SELECT 
    SK_review_id,
    SK_product_id,
    review_date,
    corrected_rating,

FROM {{ref('stg_clients_reviews')}}