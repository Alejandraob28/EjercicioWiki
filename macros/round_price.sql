-- Macro para redondear precios
{% macro round_price(price_column) %}
    CASE 
        WHEN MOD({{ price_column }} * 100, 1) != 0 THEN ROUND({{ price_column }}, 2)
        WHEN MOD({{ price_column }} * 10, 1) != 0 THEN TO_CHAR({{ price_column }}, 'FM9999999990.00')
        ELSE {{ price_column }}
    END 
{% endmacro %}
