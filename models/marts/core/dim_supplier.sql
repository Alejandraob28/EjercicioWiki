 SELECT 
    SK_supplier_id,
    SK_location_suppliers_id,
    first_name,
    last_name,
    phone_number_norm,
    email,
    email_validation

FROM {{ref('stg_catalog_suppliers')}}