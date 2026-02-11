select*
from healthcare_provider as hp

select
name,
provider_type
from healthcare_provider hp
limit 20; 


select
name,
provider_type,
region_code
from healthcare_provider hp
order by  region_code asc

select
name,
region_code,
district_code
from healthcare_provider hp 
order by district_code desc
limit 500;

select*
from czechia_region cr 

select*
from czechia_district cd 

select*
from healthcare_provider hp 
where region_code != 'CZ010'

select 
name,
phone,
fax,
email,
website
from healthcare_provider hp 
where hp.region_code != 'CZ010'

SELECT 
name,
region_code,
hp.residence_region_code 
FROM healthcare_provider hp 
WHERE hp.residence_region_code = hp.region_code 

SELECT 
name,
phone
FROM healthcare_provider hp 
WHERE phone IS NOT null

SELECT
    name,
    region_code
FROM healthcare_provider hp
WHERE 
district_code = 'CZ0201'
OR district_code  = 'CZ0202'
ORDER BY hp.district_code ;

SELECT
    name,
    region_code
FROM healthcare_provider hp
WHERE 
district_code = 'CZ0201'
OR district_code  = 'CZ0202'
ORDER BY hp.district_code ;

SELECT
    name,
    region_code
FROM healthcare_provider hp
WHERE hp.district_code IN ('CZ0201', 'CZ0202')
ORDER BY hp.district_code;


--Tvorba Tabulek

CREATE TABLE T_engeto_providers_Jihomoravskykraj AS 
SELECT*
FROM healthcare_provider hp 
WHERE region_code = 'CZ064'


SELECT*
FROM healthcare_provider hp 
WHERE region_code = 'CZ064'

CREATE TABLE T_Jakub_F_resume 
(date_start date,
date_end date,
education varchar(30),
job varchar (30)
);

INSERT INTO t_jakub_f_resume 
VALUES ('10.2.2026', null, 'škola života', null),
('1.1.2026',NULL,'UPJŠ',null)
;

ALTER TABLE t_jakub_f_resume 
ADD COLUMN institution varchar (255),
ADD COLUMN ROLE varchar (255);

DELETE FROM t_jakub_f_resume 
WHERE education = 'škola života';

UPDATE t_jakub_f_resume 
SET institution ='Engeto', ROLE = 'student'
where education ='UPJŠ';

ALTER TABLE t_jakub_f_resume 
DROP COLUMN education,
DROP COLUMN job;

DROP TABLE t_jakub_f_resume 

DROP TABLE T_engeto_providers_Jihomoravskykraj







































