-- Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

create table Additional_table_EUGDP as 
select
c.country,
e.year,
e.gdp,
e.population,
round((e.gdp / e.population)::numeric,2) as gdp_per_capita,
e.gini
from economies e
join countries c 
on e.country = c.country
where continent = 'Europe'
and year >= '2006'and year <= '2018'
order by e."year", c.country;
