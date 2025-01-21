SELECT
    c.SK_category_id,
    c.category,  -- Nombre de la categoría
    SUM(oi.price_at_purchase_corrected * oi.quantity) AS total_sales
FROM
    {{ ref('fct_order_items') }} oi
JOIN
    {{ ref('dim_product') }} p ON oi.SK_product_id = p.SK_product_id
JOIN
    {{ ref('dim_category') }} c ON p.SK_category_id = c.SK_category_id
JOIN
    {{ ref('fct_orders') }} o ON oi.SK_order_id = o.SK_order_id
GROUP BY
    c.SK_category_id,
    c.category
ORDER BY
    total_sales DESC
