SELECT DISTINCT 
    -- Se calcula el hash MD5 de la columna PRODUCT_NAME para generar un identificador único para cada nombre de producto
    md5(PRODUCT_NAME) AS SK_PRODUCT_NAME,  
    
    -- Se selecciona la columna PRODUCT_NAME tal como está, sin modificaciones
    PRODUCT_NAME                             
FROM 
    -- Desde la tabla de productos en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB.CATALOG.PRODUCTS

