-- projekt 5
/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

with gdp as (
select 
country,
year,
gdp
from economies e 
where country = 'Czech Republic'), prices as (
SELECT
    cpc.name AS product_name,
    EXTRACT(YEAR FROM cp.date_from) AS year,
    ROUND(AVG(cp.value)::numeric, 2) AS avg_price
FROM czechia_price cp
JOIN czechia_price_category cpc 
    ON cp.category_code = cpc.code
GROUP BY
    cpc.name,
    EXTRACT(YEAR FROM cp.date_from)
ORDER BY
    cpc.name,
    year), salary as (
    select
    round(avg(cp.value)::numeric,0) as value,
    cp.payroll_year
    from czechia_payroll as cp
    join czechia_payroll_industry_branch as cpi 
    on cp.industry_branch_code = cpi.code
    where cp.value_type_code = '5958'
    group by cp.payroll_year), join as (
    select* from gdp
    join prices on year = year
    join salary on year = year) select* from join
    -- fixed version
    
    create view project_5_JF as 
    
    WITH gdp AS (
    SELECT 
        country,
        year,
        gdp
    FROM economies e 
    WHERE country = 'Czech Republic'
),
prices AS (
    SELECT
        EXTRACT(YEAR FROM cp.date_from) AS year,
        ROUND(AVG(cp.value)::numeric, 2) AS avg_price
    FROM czechia_price cp
    GROUP BY EXTRACT(YEAR FROM cp.date_from)
),
salary AS (
    SELECT
        cp.payroll_year AS year,
        ROUND(AVG(cp.value)::numeric, 0) AS avg_salary
    FROM czechia_payroll cp
    WHERE cp.value_type_code = '5958'
    GROUP BY cp.payroll_year
)
SELECT
    g.year,
    g.gdp,
    s.avg_salary,
    p.avg_price
FROM gdp g
LEFT JOIN salary s ON g.year = s.year
LEFT JOIN prices p ON g.year = p.year
where gdp is not null
and g.year >= 2000
ORDER BY g.year;

select
year,
round(gdp::numeric,0),
round((gdp - lag(gdp) over (order by year))::numeric,0) as GDP_diff,
avg_salary,
avg_salary - lag(avg_salary) over (order by year) as salary_diff,
avg_price,
avg_price - lag(avg_price) over (order by year) as price_diff
from project_5_JF

    
    -- AI
    WITH gdp AS (
    SELECT 
        country,
        year,
        gdp
    FROM economies e 
    WHERE country = 'Czech Republic'
),
prices AS (
    SELECT
        EXTRACT(YEAR FROM cp.date_from) AS year,
        ROUND(AVG(cp.value)::numeric, 2) AS avg_price
    FROM czechia_price cp
    GROUP BY EXTRACT(YEAR FROM cp.date_from)
),
salary AS (
    SELECT
        cp.payroll_year AS year,
        ROUND(AVG(cp.value)::numeric, 0) AS avg_salary
    FROM czechia_payroll cp
    WHERE cp.value_type_code = '5958'   -- průměrná hrubá mzda
    GROUP BY cp.payroll_year
)
SELECT
    g.year,
    g.gdp,
    s.avg_salary,
    p.avg_price
FROM gdp g
LEFT JOIN salary s ON g.year = s.year
LEFT JOIN prices p ON g.year = p.year
where gdp is not null
ORDER BY g.year;


