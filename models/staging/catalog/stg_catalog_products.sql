WITH RankedProducts AS (
    SELECT
        
        -- Uso de la macro para asignar el número de fila y eliminar duplicados
        {{ eliminate_duplicates([
            'cp._fivetran_synced',  
            'cp.price', 
            'cp.product_id', 
            'cp.category', 
            'cp.product_name', 
            'cp.supplier_id' 
        ]) }} AS _row,  -- Asignación de número de fila por duplicado

        -- Uso de la macro para formatear la fecha de sincronización de Fivetran
        {{ format_fivetran_date('cp._fivetran_synced') }} AS fivetran_synced_corrected,  -- Usando el alias de la tabla productos

        -- Incluir el hash del product_name
        cpp.SK_product_id,

        -- Uso de la macro para redondear el precio
        {{ round_price('cp.price') }} AS price_corrected,  -- Usando el alias de la tabla productos

        -- Uso de la macro para calcular el hash de la categoría
        cccc.SK_category_id,
        
        -- Incluir el hash de supplier_name de la tabla suppliers
        css.SK_supplier_id,
        
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('catalog', 'products') }} cp
    LEFT JOIN {{ ref("stg_catalog_supplier_id") }} css
        ON cp.supplier_id = css.supplier_id  
    LEFT JOIN {{ ref("stg_catalog_product_id") }} cpp
        ON cp.product_id = cpp.product_id  
    LEFT JOIN {{ ref("stg_catalog_category_id") }} cccc
        ON cp.category = cccc.category 

)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_product_id,
    SK_supplier_id,
    SK_category_id,
    price_corrected
FROM RankedProducts
WHERE _row = 1  -- Se selecciona solo el primer registro de cada grupo de duplicados
