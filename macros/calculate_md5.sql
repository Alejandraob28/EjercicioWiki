-- Macro para calcular hash MD5
{% macro calculate_md5(column_name) %}
    MD5({{ column_name }}) 
{% endmacro %}
