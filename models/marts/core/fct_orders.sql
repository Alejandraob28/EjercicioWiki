WITH sales_orders AS (
    SELECT 
        SK_order_id,
        SK_customer_id, 
        order_date,
        total_price_corrected
    FROM {{ ref('stg_sales_orders') }}
),

sales_payment AS (
    SELECT
        SK_payment_id,
        SK_order_id
    FROM {{ ref('stg_sales_payment') }}
),

sales_shipments AS (
    SELECT
        SK_shipment_id,
        SK_order_id
    FROM {{ ref('stg_sales_shipments') }}
)

SELECT 
    so.SK_order_id,
    so.SK_customer_id,
    sp.SK_payment_id,
    ss.SK_shipment_id,
    so.order_date,
    so.total_price_corrected
FROM sales_orders so
LEFT JOIN sales_payment sp
    ON so.SK_order_id = sp.SK_order_id
LEFT JOIN sales_shipments ss
    ON so.SK_order_id = ss.SK_order_id






