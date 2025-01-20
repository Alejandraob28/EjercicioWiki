 SELECT 
    SK_customer_id,
    SK_location_customers_id,
    first_name,
    last_name,
    phone_number_norm,
    email,
    email_validation

FROM {{ref('stg_clients_customers')}}
