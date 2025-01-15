WITH RankedShipments AS (
    SELECT
        
        -- Uso de la macro para eliminar duplicados
        {{ eliminate_duplicates([
            '_fivetran_synced',  
            'carrier',         
            'delivery_date',   
            'tracking_number',  
            'shipment_date',     
            'shipment_id',       
            'order_id',         
            'shipment_status'  
        ]) }} AS _row,  -- Número de fila asignado a cada grupo de duplicados

        -- Uso de la macro para formatear la fecha de Fivetran
        {{ format_fivetran_date('_fivetran_synced') }} AS fivetran_synced_corrected,

        -- Incluir el hash de order_id
        {{ calculate_md5('order_id') }} AS order_id,

        -- Incluir el hash de shipment_id 
        {{ calculate_md5('CONCAT(order_id, \' \',tracking_number)') }} AS shipment_id,

        -- Indicar shipment_date tal cual está
        shipment_date,

    -- Indicar tracking_number tal cual está
        tracking_number,
    
    -- Indicar transportista tal cual está
        carrier,
    
    -- Indicar el estado del pedido
        shipment_status,

    -- Indicar delivery_date tal cual está
        delivery_date
        
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('sales', 'shipments') }}
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    order_id,
    shipment_id,
    shipment_date,
    tracking_number,
    carrier,
    shipment_status,
    delivery_date
FROM RankedShipments
WHERE _row = 1  -- Se selecciona solo el primer registro de cada grupo de duplicados
ORDER BY order_id ASC