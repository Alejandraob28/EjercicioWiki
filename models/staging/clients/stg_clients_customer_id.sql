SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la concatenación de 'first_name' y 'last_name'
    {{ calculate_md5('CONCAT(first_name, \' \', last_name, \' \',phone_number, \' \',address)') }} AS SK_customer_id,
    
    -- Se selecciona la columna customer_id tal como está, sin modificaciones
    customer_id

FROM 
    -- Desde la tabla de customers en clientes, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('clients', 'customers') }}
