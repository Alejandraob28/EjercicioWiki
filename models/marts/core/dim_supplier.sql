 SELECT 
    cs.SK_supplier_id,
    cls.SK_location_suppliers_id,
    cs.first_name,
    cs.last_name,
    cs.phone_number_norm,
    cs.email,
    cs.email_validation

FROM {{ref('stg_catalog_suppliers')}} cs
LEFT JOIN {{ ref("stg_catalog_location_suppliers") }} cls
        ON cs.SK_location_suppliers_id = cls.SK_location_suppliers_id