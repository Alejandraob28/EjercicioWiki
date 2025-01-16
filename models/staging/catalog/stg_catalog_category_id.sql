SELECT DISTINCT 
    -- Uso de la macro 'calculate_md5' para calcular el hash MD5 de la columna 'category'
    {{ calculate_md5('category') }} as SK_category_id,  
    
    -- Se selecciona la columna CATEGORY tal como está, sin modificaciones
    category

FROM 
    -- Desde la tabla de productos en el catálogo, en la base de datos ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB
    {{ source('catalog', 'products') }}
