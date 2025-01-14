SELECT *
FROM {{ ref('stg_sales_shipments') }}
WHERE shipment_date > delivery_date
