
-- Macro para formatear la fecha Fivetran
{% macro format_fivetran_date(date_column) %}
    TO_CHAR(TO_TIMESTAMP_TZ({{ date_column }}), 'DD-Mon-YYYY HH24:MI:SS')
{% endmacro %}
