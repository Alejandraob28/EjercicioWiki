WITH RankedSuppliers AS (
    SELECT
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            '_fivetran_synced', 
            'contact_name', 
            'address', 
            'phone_number', 
            'supplier_name', 
            'supplier_id', 
            'email' 
        ]) }} AS _row,  -- Asignación de número de fila por duplicado

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,
        
        -- Extracción del id del proveedor
        {{ calculate_md5('CONCAT(supplier_name, \' \',address)') }} AS supplier_id,
        
        -- Extracción del primer nombre
        TRIM(SUBSTRING(contact_name, 1, POSITION(' ' IN contact_name) - 1)) AS first_name,
        
        -- Extracción del apellido (condición si no existe apellido)
        TRIM(SUBSTRING(contact_name, POSITION(' ' IN contact_name) + 1)) AS last_name,
        
        -- Uso de la macro para separar la dirección en 3 partes (calle, ciudad, estado)
        {{ split_address('address') }},
        
        -- Uso de la macro para normalizar el número de teléfono
        {{ normalize_phone_number('phone_number') }} AS phone_number_norm,
        
        -- Extracción del correo electrónico
        email,
        
        -- Uso de la macro para validar el correo electrónico
        {{ validate_email('email') }} AS email_validation
    FROM 
        -- Tabla de datos de proveedores
        {{ source('catalog', 'suppliers') }}
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    supplier_id,
    first_name,
    last_name,
    street,  
    city,   
    state,   
    phone_number_norm,  
    email,
    email_validation
FROM RankedSuppliers
WHERE _row = 1  
ORDER BY supplier_id
