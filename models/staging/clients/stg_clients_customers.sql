WITH RankedCustomers AS (
    SELECT
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            '_fivetran_synced', 
            'address', 
            'first_name',
            'last_name', 
            'phone_number',
            'email', 
            'customer_id'
        ]) }} AS _row,  -- Asignación de número de fila por duplicado

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Extracción del ID del cliente
        customer_id,
        
        -- Datos del cliente
        first_name,
        last_name,

        -- Uso de la macro para separar la dirección en 3 partes (calle, ciudad, estado)
        {{ split_address('address') }},
        
        -- Uso de la macro para normalizar el número de teléfono
        {{ normalize_phone_number('phone_number') }} AS phone_number_norm,

        -- Extracción del correo electrónico
        email,

        -- Uso de la macro para validar el correo electrónico
        {{ validate_email('email') }} AS email_validation

    FROM 
        -- Tabla de clientes
        {{ source('clients', 'customers') }}
)

-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    customer_id,
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
ORDER BY customer_id ASC
