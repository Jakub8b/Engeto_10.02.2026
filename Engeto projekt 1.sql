-- Projekt 1
--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
--Ročné porovnanie mezd
WITH payroll_clean AS (
    SELECT DISTINCT
        payroll_year,
        industry_name,
        avg_salary_year AS payroll_value
    FROM jakub_fecik_project_SQL_primary_final
    WHERE value_type_code = 5958
      AND calculation_code = 100
),
agg AS (
    SELECT
        industry_name,
        payroll_year,
        AVG(payroll_value) AS avg_salary
    FROM payroll_clean
    GROUP BY industry_name, payroll_year
),
final AS (
    SELECT
        industry_name,
        payroll_year,
        avg_salary,
        LAG(avg_salary) OVER (
            PARTITION BY industry_name
            ORDER BY payroll_year
        ) AS previous_year_salary,
        avg_salary - LAG(avg_salary) OVER (
            PARTITION BY industry_name
            ORDER BY payroll_year
        ) AS difference,
        CASE 
            WHEN avg_salary > LAG(avg_salary) OVER (
                PARTITION BY industry_name
                ORDER BY payroll_year
            ) THEN 'growth'
            WHEN avg_salary < LAG(avg_salary) OVER (
                PARTITION BY industry_name
                ORDER BY payroll_year
            ) THEN 'decrease'
            ELSE 'no change'
        END AS trend
    FROM agg
)
SELECT *
FROM final
ORDER BY industry_name, payroll_year;