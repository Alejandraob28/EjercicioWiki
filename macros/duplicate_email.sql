{% test duplicate_email(model,column_name) %}

WITH combined_data AS (
    SELECT contact_name, email
    FROM {{ ref('stg_catalog_suppliers') }}
    UNION ALL
    SELECT CONCAT(first_name, ' ', last_name) AS contact_name, email
    FROM {{ ref('stg_catalog_customers') }}
),
duplicate_emails AS (
    SELECT email
    FROM combined_data
    GROUP BY email
    HAVING COUNT(DISTINCT contact_name) > 1  -- Verifica si más de un contacto tiene el mismo email
)

SELECT *
FROM duplicate_emails

{% endtest %}

