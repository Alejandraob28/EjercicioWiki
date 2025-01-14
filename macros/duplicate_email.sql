{% test duplicate_email(model, email_column, first_name_column, last_name_column) %}
    
    WITH combined_data AS (
        SELECT CONCAT({{ first_name_column }}, ' ', {{ last_name_column }}) AS contact_name, {{ email_column }} AS email
        FROM {{ model }}
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


