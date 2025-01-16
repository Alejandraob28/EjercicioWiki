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
        ccc.SK_customer_id,

        crr. SK_review_id,  

        cpp.SK_product_id,

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
    LEFT JOIN {{ ref("stg_catalog_product_id") }} cpp
        ON cr.product_id = cpp.product_id 
    LEFT JOIN {{ ref("stg_clients_review_id") }} crr
        ON cr.review_id = crr.review_id  
    LEFT JOIN {{ ref("stg_clients_customer_id") }} ccc
        ON cr.customer_id = ccc.customer_id 
)

-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_review_id,
    SK_customer_id,
    SK_product_id,
    review_date,
    corrected_rating,
    clean_review_text
FROM RankedReviews
WHERE _row = 1  
