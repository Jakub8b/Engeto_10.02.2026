-- Projekt 1
--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
--Ročné porovnanie mezd
--Táto časť vyberá len relevantné riadky pre mzdy podľa kódov value_type_code = 5958 a calculation_code = 100
WITH payroll_clean AS (
    SELECT DISTINCT
        payroll_year,
        industry_name,
        avg_salary_year AS payroll_value
    FROM jakub_fecik_project_SQL_primary_final
    WHERE value_type_code = 5958
      AND calculation_code = 100
),agg AS (
--Vypočíta priemernú mzdu.
    SELECT
        industry_name,
        payroll_year,
        AVG(payroll_value) AS avg_salary
    FROM payroll_clean
    GROUP BY industry_name, payroll_year
),
--V tejto časti sa pomocou LAG() vypočíta mzda z predchádzajúceho roka pre každé odvetvie. Následne sa určí rozdiel medzi rokmi a slovne sa označí trend (rast, pokles alebo stagnácia).
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
--Výsledkom je prehľad všetkých odvetví s medziročnými zmenami miezd a trendom. Dáta sú zoradené podľa odvetvia a roku, aby bolo jasne vidieť vývoj v čase.
SELECT *
FROM final
ORDER BY industry_name, payroll_year;