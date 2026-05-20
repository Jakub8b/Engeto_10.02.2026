-- Projekt 2
/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*/
WITH initiate AS (
    SELECT *
    FROM jakub_fecik_project_sql_primary_final
),
-- 1) ZISTUJEM MIN A MAX ROK 
hranice AS (
    SELECT
        TO_CHAR(MIN(date_from), 'YYYY-MM-DD') AS min_date,
        TO_CHAR(MAX(date_from), 'YYYY-MM-DD') AS max_date,
        EXTRACT(YEAR FROM MIN(date_from)) AS min_rok,
        EXTRACT(YEAR FROM MAX(date_from)) AS max_rok
    FROM initiate
),
-- 2) ZISTUJEM CENY PRODUKTOV LEN PRE MIN/MAX ROK
ceny AS (
    SELECT
        i.product_name,
        i.payroll_year AS rok,
        ROUND(AVG(i.avg_price_year)::numeric, 2) AS cena
    FROM initiate i
    JOIN hranice h
        ON i.payroll_year IN (h.min_rok, h.max_rok)
        where i.product_name in ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
    GROUP BY i.product_name, i.payroll_year
),
-- 3) ZISTUJEM MZDY LEN PRE MIN/MAX ROK
mzdy AS (
    SELECT
        payroll_year AS rok,
        ROUND(AVG(avg_salary_year)::numeric, 2) AS avg_salary
    FROM initiate
    WHERE value_type_code = 5958
      AND calculation_code = 100
      AND payroll_year IN (
            SELECT min_rok FROM hranice
            UNION
            SELECT max_rok FROM hranice
      )
    GROUP BY payroll_year
)
-- 4) FINÁLNY VÝSTUP
SELECT
    c.product_name,
    c.rok,
    c.cena AS cena_kg_l,
    m.avg_salary,
    ROUND((m.avg_salary / c.cena)::numeric, 2) AS kolko_kg_l_za_mzdu
FROM ceny c
LEFT JOIN mzdy m
    ON c.rok = m.rok
ORDER BY c.rok, c.product_name;
