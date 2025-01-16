WITH RankedCustomers AS (
    SELECT
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            'cc._fivetran_synced', 
            'cc.address', 
            'cc.first_name',
            'cc.last_name', 
            'cc.phone_number',
            'cc.email', 
            'cc.customer_id'
        ]) }} AS _row,  -- Asignación de número de fila por duplicado

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('cc._fivetran_synced') }} AS fivetran_synced_corrected,

        -- Extracción del ID del cliente
        ccc.SK_customer_id,
        
        -- Datos del cliente
        cc.first_name,
        cc.last_name,

        -- Uso de la macro para separar la dirección en 3 partes (calle, ciudad, estado)
        {{ split_address('cc.address') }},
        
        -- Uso de la macro para normalizar el número de teléfono
        {{ normalize_phone_number('cc.phone_number') }} AS phone_number_norm,

        -- Extracción del correo electrónico
        cc.email,

        -- Uso de la macro para validar el correo electrónico
        {{ validate_email('cc.email') }} AS email_validation

    FROM 
        -- Tabla de clientes
        {{ source('clients', 'customers') }} cc
    LEFT JOIN {{ ref("stg_clients_customer_id") }} ccc
        ON cc.customer_id = ccc.customer_id 
)

-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_customer_id,
    first_name,
    last_name,
    street,  
    city,    
    state,   
    phone_number_norm,  
    email,
    email_validation
FROM RankedCustomers
WHERE _row = 1 
