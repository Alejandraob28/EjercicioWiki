SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'supplier_name', que va a constituir el supplier_id
    {{ calculate_md5('CONCAT(supplier_id, \' \',supplier_name)') }} AS SK_supplier_id,
    
    -- Se selecciona la columna supplier_id tal como está, sin modificaciones
    supplier_id

FROM 
    -- Desde la tabla de suppliers en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('catalog', 'suppliers') }}
