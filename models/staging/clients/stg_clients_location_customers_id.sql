SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'address', que se va a añadir
    {{ calculate_md5('CONCAT(address)') }} AS SK_location_customers_id,
    
    -- Se selecciona la columna supplier_id tal como está, sin modificaciones
    address

FROM 
    -- Desde la tabla de suppliers en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('clients', 'customers') }}
