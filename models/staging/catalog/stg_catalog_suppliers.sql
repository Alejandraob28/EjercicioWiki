WITH RankedSuppliers AS (
    SELECT
        -- Uso de la macro para eliminar duplicados y asignar el número de fila
        {{ eliminate_duplicates([
            'cs._fivetran_synced', 
            'cs.contact_name', 
            'cs.address', 
            'cs.phone_number', 
            'cs.supplier_name', 
            'cs.supplier_id', 
            'cs.email' 
        ]) }} AS _row,  -- Asignación de número de fila por duplicado

        -- Uso de la macro para formatear la fecha Fivetran
        {{ format_fivetran_date('cs._fivetran_synced') }} AS fivetran_synced_corrected,
        
        -- Extracción del id del proveedor
        css.SK_supplier_id,

        -- Extracción del id de localización
        cls.SK_location_suppliers_id,
        
        -- Extracción del primer nombre
        TRIM(SUBSTRING(cs.contact_name, 1, POSITION(' ' IN cs.contact_name) - 1)) AS first_name,
        
        -- Extracción del apellido (condición si no existe apellido)
        TRIM(SUBSTRING(cs.contact_name, POSITION(' ' IN cs.contact_name) + 1)) AS last_name,
        
        -- Uso de la macro para separar la dirección en 3 partes (calle, ciudad, estado)
        {{ split_address('cs.address') }},
        
        -- Uso de la macro para normalizar el número de teléfono
        {{ normalize_phone_number('cs.phone_number') }} AS phone_number_norm,
        
        -- Extracción del correo electrónico
        cs.email,
        
        -- Uso de la macro para validar el correo electrónico
        {{ validate_email('cs.email') }} AS email_validation
    FROM 
        -- Tabla de datos de proveedores
        {{ source('catalog', 'suppliers') }} cs
    LEFT JOIN {{ ref("stg_catalog_supplier_id") }} css
        ON cs.supplier_id = css.supplier_id 
    LEFT JOIN {{ ref("stg_catalog_location_suppliers_id") }} cls
        ON cs.address = cls.address  
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_supplier_id,
    SK_location_suppliers_id,
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
