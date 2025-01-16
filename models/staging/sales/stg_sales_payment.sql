WITH RankedPayment AS (
    SELECT
        
        -- Uso de la macro para eliminar duplicados
        {{ eliminate_duplicates([
            'sp._fivetran_synced',  
            'sp.amount',            
            'sp.transaction_status',
            'sp.payment_id',       
            'sp.order_id',          
            'sp.payment_method'   
        ]) }} AS _row,  -- Número de fila asignado a cada grupo de duplicados

        -- Uso de la macro para formatear la fecha de Fivetran
        {{ format_fivetran_date('sp._fivetran_synced') }} AS fivetran_synced_corrected,

        -- Incluir el hash de order_id 
        soo.SK_order_id,

        -- Incluir el hash de payment_id 
        spp.SK_payment_id,

        -- Uso de la macro para redondear la cantidad
        {{ round_price('sp.amount') }} AS amount_corrected,


        -- Normalizar todas las variantes de tarjeta a "CREDIT CARD"
        CASE 
            WHEN LOWER(sp.payment_method) LIKE '%visa%' THEN 'Credit Card'
            WHEN LOWER(sp.payment_method) LIKE '%mastercard%' THEN 'Credit Card'
            WHEN LOWER(sp.payment_method) LIKE '%paypal%' THEN 'Paypal'
            WHEN LOWER(sp.payment_method) LIKE '%bank transfer%' THEN 'Bank Transfer'
            ELSE sp.payment_method
        END AS payment_method_normalized,

        -- Indicar el estado de la transacción
        sp.transaction_status,
        
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('sales', 'payment') }} sp
    LEFT JOIN {{ ref("stg_sales_order_id") }} soo
        ON sp.order_id = soo.order_id 
    LEFT JOIN {{ ref("stg_sales_payment_id") }} spp
        ON sp.payment_id = spp.payment_id 
)
-- Selección final de los registros únicos
SELECT 
fivetran_synced_corrected,
SK_payment_id,
SK_order_id,
amount_corrected,
payment_method_normalized,
transaction_status
FROM RankedPayment
WHERE _row = 1  