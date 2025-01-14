-- Macro para limpiar comentarios
{% macro clean_review_text(review_column) %}
    CASE
        WHEN LENGTH(REPLACE({{ review_column }}, '  ', ' ')) > 500 THEN 
            SUBSTRING(REGEXP_REPLACE(REPLACE({{ review_column }}, '  ', ' '), '(badword1|badword2|badword3)', '***'), 1, 500)
        ELSE REGEXP_REPLACE(REPLACE({{ review_column }}, '  ', ' '), '(badword1|badword2|badword3)', '***')
    END 
{% endmacro %}
