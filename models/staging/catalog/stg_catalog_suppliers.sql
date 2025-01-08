-- Subconsulta para asignar un número de fila por cada conjunto de registros duplicados
WITH RankedSuppliers AS (
    SELECT
        -- Asignación de número de fila para cada grupo de duplicados
        ROW_NUMBER() OVER (
            PARTITION BY 
                -- Partición por columnas clave para identificar duplicados
                -- División del nombre de contacto en first_name y last_name
                TRIM(SUBSTRING(contact_name, 1, POSITION(' ' IN contact_name) - 1)),  -- First name
                TRIM(SUBSTRING(contact_name, POSITION(' ' IN contact_name) + 1)),  -- Last name
                
                -- Separación de la dirección en calle, ciudad y estado
                TRIM(SPLIT_PART(address, ',', 1)),  -- Street
                TRIM(SPLIT_PART(address, ',', 2)),  -- City
                TRIM(SPLIT_PART(address, ',', 3)),  -- State
                
                -- Normalización del número de teléfono (eliminación de caracteres no numéricos)
                REGEXP_REPLACE(phone_number, '[^0-9]', ''),  -- Normalized phone number
                
                -- Correo electrónico
                email  -- Email
        
            -- Orden por una columna, aunque no afecta a la eliminación de duplicados
            ORDER BY supplier_id  -- El orden por supplier_id es solo para la asignación de números de fila
        ) AS _ROW,  -- Número de fila asignado a cada registro
        
        -- Extracción del primer nombre
        TRIM(SUBSTRING(contact_name, 1, POSITION(' ' IN contact_name) - 1)) AS FIRST_NAME,
        
        -- Extracción del apellido
        TRIM(SUBSTRING(contact_name, POSITION(' ' IN contact_name) + 1)) AS LAST_NAME,
        
        -- Extracción de la calle, ciudad y estado
        TRIM(SPLIT_PART(address, ',', 1)) AS STREET,
        TRIM(SPLIT_PART(address, ',', 2)) AS CITY,
        TRIM(SPLIT_PART(address, ',', 3)) AS STATE,
        
        -- Normalización del número de teléfono
        REGEXP_REPLACE(phone_number, '[^0-9]', '') AS PHONE_NUMBER_NORM,
        
        -- Extracción del correo electrónico
        email AS EMAIL,
        
        -- Validación del correo electrónico (verificación del símbolo @)
        CASE 
            WHEN email LIKE '%@%' THEN TRUE  -- Correo válido si contiene "@"
            ELSE FALSE  -- Correo inválido si no contiene "@"
        END AS EMAIL_VALIDATION
    FROM 
        -- Tabla de datos de proveedores
        ALEJANDRAOLIVER_DEV_BRONZE_ICAROSPATH_DB.CATALOG.SUPPLIERS
)
-- Selección final de los registros únicos
SELECT *
FROM RankedSuppliers
WHERE _ROW = 1  -- Se selecciona solo el primer registro de cada grupo de registros duplicados

