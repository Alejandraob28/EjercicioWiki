WITH RankedReviews AS (
    SELECT
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            'cr._fivetran_synced',  
            'cr.review_id',         
            'cr.review_date',      
            'cr.product_id',        
            'cr.rating',            
            'cr.review_text',      
            'cr.customer_id'       
        ]) }} AS _row,  -- Número de fila asignado a cada registro

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('cr._fivetran_synced') }} AS fivetran_synced_corrected,

        -- Otros campos como el customer_id y review_id en su hash
        {{ calculate_md5('CONCAT(cc.first_name, \' \', cc.last_name, \' \',cc.phone_number, \' \',cc.address)') }} AS customer_id,

        {{ calculate_md5('CONCAT(cr.customer_id, \' \', cr.product_id)') }} AS review_id,  

        {{ calculate_md5('CONCAT(cp.product_id, \' \',cp.product_name)') }} AS product_id,

        review_date,

        -- Corregir las calificaciones fuera del rango 0-5
        CASE 
            WHEN cr.rating < 0 THEN 0
            WHEN cr.rating > 5 THEN 5
            ELSE cr.rating 
        END AS corrected_rating,

        -- Uso de la macro para limpiar el texto de la reseña
        {{ clean_review_text('cr.review_text') }} AS clean_review_text

    FROM 
        {{ source('clients', 'reviews') }} cr
    LEFT JOIN {{ source('clients', 'customers') }} cc
        ON cr.customer_id = cc.customer_id  -- Asegúrate de que la columna customer_id sea la misma en ambas tablas
    LEFT JOIN {{ source('catalog', 'products') }} cp
        ON cr.product_id = cp.product_id  -- Asegúrate de que la columna product_id sea la misma en ambas tablas
)

-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    customer_id,
    review_id,
    product_id,
    review_date,
    corrected_rating,
    clean_review_text
FROM RankedReviews
WHERE _row = 1  
ORDER BY customer_id ASC
