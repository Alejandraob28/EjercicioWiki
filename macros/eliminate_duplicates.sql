-- Macro para asignar ROW_NUMBER() y filtrar duplicados
{% macro eliminate_duplicates(columns) %}
    ROW_NUMBER() OVER (
        PARTITION BY {{ columns | join(', ') }}
        ORDER BY {{ columns[0] }}  -- Puedes modificar esto para que el orden sea dinámico si lo necesitas
    )
{% endmacro %}
