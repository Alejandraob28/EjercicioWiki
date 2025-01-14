{% macro validate_email(email_column) %}
    CASE 
        WHEN TRIM(LOWER({{ email_column }})) LIKE '%@%' THEN TRUE  -- Si el correo tiene un "@", es válido
        ELSE FALSE  -- Si el correo no tiene un "@", es inválido
    END 
{% endmacro %}

