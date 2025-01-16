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
        soi.SK_order_item_id,

        soo.SK_order_id,

        cpp.SK_product_id,
   
        -- Uso de la macro para redondear el precio
        {{ round_price('oi.price_at_purchase') }} AS price_at_purchase_corrected,

        -- Incluir la cantidad tal cual está
        oi.quantity

    FROM 
        {{ source('sales', 'order_items') }} oi
    LEFT JOIN {{ source('catalog', 'products') }} cp
        ON oi.product_id = cp.product_id  
    LEFT JOIN {{ ref("stg_catalog_product_id") }} cpp
        ON oi.product_id = cpp.product_id  
    LEFT JOIN {{ ref("stg_sales_order_id") }} soo
        ON oi.order_id = soo.order_id 
    LEFT JOIN {{ ref("stg_sales_order_item_id") }} soi
        ON oi.order_item_id = soi.order_item_id 
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_order_item_id,
    SK_order_id,
    SK_product_id,
    price_at_purchase_corrected,
    quantity
FROM RankedOrderItems
WHERE _row = 1 
