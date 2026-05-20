-- Projekt 2
/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*/
create view project_2_JF2 as

WITH initial AS ( --Priemerna hodnota mlieka a chleba
    SELECT
        ROUND(AVG(cp.value)::numeric, 2) AS value,
        cpc.name AS product_name,
        TO_CHAR(cp.date_from, 'YYYY-MM-DD') AS date
    FROM czechia_price cp
    JOIN czechia_price_category cpc 
        ON cp.category_code = cpc.code
    WHERE cp.category_code IN ('114201', '111301')
    GROUP BY product_name, date
),
continue AS ( --Prve a posledne srovnatelne obdobie
    SELECT 
        MIN(date) AS min_date,
        MAX(date) AS max_date
    FROM initial
),
final AS ( -- join
    SELECT 
        i.*,
        SUBSTRING(i.date, 1, 4) AS year_clean  
    FROM initial i
    JOIN continue c
        ON i.date = c.min_date
        OR i.date = c.max_date
)
SELECT *
FROM final;

--priemerna mzda v rovnakych obdobiach
create view project_JF2  as
SELECT
    AVG(cp.value) AS avg_salary,
    cp.payroll_year
FROM project_2_jf2 pj 
JOIN czechia_payroll cp
    ON pj.year_clean::int = cp.payroll_year
WHERE cp.value_type_code = 5958
GROUP BY cp.payroll_year
ORDER BY cp.payroll_year;

-- Vysledok = Join oboch views + Case sloupec na vypočet kolik kg/l produktu lze koupit za mzdu
create view final_projekt2_JF as
with Projekt as (
select*
from project_2_jf2 pj 
join project_JF2 jp on pj.year_clean::int = jp.payroll_year
order by jp.payroll_year), projekt2 as (
select
value,
product_name,
date,
avg_salary,
round((avg_salary / value)::numeric,2) as Kolik_produktu_za_mesic
from projekt) select* from projekt2

select*
from final_projekt2_JF

-- Alternativny approach

WITH gg AS (
    SELECT
        cp.value AS value,
        cpc.name AS product_name,
        TO_CHAR(cp.date_from, 'YYYY-MM-DD') AS date
    FROM czechia_price cp
    JOIN czechia_price_category cpc 
        ON cp.category_code = cpc.code
    WHERE cp.category_code IN ('114201', '111301')
),
jj AS (
    SELECT 
        MIN(date) AS min_date,
        MAX(date) AS max_date
    FROM gg
),
ceny AS (
    SELECT
        ROUND(AVG(gg.value)::numeric, 2) AS cena,
        gg.product_name,
        DATE_TRUNC('year', TO_DATE(gg.date, 'YYYY-MM-DD')) AS rok
    FROM gg
    JOIN jj 
        ON gg.date = jj.min_date
        OR gg.date = jj.max_date
    GROUP BY 
        gg.product_name,
        DATE_TRUNC('year', TO_DATE(gg.date, 'YYYY-MM-DD'))
),
mzdy AS (
    SELECT
        payroll_year AS rok,
        AVG(value) AS avg_salary
    FROM czechia_payroll
    WHERE value_type_code = 5958
    GROUP BY payroll_year
)
SELECT
    c.product_name,
    c.rok,
    c.cena as cena_kg_l,
    m.avg_salary,
    ROUND((m.avg_salary / c.cena)::numeric, 2) AS kolko_kg_l_za_mzdu
FROM ceny c
LEFT JOIN mzdy m
    ON EXTRACT(YEAR FROM c.rok) = m.rok
ORDER BY c.rok, c.product_name;



























