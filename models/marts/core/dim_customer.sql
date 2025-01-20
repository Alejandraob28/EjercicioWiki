 SELECT 
    cc.SK_customer_id,
    clc.SK_location_customers_id,
    cc.first_name,
    cc.last_name,
    cc.phone_number_norm,
    cc.email,
    cc.email_validation

FROM {{ref('stg_clients_customers')}} cc
LEFT JOIN {{ ref("stg_clients_location_customers") }} clc
        ON cc.SK_location_customers_id = clc.SK_location_customers_id
