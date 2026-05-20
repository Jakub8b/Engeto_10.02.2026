-- Projekt 3
--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

-- 1) ENTER: Výber surových dát z novej tabuľky
--    value = cena produktu
--    product_name = názov potraviny
--    date_from = dátum merania ceny
--    payroll_year = rok, ktorý použijeme na ročné agregácie
CREATE VIEW project_jf3_2 as
WITH enter AS (
    SELECT
        i.value::numeric(12,2) AS value,
        i.product_name AS potraviny,
        i.date_from::date AS date,
        i.payroll_year AS year
    FROM jakub_fecik_project_sql_primary_final i
    WHERE i.product_name IS NOT NULL
),
-- 2) YEARLY: Priemerná cena potraviny za každý rok
--    agregujem ceny podľa názvu potraviny a roku
yearly AS (
    SELECT
        potraviny,
        year,
        AVG(value)::numeric(12,2) AS avg_value_per_year
    FROM enter
    GROUP BY potraviny, year
),
-- 3) YOY: Medziročné porovnanie (Year-over-Year)
--    LAG() nám vráti cenu z predchádzajúceho roka
yoy AS (
    SELECT
        potraviny,
        year,
        avg_value_per_year,
        LAG(avg_value_per_year) OVER (PARTITION BY potraviny ORDER BY year) AS prev_year_value
    FROM yearly
),
-- 4) GROWTH: Výpočet medziročného rastu
--    absolute_growth = rozdiel medzi rokmi
--    percent_growth = percentuálna zmena medzi rokmi
growth AS (
    SELECT
        potraviny,
        year,
        avg_value_per_year,
        prev_year_value,
        (avg_value_per_year - prev_year_value)::numeric(12,2) AS absolute_growth,
        ((avg_value_per_year - prev_year_value) / NULLIF(prev_year_value, 0) * 100)::numeric(12,2) AS percent_growth
    FROM yoy
    WHERE prev_year_value IS NOT NULL
),
-- 5) AVG_GROWTH: Priemerné medziročné zdražovanie pre každú potravinu
avg_growth AS (
    SELECT
        potraviny,
        AVG(percent_growth)::numeric(12,2) AS avg_percent_growth
    FROM growth
    GROUP BY potraviny
),
-- 6) RANKED: Poradie potravín podľa rýchlosti zdražovania
--    najnižší rast = najpomalšie zdražovanie = rank 1
ranked AS (
    SELECT
        potraviny,
        avg_percent_growth,
        DENSE_RANK() OVER (ORDER BY avg_percent_growth) AS growth_rank
    FROM avg_growth
)
-- 7) FINÁLNY SELECT: Spojenie medziročných dát s rankingom
SELECT
    g.potraviny,
    g.year,
    g.avg_value_per_year,
    g.prev_year_value,
    g.absolute_growth,
    g.percent_growth,
    r.avg_percent_growth,
    r.growth_rank
FROM growth g
JOIN ranked r USING (potraviny)
ORDER BY r.growth_rank, g.potraviny, g.year;

CREATE VIEW final_projekt3_jf_ as
-- Výber unikátnych potravín s ich priemerným percentuálnym zdražovaním a poradím podľa rýchlosti zdražovania
SELECT DISTINCT
    potraviny,
    avg_percent_growth AS "priemerne_percent_zdražovanie",
    growth_rank AS "najpomalšie_zdražovanie"
FROM project_jf3
ORDER BY growth_rank;
