SELECT*
FROM covid19_basic cb 
LIMIT 20;

SELECT*
FROM covid19_basic cb 
ORDER BY date DESC -- or "ASC"

SELECT 
country,
date
FROM covid19_basic cb 

SELECT
country,
date,
confirmed 
FROM covid19_basic cb 	
WHERE country = 'Austria'

SELECT*
FROM covid19_basic cb 
WHERE date = '2020-08-30' 
AND country = 'Czechia' -- + Filter jenom pro Česko

SELECT*
FROM covid19_basic cb 
WHERE country IN ('Czechia', 'Austria')
ORDER BY date asc

SELECT*
FROM covid19_basic cb 
WHERE confirmed = '1000'
OR confirmed ='100000'

SELECT*
FROM covid19_basic cb 
WHERE confirmed BETWEEN '10' AND '20'
and date = '2020-08-30'
--Ekvivalent
SELECT*
FROM covid19_basic cb 
WHERE confirmed >= '10'
AND confirmed <= '20'
AND date = '2020-08-30'

SELECT*
FROM covid19_basic cb 
WHERE confirmed > '1000000'
AND date = '2020-08-15;'


SELECT 
date,
country,
confirmed
FROM covid19_basic cb 
WHERE country IN ('United Kingdom','France')  -- v Zadání Ukol 15. - chyba "Anglie = United Kingdom"
ORDER BY date DESC;

SELECT*
FROM covid19_basic_differences cbd 
WHERE confirmed  > '0'
AND country = 'Czechia'
AND date >= '2020-09-01'
AND date <= '2020-09-30';


SELECT 
country,
population
FROM lookup_table lt 
WHERE country = 'Austria'

SELECT
country,
population
FROM lookup_table lt 
WHERE population > '500000000';

SELECT 
date,
country,
confirmed
FROM covid19_basic cb 
WHERE country ='India'
AND date = '2020-08-30';

SELECT 
date,
province,
sum (confirmed) AS Total_confirmed
FROM covid19_detail_us cdu 
WHERE date = '2020-08-30'
AND province = 'Florida'
GROUP BY date, province;

SELECT
   admin2,
   confirmed
FROM covid19_detail_us
WHERE province = 'Florida'
   AND date = '2020-08-30';

SELECT 
date,
country,
sum (confirmed) AS total_confirmed
FROM covid19_basic cb 
WHERE country = 'India'
AND date = '2020-08-30'
GROUP BY date, country;




















