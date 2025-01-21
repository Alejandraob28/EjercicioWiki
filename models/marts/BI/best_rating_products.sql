SELECT
    p.SK_product_id,
    ROUND(AVG(r.corrected_rating), 1) AS avg_rating  
FROM
    {{ ref('dim_product') }} p
JOIN
    {{ ref('dim_review') }} r ON p.SK_product_id = r.SK_product_id
GROUP BY
    p.SK_product_id
ORDER BY
    avg_rating DESC

