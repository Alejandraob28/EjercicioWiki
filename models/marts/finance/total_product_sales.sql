SELECT
    p.SK_product_id,
    d.num_year AS year,
    d.num_month AS month,
    d.des_month AS month_name, 
    SUM(oi.price_at_purchase_corrected * oi.quantity) AS total_sales,
FROM
    {{ ref('fct_order_items') }} oi
JOIN
    {{ ref('dim_product') }} p ON oi.SK_product_id = p.SK_product_id
JOIN
    {{ ref('fct_orders') }} o ON oi.SK_order_id = o.SK_order_id
JOIN
    {{ ref('dim_date') }} d ON o.order_date = d.dte_date
GROUP BY
    p.SK_product_id,
    d.num_year,
    d.num_month,
    d.des_month
ORDER BY
    d.num_year ASC,
    d.num_month ASC,
    p.SK_product_id



