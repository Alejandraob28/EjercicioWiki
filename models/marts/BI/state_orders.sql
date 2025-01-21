SELECT
    transaction_status,  -- Estado de la transacción de pago (completada, cancelada, pendiente)
    COUNT(o.SK_order_id) AS total_orders,  -- Total de órdenes por estado
    ROUND(COUNT(o.SK_order_id) * 100.0 / (SELECT COUNT(*) FROM {{ ref('fct_orders') }}), 2) AS percentage  -- Proporción en porcentaje
FROM
    {{ ref('fct_orders') }} o
JOIN
    {{ ref('dim_payment') }} p ON o.SK_payment_id = p.SK_payment_id
GROUP BY
    transaction_status
ORDER BY
    total_orders DESC
