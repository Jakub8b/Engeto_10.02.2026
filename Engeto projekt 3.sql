-- Projekt 3 -- NÍŽE je taky alternativa bez použití Views

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


--PROJEKT 3 - ALT. VERZIA BEZ POUŽITIA VIEWS

WITH enter AS (
    -- Tento CTE načítava surové dáta o cenách potravín z pôvodných tabuliek a dopĺňa k nim názov kategórie. 
    -- Zároveň extrahuje rok z dátumu, aby bolo možné vykonávať ročné agregácie.
    SELECT
        cp.value::numeric(12,2) AS value,
        cpc.name AS potraviny,
        cp.date_from::date AS date,
        EXTRACT(year FROM cp.date_from)::integer AS year
    FROM data_academy_content.czechia_price cp
    JOIN data_academy_content.czechia_price_category cpc 
        ON cp.category_code = cpc.code
),
yearly AS (
    -- Tento CTE počíta priemernú cenu každej potraviny za jednotlivé roky. 
    -- Slúži ako základ pre medziročné porovnanie cien.
    SELECT
        potraviny,
        year,
        AVG(value)::numeric(12,2) AS avg_value_per_year
    FROM enter
    GROUP BY potraviny, year
),
yoy AS (
    -- Tento CTE dopĺňa ku každému roku cenu z predchádzajúceho roka pomocou analytickej funkcie LAG. 
    -- Umožňuje tak vypočítať medziročné zmeny cien.
    SELECT
        potraviny,
        year,
        avg_value_per_year,
        LAG(avg_value_per_year) OVER (
            PARTITION BY potraviny ORDER BY year
        ) AS prev_year_value
    FROM yearly
),
growth AS (
    -- Tento CTE počíta absolútny aj percentuálny medziročný rast ceny pre každú potravinu. 
    -- Záznamy bez predchádzajúceho roka sú vylúčené, aby sa predišlo neúplným výpočtom.
    SELECT
        potraviny,
        year,
        avg_value_per_year,
        prev_year_value,
        (avg_value_per_year - prev_year_value)::numeric(12,2) AS absolute_growth,
        ((avg_value_per_year - prev_year_value) 
            / NULLIF(prev_year_value, 0) * 100)::numeric(12,2) AS percent_growth
    FROM yoy
    WHERE prev_year_value IS NOT NULL
),
avg_growth AS (
    -- Tento CTE počíta priemerné percentuálne zdražovanie pre každú potravinu naprieč všetkými rokmi. 
    -- Výsledok predstavuje dlhodobý trend rastu cien jednotlivých položiek.
    SELECT
        potraviny,
        AVG(percent_growth)::numeric(12,2) AS avg_percent_growth
    FROM growth
    GROUP BY potraviny
),
ranked AS (
    -- Tento CTE priraďuje potravinám poradie podľa rýchlosti ich zdražovania. 
    -- Nižšie poradie znamená pomalšie zdražovanie a teda stabilnejšiu cenu.
    SELECT
        potraviny,
        avg_percent_growth,
        DENSE_RANK() OVER (ORDER BY avg_percent_growth) AS growth_rank
    FROM avg_growth),
semi_final AS (
    -- Tento CTE spája medziročné dáta s dlhodobým priemerným rastom a poradie potravín. 
    -- Výsledkom je kompletný dataset obsahujúci všetky potrebné metriky pre finálny výstup.
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
)
-- Finálny výber zobrazuje iba unikátne potraviny s ich priemerným percentuálnym zdražovaním a poradím. 
-- Slúži ako prehľadná sumarizácia výsledkov pre ďalšiu analýzu alebo vizualizáciu.
SELECT DISTINCT
    potraviny,
    avg_percent_growth AS "priemerne_percent_zdražovanie",
    growth_rank AS "najpomalšie_zdražovanie"
FROM semi_final
ORDER BY growth_rank;
    
    
    
    
    
    
    