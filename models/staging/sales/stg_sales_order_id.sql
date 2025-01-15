SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'order_id'
    {{ calculate_md5('order_id') }} as SK_order_id,  
    
    -- Se selecciona la columna order_id tal como está, sin modificaciones
    order_id

FROM 
    -- Desde la tabla de orders en sales, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('sales', 'orders') }}