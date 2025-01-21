WITH customer_spending AS (
    SELECT
        c.SK_customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(oi.price_at_purchase_corrected * oi.quantity) AS total_spent,  -- Gasto total del cliente
        MIN(o.order_date) AS first_purchase_date,  -- Fecha del primer pedido
        MAX(o.order_date) AS last_purchase_date   -- Fecha del último pedido
    FROM
        {{ ref('fct_order_items') }} oi
    JOIN
        {{ ref('fct_orders') }} o ON oi.SK_order_id = o.SK_order_id
    JOIN
        {{ ref('dim_customer') }} c ON o.SK_customer_id = c.SK_customer_id
    GROUP BY
        c.SK_customer_id,
        c.first_name,
        c.last_name
),
customer_retention AS (
    SELECT
        SK_customer_id,
        customer_name,
        total_spent,
        first_purchase_date,
        last_purchase_date,
        CASE
            WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '6 months' THEN 'Active'  -- Cliente activo si compró en los últimos 6 meses
            WHEN last_purchase_date < CURRENT_DATE - INTERVAL '6 months' 
                AND first_purchase_date < CURRENT_DATE - INTERVAL '1 year' THEN 'Lost'  -- Cliente perdido si no ha comprado en el último año
            ELSE 'New'  -- Cliente nuevo si compró en el último año pero no en los últimos 6 meses
        END AS retention_status  -- Analizamos la retención (activo, perdido o nuevo)
    FROM
        customer_spending
)
SELECT
    SK_customer_id,
    customer_name,
    total_spent,
    retention_status
FROM
    customer_retention
ORDER BY
    total_spent DESC
