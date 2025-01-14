WITH RankedOrderItems AS (
    SELECT
        
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            '_fivetran_synced',  
            'order_item_id',    
            'quantity',          
            'price_at_purchase', 
            'product_id',       
            'order_id'          
        ]) }} AS _row,  -- Número de fila asignado a cada grupo de duplicados

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Otros campos tal cual están
        order_item_id,
        order_id,
        product_id,

        -- Uso de la macro para redondear el precio
        {{ round_price('price_at_purchase') }} AS price_at_purchase_corrected,

        -- Incluir la cantidad tal cual está
        quantity,

    FROM 
        {{ source('sales', 'order_items') }}
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
