--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- Projekt 4 - Je nutne zagregovat všetky potraviny podla roku zo všetkymi povolaniami miezd podla rokov???
-- = select % narast mezd (projekt 1) + % narast cien potravin (projekt 3) a pridaj stlpec (1. stlpec - 2. stlpec) % rozdiely a pridaj Case flag 1 k tým u ktorých je rozdiel > 10% 
-- Potom select iba flag 1 = rok v ktorom je rozdiel > 10% 

--Priemerné ceny potravín za roky
SELECT
    ROUND(AVG(cp.value)::numeric, 2) AS cena,
    date_part('year', cp.date_from) AS rok
FROM czechia_price cp
GROUP BY date_part('year', cp.date_from)
ORDER BY rok;

-- Priemerné mzdy za roky
  SELECT
        round(avg(cp.value)::numeric,0) as mzda,
        cp.payroll_year
    FROM czechia_payroll cp
    WHERE value_type_code = 5958
    group by cp.payroll_year
    order by cp.payroll_year
    
    -- join mezd a cen potravin
    WITH ceny AS (
    SELECT
        ROUND(AVG(cp.value)::numeric, 2) AS cena,
        date_part('year', cp.date_from) AS rok
    FROM czechia_price cp
    GROUP BY date_part('year', cp.date_from)
),
mzdy AS (
    SELECT
        ROUND(AVG(cp.value)::numeric, 0) AS mzda,
        cp.payroll_year AS rok
    FROM czechia_payroll cp
    WHERE value_type_code = 5958
    GROUP BY cp.payroll_year
)
SELECT
    c.rok,
    c.cena,
    m.mzda
FROM ceny c
JOIN mzdy m USING (rok)
ORDER BY c.rok;

-- +Case % diff LAG ceny a LAG mzdy + flag sloupec který ukaže % rozdíl narustu cen a mezd který >=10%

create view Final_projekt4_jf as
WITH ceny AS (
    SELECT
        date_part('year', cp.date_from) AS rok,
        ROUND(AVG(cp.value)::numeric, 2) AS cena
    FROM czechia_price cp
    GROUP BY date_part('year', cp.date_from)
),
mzdy AS (
    SELECT
        cp.payroll_year AS rok,
        ROUND(AVG(cp.value)::numeric, 0) AS mzda
    FROM czechia_payroll cp
    WHERE value_type_code = 5958
    GROUP BY cp.payroll_year
),
joined AS (
    SELECT
        c.rok,
        c.cena,
        m.mzda
    FROM ceny c
    JOIN mzdy m USING (rok)
),
lagy AS (
    SELECT
        rok,
        cena,
        mzda,
        cena - LAG(cena) OVER (ORDER BY rok) AS diff_cena,
        mzda - LAG(mzda) OVER (ORDER BY rok) AS diff_mzda,
        ROUND(
            (cena - LAG(cena) OVER (ORDER BY rok)) 
            / NULLIF(LAG(cena) OVER (ORDER BY rok), 0) * 100,
            2
        ) AS pct_diff_cena,
        ROUND(
            (mzda - LAG(mzda) OVER (ORDER BY rok)) 
            / NULLIF(LAG(mzda) OVER (ORDER BY rok), 0) * 100,
            2
        ) AS pct_diff_mzda
    FROM joined
)
SELECT
    rok,
    cena,
    mzda,
    pct_diff_cena,
    pct_diff_mzda,
    ROUND(ABS(pct_diff_cena - pct_diff_mzda), 2) AS rozdiel_pct,
    CASE 
        WHEN ABS(pct_diff_cena - pct_diff_mzda) >= 10 THEN 1
        ELSE 0
    END AS flag_rozdiel_10
FROM lagy
ORDER BY rok;

select* from final_projekt4_jf fpj 








