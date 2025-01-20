{{ 
    config(
        materialized='incremental',
        unique_key='DTE_DATE'
    ) 
}}

with calendar as (

    SELECT 
        fecha AS DTE_DATE,
        to_number(to_varchar(YEAR(fecha))||LPAD(to_varchar(MONTH(fecha)), 2, '0')||LPAD(to_varchar(DAY(fecha)), 2, '0')) as NUM_DATE_SK,
        YEAR(fecha) as NUM_YEAR,
        MONTH(fecha) as NUM_MONTH,
        DAY(fecha) as NUM_DAY,
        decode(DAYNAME(fecha), 'Mon','Monday', 'Tue','Tuesday', 'Wed','Wednesday', 'Thu','Thursday', 'Fri','Friday', 'Sat','Saturday', 'Sun','Sunday') as DES_DAY,
        DAYNAME(fecha) as DES_DAY_SHORT,
        decode(MONTH(fecha), '1','January', '2','February', '3','March', '4','April', '5','May', '6','June', '7','July', '8','August', '9','September', '10','October', '11','November', '12','December') as DES_MONTH,
        MONTHNAME(fecha) as DES_MONTH_SHORT,
        case when DAYOFWEEK(fecha) = 0 then 7 else DAYOFWEEK(fecha) end AS NUM_DAY_OF_WEEK,
        case when WEEKOFYEAR(TRUNCTIMESTAMPTOYEAR(fecha)) = 52 and WEEKOFYEAR(fecha) = 52 and MONTH(fecha) = 1 then 1 when WEEKOFYEAR(TRUNCTIMESTAMPTOYEAR(fecha)) = 52 then WEEKOFYEAR(fecha)+1 else WEEKOFYEAR(fecha) end AS NUM_WEEK_YEAR,
        WEEKOFYEAR(fecha) as NUM_WEEK_YEAR_SEAT,
        LAST_DAY(fecha,'week') AS DTE_LAST_DAY_WEEK,
        DATE_PART(QUARTER,fecha) as NUM_QUARTER,
        'T'||DATE_PART(QUARTER,fecha) as DES_QUARTER,
        CASE WHEN MONTH(fecha) in (1,2,3,4,5,6) then 1 ELSE 2 END as NUM_SEMESTER,
        NUM_YEAR||'/'||DES_QUARTER as DES_YEAR_QUARTER,
        NUM_YEAR||'/'||LPAD(to_varchar(MONTH(fecha)), 2, '0') as DES_YEAR_MONTH,
        to_varchar(fecha,'YY')||'/'||MONTHNAME(fecha) as DES_YEAR_MONTH_SHORT,
        LAST_DAY(fecha) as "DTE_LAST_DAY_MONTH",
        --SPANISH
        decode(DAYOFWEEK(fecha), '1','Lunes', '2','Martes', '3','Miércoles', '4','Jueves', '5','Viernes', '6','Sábado', '0','Domingo') as DES_DAY_SPA,
        decode(DAYOFWEEK(fecha), '1','Lun', '2','Mar', '3','Mie', '4','Jue', '5','Vie', '6','Sab', '0','Dom') as DES_DAY_SHORT_SPA,
        decode(MONTH(fecha), '1','Enero', '2','Febrero', '3','Marzo', '4','Abril', '5','Mayo', '6','Junio', '7','Julio', '8','Agosto', '9','Septiembre', '10','Octubre', '11','Noviembre', '12','Diciembre') as DES_MONTH_SPA,
        decode(MONTH(fecha), '1','Ene', '2','Feb', '3','Mar', '4','Abr', '5','May', '6','Jun', '7','Jul', '8','Ago', '9','Sep', '10','Oct', '11','Nov', '12','Dic') as DES_MONTH_SHORT_SPA,       
    FROM (
        SELECT cast(DATEADD(DAY, seq4(), '2023-01-01') as date) AS fecha
        FROM TABLE(GENERATOR(ROWCOUNT => 365*150))
        {% if is_incremental() %}
        where fecha > (select max(DTE_DATE) from {{this}})
        {% endif %}
        )
)


select * from calendar