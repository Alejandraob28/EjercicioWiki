WITH RankedPayment AS (
    SELECT
        
        -- Uso de la macro para eliminar duplicados
        {{ eliminate_duplicates([
            '_fivetran_synced',  
            'amount',            
            'transaction_status',
            'payment_id',       
            'order_id',          
            'payment_method'   
        ]) }} AS _row,  -- Número de fila asignado a cada grupo de duplicados

        -- Uso de la macro para formatear la fecha de Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Incluir el hash de order_id 
        {{ calculate_md5('order_id') }} AS order_id,

        -- Incluir el hash de payment_id 
        {{ calculate_md5('CONCAT(order_id, \' \',payment_method)') }} AS payment_id,

        -- Uso de la macro para redondear la cantidad
        {{ round_price('amount') }} AS amount_corrected,


        -- Normalizar todas las variantes de tarjeta a "CREDIT CARD"
        CASE 
            WHEN LOWER(payment_method) LIKE '%visa%' THEN 'Credit Card'
            WHEN LOWER(payment_method) LIKE '%mastercard%' THEN 'Credit Card'
            WHEN LOWER(payment_method) LIKE '%paypal%' THEN 'Paypal'
            WHEN LOWER(payment_method) LIKE '%bank transfer%' THEN 'Bank Transfer'
            ELSE payment_method
        END AS payment_method_normalized,

        -- Indicar el estado de la transacción
        transaction_status,
        
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('sales', 'payment') }}
)
-- Selección final de los registros únicos
SELECT 
fivetran_synced_corrected,
order_id,
payment_id,
amount_corrected,
payment_method_normalized,
transaction_status
FROM RankedPayment
WHERE _row = 1  -- Se selecciona solo el primer registro de cada grupo de duplicados
ORDER BY order_id ASC