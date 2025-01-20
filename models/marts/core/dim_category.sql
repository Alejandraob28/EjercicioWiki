 SELECT 
    SK_category_id,
    category

FROM {{ref('stg_catalog_category_id')}}
