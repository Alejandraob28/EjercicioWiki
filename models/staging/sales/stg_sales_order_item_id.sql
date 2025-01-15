SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'order_item_id'
    {{ calculate_md5('CONCAT(order_id, \' \',order_item_id, \' \',product_id)') }} AS SK_order_item_id,
    
    
    -- Se selecciona la columna order_item_id tal como está, sin modificaciones
    order_item_id

FROM 
    -- Desde la tabla de order_items en sales, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('sales', 'order_items') }}
