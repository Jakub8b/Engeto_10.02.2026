-- Projekt 5
/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

--Táto časť načítava hodnoty HDP pre Českú republiku z tabuľky additional_table_eugdp. Slúži ako základný makroekonomický údaj, ktorý sa bude porovnávať s mzdami a cenami.
WITH gdp AS (
    SELECT 
        country,
        year,
        gdp
    FROM additional_table_eugdp
    WHERE country = 'Czech Republic'
),
--Táto časť počíta priemerné ceny potravín za jednotlivé roky
prices AS (
    SELECT
        year,
        ROUND(AVG(avg_price_year)::numeric, 2) AS avg_price
    FROM jakub_fecik_project_sql_primary_final
    GROUP BY year
),
--Tu sa vypočítava priemerná hrubá mzda za každý rok
salary AS (
    SELECT
        year,
        ROUND(AVG(avg_salary_year)::numeric, 0) AS avg_salary
    FROM jakub_fecik_project_sql_primary_final
    WHERE value_type_code = '5958'
    GROUP BY year
),
--Táto časť spája HDP, mzdy a ceny do jednej prehľadnej tabuľky podľa roku. Zároveň filtruje len roky od 1999 
base AS (
    SELECT
        g.year,
        g.gdp,
        s.avg_salary,
        p.avg_price
    FROM gdp g
    LEFT JOIN salary s ON g.year = s.year
    LEFT JOIN prices p ON g.year = p.year
    WHERE g.gdp IS NOT NULL
      AND g.year >= 1999
),
--V tejto časti sa počítajú medziročné rozdiely HDP, miezd a cien pomocou funkcie LAG
final AS (
    SELECT
        year AS Rok,
        ROUND(gdp::numeric, 0) AS HDP,
        ROUND((gdp - LAG(gdp) OVER (ORDER BY year))::numeric, 0) AS HDP_rozdiel,
        avg_salary AS priemer_mzda,
        avg_salary - LAG(avg_salary) OVER (ORDER BY year) AS rozdiel_mzda,
        avg_price AS priemer_cena_potravin,
        avg_price - LAG(avg_price) OVER (ORDER BY year) AS rozdiel_ceny_potravin
    FROM base
)
SELECT *
FROM final
ORDER BY Rok;
