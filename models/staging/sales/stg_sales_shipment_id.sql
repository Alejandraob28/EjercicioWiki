SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'shipment_id'
    {{ calculate_md5('CONCAT(order_id, \' \',tracking_number)') }} as SK_shipment_id,  
    
    -- Se selecciona la columna shipment_id tal como está, sin modificaciones
    shipment_id

FROM 
    -- Desde la tabla de shipment en sales, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('sales', 'shipments') }}
