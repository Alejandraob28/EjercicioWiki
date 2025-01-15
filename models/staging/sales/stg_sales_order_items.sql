WITH RankedOrderItems AS (
    SELECT
        
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            'oi._fivetran_synced',  
            'oi.order_item_id',    
            'oi.quantity',          
            'oi.price_at_purchase', 
            'oi.product_id',       
            'oi.order_id'          
        ]) }} AS _row,  -- Número de fila asignado a cada grupo de duplicados

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('oi._fivetran_synced') }} AS fivetran_synced_corrected,

        -- Otros campos con su hash
        {{ calculate_md5('CONCAT(oi.order_id, \' \', oi.order_item_id, \' \', oi.product_id)') }} AS order_item_id,

        {{ calculate_md5('oi.order_id') }} AS order_id,

        {{ calculate_md5('CONCAT(cp.product_id, \' \',cp.product_name)') }} AS product_id,
   
        -- Uso de la macro para redondear el precio
        {{ round_price('oi.price_at_purchase') }} AS price_at_purchase_corrected,

        -- Incluir la cantidad tal cual está
        oi.quantity

    FROM 
        {{ source('sales', 'order_items') }} oi
    LEFT JOIN {{ source('catalog', 'products') }} cp
        ON oi.product_id = cp.product_id  -- Asegúrate de que la columna product_id sea la misma en ambas tablas
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    order_item_id,
    order_id,
    product_id,
    price_at_purchase_corrected,
    quantity
FROM RankedOrderItems
WHERE _row = 1 
ORDER BY order_item_id ASC
