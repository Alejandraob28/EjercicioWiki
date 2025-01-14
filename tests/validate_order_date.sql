SELECT *
FROM {{ ref('stg_sales_orders') }}
WHERE order_date > CURRENT_DATE