WITH RankedProducts AS (
    SELECT
        
        -- Uso de la macro para asignar el número de fila y eliminar duplicados
        {{ eliminate_duplicates([
            '_fivetran_synced', 
            'price', 
            'product_id', 
            'category', 
            'product_name', 
            'supplier_id'
        ]) }} AS _row,

        -- Uso de la macro para formatear la fecha de sincronización de Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Incluir el product_id tal cual está
        product_id,
        
        -- Uso de la macro para redondear el precio
        {{ round_price('price') }} AS price_corrected,

        -- Uso de la macro para calcular el hash de la categoría
        {{ calculate_md5('category') }} AS category_name,
        
        -- Uso de la macro para calcular el hash del nombre del producto
        {{ calculate_md5('product_name') }} AS product_name,
        
        -- Incluir el supplier_id tal cual está
        supplier_id
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('catalog', 'products') }}
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    product_id,
    supplier_id,
    price_corrected,
    category_name,
    product_name
FROM RankedProducts
WHERE _row = 1  -- Se selecciona solo el primer registro de cada grupo de duplicados
ORDER BY product_id ASC
