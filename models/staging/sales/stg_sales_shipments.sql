WITH RankedShipments AS (
    SELECT
        
        -- Uso de la macro para eliminar duplicados
        {{ eliminate_duplicates([
            'ss._fivetran_synced',  
            'ss.carrier',         
            'ss.delivery_date',   
            'ss.tracking_number',  
            'ss.shipment_date',     
            'ss.shipment_id',       
            'ss.order_id',         
            'ss.shipment_status'  
        ]) }} AS _row,  -- Número de fila asignado a cada grupo de duplicados

        -- Uso de la macro para formatear la fecha de Fivetran
        {{ format_fivetran_date('ss._fivetran_synced') }} AS fivetran_synced_corrected,

        -- Incluir el hash de order_id
        soo.SK_order_id,

        -- Incluir el hash de shipment_id 
        sss.SK_shipment_id,

        -- Indicar shipment_date tal cual está
        ss.shipment_date,

    -- Indicar tracking_number tal cual está
        ss.tracking_number,
    
    -- Indicar transportista tal cual está
        ss.carrier,
    
    -- Indicar el estado del pedido
        ss.shipment_status,

    -- Indicar delivery_date tal cual está
        ss.delivery_date
        
    FROM 
        -- Tabla de productos desde la base de datos
        {{ source('sales', 'shipments') }} ss
    LEFT JOIN {{ ref("stg_sales_order_id") }} soo
        ON ss.order_id = soo.order_id 
    LEFT JOIN {{ ref("stg_sales_shipment_id") }} sss
        ON ss.shipment_id = sss.shipment_id 
)
-- Selección final de los registros únicos
SELECT 
    fivetran_synced_corrected,
    SK_shipment_id,
    SK_order_id,
    shipment_date,
    tracking_number,
    carrier,
    shipment_status,
    delivery_date
FROM RankedShipments
WHERE _row = 1  