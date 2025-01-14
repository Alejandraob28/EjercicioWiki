WITH RankedReviews AS (
    SELECT
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            '_fivetran_synced',  
            'review_id',         
            'review_date',      
            'product_id',        
            'rating',            
            'review_text',      
            'customer_id'       
        ]) }} AS _row,  -- Número de fila asignado a cada registro

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Otros campos como el customer_id y review_id
        customer_id,
        review_id,
        product_id,
        review_date,

        -- Corregir las calificaciones fuera del rango 0-5
        CASE 
            WHEN rating < 0 THEN 0
            WHEN rating > 5 THEN 5
            ELSE rating 
        END AS corrected_rating,

        -- Uso de la macro para limpiar el texto de la reseña
        {{ clean_review_text('review_text') }} AS clean_review_text,

    FROM 
        {{ source('clients', 'reviews') }}
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
