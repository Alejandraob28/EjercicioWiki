WITH RankedOrders AS (
    SELECT
        
        -- Usamos la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            'so._fivetran_synced', 
            'so.order_date',        
            'so.total_price',      
            'so.customer_id',       
            'so.order_id'           
        ]) }} AS _row,

        -- Uso de la macro para formatear la fecha de Fivetran
        {{ format_fivetran_date('so._fivetran_synced') }} AS fivetran_synced_corrected,

        -- Otros campos (id con su hash) y la fecha de pedido como está
        {{ calculate_md5('so.order_id') }} AS order_id,
        
        {{ calculate_md5('CONCAT(cc.first_name, \' \', cc.last_name, \' \',cc.phone_number, \' \',cc.address)') }} AS customer_id,

        order_date,

        -- Uso de la macro para redondear el precio
        {{ round_price('so.total_price') }} AS total_price_corrected

    FROM 
        {{ source('sales', 'orders') }} so
    LEFT JOIN {{ source('clients', 'customers') }} cc
        ON so.customer_id = cc.customer_id  -- Asegúrate de que la columna customer_id sea la misma en ambas tablas
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    order_id,
    customer_id,
    order_date,
    total_price_corrected
FROM RankedOrders
WHERE _row = 1 
ORDER BY order_id ASC
