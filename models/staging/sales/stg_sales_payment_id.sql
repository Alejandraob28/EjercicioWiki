SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'payment_id'
    {{ calculate_md5('CONCAT(order_id, \' \',payment_method)') }} AS SK_payment_id,
    
    -- Se selecciona la columna payment_id tal como está, sin modificaciones
    payment_id

FROM 
    -- Desde la tabla de orders en sales, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('sales', 'payment') }}