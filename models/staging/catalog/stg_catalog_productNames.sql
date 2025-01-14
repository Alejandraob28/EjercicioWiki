SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'product_name'
    {{ calculate_md5('product_name') }} AS SK_productName,
    
    -- Se selecciona la columna PRODUCT_NAME tal como está, sin modificaciones
    product_name

FROM 
    -- Desde la tabla de productos en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('catalog', 'products') }}
