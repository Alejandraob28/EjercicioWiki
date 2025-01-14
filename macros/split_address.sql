{% macro split_address(address_column) %}
    TRIM(SPLIT_PART({{ address_column }}, ',', 1)) AS street,  -- Calle
    TRIM(SPLIT_PART({{ address_column }}, ',', 2)) AS city,    -- Ciudad
    TRIM(SPLIT_PART({{ address_column }}, ',', 3)) AS state  -- Estado
{% endmacro %}
