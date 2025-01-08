WITH RankedProducts AS (
    SELECT
        -- Conversión de la fecha de Fivetran al formato deseado (fuera de la cláusula PARTITION BY)
        TO_CHAR(TO_TIMESTAMP_TZ(_fivetran_synced), 'DD-Mon-YYYY HH24:MI:SS') AS FIVETRAN_SYNCED_CORRECTED,
        
        -- Asignación de un número de fila por cada grupo de registros duplicados
        ROW_NUMBER() OVER (
            PARTITION BY 
                product_id,  -- El identificador del producto
                product_name,  -- Nombre del producto
                CATEGORY,  -- Categoría del producto
                FIVETRAN_SYNCED_CORRECTED,  -- Fecha de sincronización (ya convertida)
                price  -- Precio del producto
            ORDER BY product_id  -- El orden no afecta directamente, solo se necesita para asignar el número de fila
        ) AS _ROW,  -- Número de fila asignado para cada grupo de duplicados
        
        -- Redondeo del precio según las condiciones
        CASE 
            WHEN MOD(price * 100, 1) != 0 THEN ROUND(price, 2)  -- Redondeo a 2 decimales si tiene más de 2 decimales
            WHEN MOD(price * 10, 1) != 0 THEN TO_CHAR(price, 'FM9999999990.00')  -- Si tiene 1 decimal, se agrega un 0
            ELSE price  -- Si tiene 2 decimales, se deja el precio tal cual
        END AS PRICE_CORRECTED,
        
        -- Hash de la categoría
        MD5(CATEGORY) AS HASH_CATEGORY,
        
        -- Hash del nombre del producto
        MD5(product_name) AS HASH_PRODUCTNAME,
        
        -- Incluir el supplier_id tal cual está
        supplier_id
    FROM 
        -- Tabla de productos desde la base de datos
        ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB.CATALOG.PRODUCTS
)
-- Selección final de los registros únicos
SELECT *
FROM RankedProducts
WHERE _ROW = 1  -- Se selecciona solo el primer registro de cada grupo de duplicados
