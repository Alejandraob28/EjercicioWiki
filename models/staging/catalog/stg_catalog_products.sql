WITH RankedProducts AS (
    SELECT
        
        -- Uso de la macro para asignar el número de fila y eliminar duplicados
        {{ eliminate_duplicates([
            'cp._fivetran_synced',  
            'cp.price', 
            'cp.product_id', 
            'cp.category', 
            'cp.product_name', 
            'cs.supplier_id' 
        ]) }} AS _row,  -- Asignación de número de fila por duplicado

        -- Uso de la macro para formatear la fecha de sincronización de Fivetran
        {{ format_fivetran_date('cp._fivetran_synced') }} AS fivetran_synced_corrected,  -- Usando el alias de la tabla productos

        -- Incluir el hash del product_name
        {{ calculate_md5('CONCAT(cp.product_id, \' \',cp.product_name)') }} AS product_id,  -- Usando el alias de la tabla productos
        
        -- Uso de la macro para redondear el precio
        {{ round_price('cp.price') }} AS price_corrected,  -- Usando el alias de la tabla productos

        -- Uso de la macro para calcular el hash de la categoría
        {{ calculate_md5('cp.category') }} AS category_id,  -- Usando el alias de la tabla productos
        
        -- Incluir el hash de supplier_name de la tabla suppliers
        {{ calculate_md5('CONCAT(cs.supplier_name, \' \',cs.address)') }} AS supplier_id  -- Usando el alias de la tabla proveedores
        
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('catalog', 'products') }} cp
    LEFT JOIN {{ source('catalog','suppliers') }} cs
        ON cp.supplier_id = cs.supplier_id  -- Asegúrate de que la columna product_id sea la misma en ambas tablas
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    product_id,
    supplier_id,
    price_corrected,
    category_id
FROM RankedProducts
WHERE _row = 1  -- Se selecciona solo el primer registro de cada grupo de duplicados
ORDER BY product_id ASC
