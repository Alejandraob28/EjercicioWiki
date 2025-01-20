SELECT 
    SK_product_id,
    SK_supplier_id,
    SK_category_id,
    price_corrected

FROM {{ref('stg_catalog_products')}}