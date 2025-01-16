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
        soo.SK_order_id,
        
        ccc.SK_customer_id,

        order_date,

        -- Uso de la macro para redondear el precio
        {{ round_price('so.total_price') }} AS total_price_corrected

    FROM 
        {{ source('sales', 'orders') }} so
    LEFT JOIN {{ ref("stg_sales_order_id") }} soo
        ON so.order_id = soo.order_id 
    LEFT JOIN {{ ref("stg_clients_customer_id") }} ccc
        ON so.customer_id = ccc.customer_id 
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_order_id,
    SK_customer_id,
    order_date,
    total_price_corrected
FROM RankedOrders
WHERE _row = 1 

