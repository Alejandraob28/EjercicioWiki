WITH sales_order_items AS (
    SELECT 
        SK_order_item_id,
        SK_order_id,
        SK_product_id,
        price_at_purchase_corrected, 
        quantity
    FROM {{ ref('stg_sales_order_items') }}
),

sales_orders AS (
    SELECT 
        SK_order_id,
        order_date
    FROM {{ ref('stg_sales_orders') }}
)

SELECT 
    soi.SK_order_item_id,
    soi.SK_order_id,
    soi.SK_product_id,
    soi.price_at_purchase_corrected,
    soi.quantity,
    so.order_date
FROM sales_order_items soi
LEFT JOIN sales_orders so
    ON soi.SK_order_id = so.SK_order_id


