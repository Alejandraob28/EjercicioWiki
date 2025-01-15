SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'product_name', que va a constituir el product_id
    {{ calculate_md5('CONCAT(product_id, \' \',product_name)') }} AS SK_product_id,
    
    -- Se selecciona la columna PRODUCT_id tal como está, sin modificaciones
    product_id

FROM 
    -- Desde la tabla de productos en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('catalog', 'products') }}
