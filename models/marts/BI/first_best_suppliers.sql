WITH product_sales AS (
    SELECT
        p.SK_product_id,
        p.SK_supplier_id,
        SUM(oi.quantity) AS total_sold  -- Total de productos vendidos
    FROM
        ALEJANDRAOLIVER_DEV_GOLD_ICAROSPATH_DB.core.fct_order_items oi
    JOIN
        ALEJANDRAOLIVER_DEV_GOLD_ICAROSPATH_DB.core.dim_product p ON oi.SK_product_id = p.SK_product_id
    GROUP BY
        p.SK_product_id,
        p.SK_supplier_id
),
supplier_avg_rating AS (
    SELECT
        p.SK_product_id,
        p.SK_supplier_id,
        AVG(r.corrected_rating) AS avg_rating  -- Valoración media del producto
    FROM
        ALEJANDRAOLIVER_DEV_GOLD_ICAROSPATH_DB.core.dim_product p
    JOIN
        ALEJANDRAOLIVER_DEV_GOLD_ICAROSPATH_DB.core.dim_review r ON p.SK_product_id = r.SK_product_id
    GROUP BY
        p.SK_product_id,
        p.SK_supplier_id
)
SELECT
    ps.SK_supplier_id,
    sup.first_name || ' ' || sup.last_name AS supplier_name,  -- Nombre del proveedor
    SUM(ps.total_sold) AS total_products_sold,  -- Total de productos vendidos por el proveedor
    AVG(sar.avg_rating) AS avg_supplier_rating  -- Valoración media del proveedor (promedio de todos sus productos)
FROM
    product_sales ps
JOIN
    supplier_avg_rating sar ON ps.SK_product_id = sar.SK_product_id
JOIN
    ALEJANDRAOLIVER_DEV_GOLD_ICAROSPATH_DB.core.dim_supplier sup ON ps.SK_supplier_id = sup.SK_supplier_id
GROUP BY
    ps.SK_supplier_id,  -- Cambié 's.SK_supplier_id' por 'ps.SK_supplier_id'
    sup.first_name,
    sup.last_name
ORDER BY
    total_products_sold DESC,  -- Ordenar por más productos vendidos
    avg_supplier_rating DESC  -- Y luego por la mejor valoración media
