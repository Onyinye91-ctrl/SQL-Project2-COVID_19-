-- Create database
CREATE database projects;

-- Use database created
use projects;

select * 
from covid_19_data2;

-- Que 1.Retrieve the total confirmed, death, and recovered cases.
select sum(confirmed) as No_Confirmed, sum(deaths) as No_deaths, sum(recovered) as No_recovered
from covid_19_data2;

-- Que 2.Retrieve the total confirmed, deaths and recovered cases for the first quarter of each year of observation
select sum(confirmed) as No_Confirmed, sum(deaths) as No_deaths, sum(recovered) as No_recovered
from covid_19_data2
where month(observationdate) in (01, 02, 03) and year(observationdate) between 2019 and 2020;

-- Que 3.	Retrieve a summary of all the records. This should include the following information for each country:
-- ●	The total number of confirmed cases 
-- ●	The total number of deaths
-- ●	The total number of recoveries

select country, sum(confirmed) as No_Confirmed, sum(deaths) as No_deaths, sum(recovered) as No_recovered
from covid_19_data2
group by country;

-- Que 4.	Retrieve the percentage increase in the number of death cases from 2019 to 2020.
WITH year_metrics AS (
 SELECT 
   extract(year from ObservationDate) as year,
   SUM(Deaths) as death
 FROM covid_19_data2 
 GROUP BY year 
)
SELECT
year,
death,
  (death - LAG(death) OVER(order by year))/ LAG(death) OVER(order by year) * 100 AS percentage_increase
FROM year_metrics;

-- Que 5.Retrieve information for the top 5 countries with the highest confirmed cases
select country, sum(confirmed) as Confirmed_cases
from covid_19_data2
group by country
order by Confirmed_cases desc
limit 5;

-- Que 6.Compute the total number of drop (decrease) or increase in the confirmed cases from month to month in the 2 years of observation

WITH total_confirmed_by_month as(
 SELECT 
   extract(month from observationdate) as month,
   sum(Confirmed) as total_confirmed
 FROM covid_19_data2
 group by 1)

 select month, 
 total_confirmed - lag(total_confirmed) over(order by month) as decreased_increased_confirmed
 from total_confirmed_by_month;


