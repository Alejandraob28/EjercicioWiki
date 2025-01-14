-- Macro para normalizar el número de teléfono
{% macro normalize_phone_number(phone_column) %}
    REGEXP_REPLACE({{ phone_column }}, '[^0-9]', '') 
{% endmacro %}
