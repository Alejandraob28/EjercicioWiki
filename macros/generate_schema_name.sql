
-- Esta macro elimina el nombre por defecto del esquema para poder ponerle uno personalizado mediante una variable de entorno
{%macro generate_schema_name (custom_schema_name, node)%}
{{custom_schema_name | lower}}
{%endmacro%}