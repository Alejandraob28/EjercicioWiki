 SELECT 
    cp.SK_category_id,
    cci.category

FROM {{ref('stg_catalog_products')}} cp
LEFT JOIN {{ref('stg_catalog_category_id')}} cci
    ON cp.SK_category_id = cci.SK_category_id
