WITH RankedOrders AS (
    SELECT
        
        -- Usamos la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            '_fivetran_synced', 
            'order_date',        
            'total_price',      
            'customer_id',       
            'order_id'           
        ]) }} AS _row,

        -- Uso de la macro para formatear la fecha de Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Otros campos tal cual están
        order_id,
        customer_id,
        order_date,

        -- Uso de la macro para redondear el precio
        {{ round_price('total_price') }} AS total_price_corrected

    FROM 
        {{ source('sales', 'orders') }}
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
