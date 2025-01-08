SELECT DISTINCT 
    -- Se calcula el hash MD5 de la columna CATEGORY para generar un identificador único para cada categoría
    md5(CATEGORY) AS SK_CATEGORY_PRODUCTS,  
    
    -- Se selecciona la columna CATEGORY tal como está, sin modificaciones
    CATEGORY                               
FROM 
    -- Desde la tabla de productos en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB.CATALOG.PRODUCTS
