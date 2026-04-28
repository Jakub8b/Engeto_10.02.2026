-- Projekt 1.Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-- Kvartalne porovnanie miezd
WITH gg AS (
    SELECT
        cp.value,
        cp.payroll_year,
        cp.payroll_quarter,
        cpib.name AS odvetvie
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch cpib 
        ON cp.industry_branch_code = cpib.code
    WHERE value_type_code = 5958
      AND cp.calculation_code = 100
),
final AS (
    SELECT
        *,
        value - LAG(value) OVER (
            PARTITION BY odvetvie 
            ORDER BY payroll_year, payroll_quarter
        ) AS rozdil,
        CASE 
            WHEN value > LAG(value) OVER (
                PARTITION BY odvetvie 
                ORDER BY payroll_year, payroll_quarter
            ) THEN 'growth'
            WHEN value < LAG(value) OVER (
                PARTITION BY odvetvie 
                ORDER BY payroll_year, payroll_quarter
            ) THEN 'decrease'
            ELSE 'no change'
        END AS trend
    FROM gg
)
SELECT *
FROM final
ORDER BY odvetvie, payroll_year, payroll_quarter;

--Projekt 1 Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
--Ročné porovnanie mezd

WITH gg AS (
    SELECT
        AVG(cp.value) AS avg_salary,
        cp.payroll_year::int AS payroll_year,
        cpib.name AS odvetvie
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch cpib 
        ON cp.industry_branch_code = cpib.code
    WHERE value_type_code = 5958
      AND cp.calculation_code = 100
    GROUP BY cp.payroll_year, cpib.name
),
final AS (
    SELECT
        *,
        LAG(avg_salary) OVER (
            PARTITION BY odvetvie 
            ORDER BY payroll_year
        ) AS previous_year_salary,
        avg_salary - LAG(avg_salary) OVER (
            PARTITION BY odvetvie 
            ORDER BY payroll_year
        ) AS rozdil,
        CASE 
            WHEN avg_salary > LAG(avg_salary) OVER (
                PARTITION BY odvetvie 
                ORDER BY payroll_year
            ) THEN 'growth'
            WHEN avg_salary < LAG(avg_salary) OVER (
                PARTITION BY odvetvie 
                ORDER BY payroll_year
            ) THEN 'decrease'
            ELSE 'no change'
        END AS trend
    FROM gg
)
SELECT *
FROM final
ORDER BY odvetvie, payroll_year;



























