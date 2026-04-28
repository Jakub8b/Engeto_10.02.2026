-- finished projekt 3
--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

CREATE VIEW project_jf3
AS WITH enter AS (
         SELECT cp.value::numeric(12,2) AS value,
            cpc.name AS potraviny,
            cp.date_from::date AS date,
            EXTRACT(year FROM cp.date_from)::integer AS year
           FROM data_academy_content.czechia_price cp
             JOIN data_academy_content.czechia_price_category cpc ON cp.category_code = cpc.code
        ), yearly AS (
         SELECT enter.potraviny,
            enter.year,
            avg(enter.value)::numeric(12,2) AS avg_value_per_year
           FROM enter
          GROUP BY enter.potraviny, enter.year
        ), yoy AS (
         SELECT yearly.potraviny,
            yearly.year,
            yearly.avg_value_per_year,
            lag(yearly.avg_value_per_year) OVER (PARTITION BY yearly.potraviny ORDER BY yearly.year) AS prev_year_value
           FROM yearly
        ), growth AS (
         SELECT yoy.potraviny,
            yoy.year,
            yoy.avg_value_per_year,
            yoy.prev_year_value,
            (yoy.avg_value_per_year - yoy.prev_year_value)::numeric(12,2) AS absolute_growth,
            ((yoy.avg_value_per_year - yoy.prev_year_value) / NULLIF(yoy.prev_year_value, 0::numeric) * 100::numeric)::numeric(12,2) AS percent_growth
           FROM yoy
          WHERE yoy.prev_year_value IS NOT NULL
        ), avg_growth AS (
         SELECT growth.potraviny,
            avg(growth.percent_growth)::numeric(12,2) AS avg_percent_growth
           FROM growth
          GROUP BY growth.potraviny
        ), ranked AS (
         SELECT avg_growth.potraviny,
            avg_growth.avg_percent_growth,
            dense_rank() OVER (ORDER BY avg_growth.avg_percent_growth) AS growth_rank
           FROM avg_growth
        )
 SELECT g.potraviny,
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

-- FINAL

CREATE VIEW final_projekt3_jf
AS SELECT DISTINCT potraviny,
    avg_percent_growth AS "priemerne_percent_zdražovanie",
    growth_rank AS "najpomalšie_zdražovanie"
   FROM data_academy_content.project_jf3
  ORDER BY growth_rank;

select* from final_projekt3_jf fpj 







