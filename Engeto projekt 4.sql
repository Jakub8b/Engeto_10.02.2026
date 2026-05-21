-- Projekt 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--Vypočíta priemernú cenu a priemernú mzdu za každý rok z pôvodnej tabuľky. Slúži ako základná agregovaná tabuľka, z ktorej sa počítajú všetky ďalšie medziročné rozdiely.
WITH start AS (
    SELECT
        year,
        ROUND(AVG(avg_price_year)::numeric, 2) AS price,
        ROUND(AVG(avg_salary_year)::numeric, 0) AS salary
    FROM jakub_fecik_project_sql_primary_final
    GROUP BY year
),
--Tu sa pomocou funkcie LAG pridajú hodnoty ceny a mzdy z predchádzajúceho roka. Umožňuje to porovnávať aktuálny rok s minulým a počítať medziročné zmeny.
resume AS (
    SELECT
        *,
        LAG(price) OVER (ORDER BY year) AS prev_price,
        LAG(salary) OVER (ORDER BY year) AS prev_salary
    FROM start
),
--V tejto časti sa počítajú absolútne rozdiely medzi cenou a mzdou oproti predchádzajúcemu roku. Výsledkom sú hodnoty, ktoré ukazujú, o koľko sa cena a mzda reálne zvýšili alebo znížili.
diff AS (
    SELECT
        *,
        price - prev_price AS diff_price,
        salary - prev_salary AS diff_salary
    FROM resume
),
--Tu sa počítajú percentuálne medziročné zmeny ceny a mzdy. Percentá umožňujú porovnať dynamiku rastu aj v prípadoch, keď sú absolútne hodnoty veľmi rozdielne.
pcnt AS (
    SELECT
        *,
        ROUND((price - prev_price) / prev_price * 100, 2) AS pcnt_diff_price,
        ROUND((salary - prev_salary) / prev_salary * 100, 2) AS pcnt_diff_salary
    FROM diff
)
--Vo finálnom výbere sa porovnáva percentuálny rast ceny a mzdy a počíta sa ich rozdiel. Zároveň sa vytvára flag, ktorý označí roky, v ktorých je rozdiel medzi mzdami a cenami (>= 10 %).
SELECT
    year,
    price,
    salary,
    diff_price,
    diff_salary,
    pcnt_diff_price - pcnt_diff_salary AS pct_diff,
    CASE 
        WHEN pcnt_diff_salary >= 10 THEN 1
        ELSE 0
    END AS Flag_diff_10
FROM pcnt
where year is not null
ORDER BY year;