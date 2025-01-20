SELECT 
    SK_shipment_id,
    shipment_date,
    tracking_number,
    carrier,
    shipment_status,
    delivery_date

FROM {{ref('stg_sales_shipments')}}