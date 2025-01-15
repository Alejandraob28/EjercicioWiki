SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'review_id'
    {{ calculate_md5('CONCAT(customer_id, \' \',product_id)') }} as SK_review_id, 
    
    -- Se selecciona la columna review_id tal como está, sin modificaciones
    review_id

FROM 
    -- Desde la tabla de orders en sales, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('clients', 'reviews') }}
