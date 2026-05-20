-- Primárna tabulka
-- Snažím sa získať skutočný ročný priemer mzdy pre dané odvetvie
CREATE TABLE payroll_yearly AS
WITH yearly AS (
    SELECT
        cp.payroll_year,
        cp.industry_branch_code,
        AVG(cp.value) AS avg_salary_year
    FROM czechia_payroll cp
    WHERE cp.value_type_code = 5958
      AND cp.calculation_code = 100
    GROUP BY cp.payroll_year, cp.industry_branch_code
)
SELECT
    cp.*,
    cpib.name AS industry_name,
    y.avg_salary_year
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
    ON cp.industry_branch_code = cpib.code
JOIN yearly y
    ON cp.payroll_year = y.payroll_year
   AND cp.industry_branch_code = y.industry_branch_code
WHERE cp.value_type_code = 5958
  AND cp.calculation_code = 100;

--Snažím sa získať skutočný ročný priemer ceny pre daný produkt
CREATE TABLE price_yearly AS
SELECT
    cp2.*,
    cpc.name AS product_name,
    cpc.price_unit,
    cpc.price_value,
    EXTRACT(YEAR FROM cp2.date_from)::int AS price_year,
    -- priemer za rok × produkt (všetky regióny dokopy)
    AVG(cp2.value) OVER (
        PARTITION BY EXTRACT(YEAR FROM cp2.date_from), cp2.category_code
    ) AS avg_price_year
FROM czechia_price cp2
JOIN czechia_price_category cpc 
    ON cp2.category_code = cpc.code;

-- Redukcia počtu riadkov z tabulky price_yearly
CREATE TABLE price_yearly_dedup AS
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY price_year, category_code
            ORDER BY date_from
        ) AS rn
    FROM price_yearly
) x
WHERE rn = 1;
-- Join tabuliek payroll a price, ktoré boli zagregované podľa rokov.
create TABLE jakub_fecik_project_SQL_primary_final AS
SELECT
    py.value,
    py.value_type_code,
    py.calculation_code,
    py.payroll_year,
    py.industry_name,
    py.avg_salary_year,
    pd.product_name,
    pd.avg_price_year,
     pd.price_value,
    pd.price_unit,  
    extract(year from pd.date_from)::int as year,
    pd.date_from
FROM payroll_yearly py
LEFT JOIN price_yearly_dedup pd
    ON py.payroll_year = pd.price_year
ORDER BY py.payroll_year, py.industry_name;