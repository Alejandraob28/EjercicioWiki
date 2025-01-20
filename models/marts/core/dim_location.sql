SELECT 
    SK_location_customers_id,
    street, 
    city, 
    state
FROM {{ ref('stg_clients_customers') }}

UNION

SELECT 
    SK_location_suppliers_id,
    street, 
    city, 
    state
FROM {{ ref('stg_catalog_suppliers') }}



