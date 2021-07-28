Select * 
From ClimateChangeProject..NaturalDisasters

Select * 
From ClimateChangeProject..CO2Emissions

-- Total CO2 Emissions per year
-- Shows the drastic increases in emissions during certain periods
Select year, Sum(cumulative_co2) as Cumulative_CO2_Per_Year
From ClimateChangeProject..CO2Emissions
Group by year
Order by year

-- Compare population vs CO2 per year in USA
SELECT country, Year, co2, population, (co2/population) AS CO2_Per_Capita
FROM ClimateChangeProject..CO2Emissions
WHERE country like '%United States%'
ORDER BY year

-- Regions with the highest CO2 per capita emissions in 2019
Select country, MAX((co2/population)) as Highest_CO2_Per_Capita
FROM ClimateChangeProject..CO2Emissions
WHERE year = '2019'
GROUP BY country
ORDER BY MAX((co2/population)) DESC

-- Regions with the highest CO2 emissions in general
Select country, MAX(co2) as CO2_Emissions_2019
From ClimateChangeProject..CO2Emissions
WHERE year = '2019'AND country NOT LIKE '%World%' AND country NOT LIKE '%Asia%'
AND country NOT LIKE '%Europe%' AND country NOT LIKE '%Africa%' 
AND country NOT LIKE '%North America%' AND country NOT LIKE '%South America%'
AND country NOT LIKE '%EU%' AND country NOT LIKE '%International%'
GROUP BY country
ORDER BY MAX(CO2) DESC

-- Compare cumulative CO2 emissions and natural disasters world wide
-- Shows linear relationship between CO2 and natural disasters
Select country, CO2.year, cumulative_co2, Entity, Amount
FROM ClimateChangeProject..CO2Emissions CO2
JOIN ClimateChangeProject..NaturalDisasters NatDis
	ON CO2.year = NatDis.Year
WHERE Entity = 'All natural disasters' AND country LIKE '%World%'

-- Identify the years with the highest CO2 growth percentages and the highest growth percentages in natural disasters 
 Top 10 years with the highest co2 growth 
Select TOP 10 year, MAX(co2_growth_prct) as Highest_CO2_Growth
FROM ClimateChangeProject..CO2Emissions
WHERE country = 'World'
GROUP BY year
ORDER BY MAX(co2_growth_prct) DESC;

-- Top 10 years with the highest natural disasters growth percentages
Select TOP 10 year, Amount, ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100
AS Highest_ND_Growth
FROM ClimateChangeProject..NaturalDisasters
WHERE Entity = 'All natural disasters'
ORDER BY ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100 DESC;

-- Join the two tables into chronological order 
WITH CO2HighestGrowth (year, Percent_Growth, category)
AS
(
Select TOP 10 year, MAX(co2_growth_prct) as Percent_Growth, 'CO2' AS category
FROM ClimateChangeProject..CO2Emissions
WHERE country = 'World'
GROUP BY year
ORDER BY MAX(co2_growth_prct) DESC
), 
NatDisHighestGrowth (year, Percent_Growth, category) 
AS
(
Select TOP 10 year, ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100 AS Percent_Growth, 'Natural Disasters' AS category
FROM ClimateChangeProject..NaturalDisasters
WHERE Entity = 'All natural disasters'
ORDER BY ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100 DESC
)

SELECT *
FROM CO2HighestGrowth
UNION
SELECT *
FROM NatDisHighestGrowth
ORDER BY year


--VIEWS FOR FUTURE VISUALIZATIONS

-- Total CO2 Emissions per year
--Shows the drastic increases in emissions during certain periods
--CREATE VIEW CO2TL
--AS
--Select year, Sum(cumulative_co2) as Cumulative_CO2_Per_Year
--From ClimateChangeProject..CO2Emissions
--Group by year
--Order by year

---- Regions with the highest CO2 per capita emissions in 2019
--CREATE VIEW CO2PerCapita
--AS
--Select country, MAX((co2/population)) as Highest_CO2_Per_Capita
--FROM ClimateChangeProject..CO2Emissions
--WHERE year = '2019'
--GROUP BY country
--ORDER BY MAX((co2/population)) DESC

---- Regions with the highest CO2 emissions in general
--CREATE VIEW CO2Regions
--AS
--Select country, MAX(co2) as CO2_Emissions_2019
--From ClimateChangeProject..CO2Emissions
--WHERE year = '2019'AND country NOT LIKE '%World%' AND country NOT LIKE '%Asia%'
--AND country NOT LIKE '%Europe%' AND country NOT LIKE '%Africa%' 
--AND country NOT LIKE '%North America%' AND country NOT LIKE '%South America%'
--AND country NOT LIKE '%EU%' AND country NOT LIKE '%International%'
--GROUP BY country

---- Compare cumulative CO2 emissions and natural disasters world wide
--CREATE VIEW CO2vsNatDis
--AS
--Select country, CO2.year, cumulative_co2, Entity, Amount
--FROM ClimateChangeProject..CO2Emissions CO2
--JOIN ClimateChangeProject..NaturalDisasters NatDis
--	ON CO2.year = NatDis.Year
--WHERE Entity = 'All natural disasters' AND country LIKE '%World%'

---- Years with highest CO2 or natural disaster growth
--CREATE VIEW Apex_Years
--AS
--WITH CO2HighestGrowth (year, Percent_Growth, category)
--AS
--(
--Select TOP 10 year, MAX(co2_growth_prct) as Percent_Growth, 'CO2' AS category
--FROM ClimateChangeProject..CO2Emissions
--WHERE country = 'World'
--GROUP BY year
--ORDER BY MAX(co2_growth_prct) DESC
--), 
--NatDisHighestGrowth (year, Percent_Growth, category) 
--AS
--(
--Select TOP 10 year, ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100 AS Percent_Growth, 'Natural Disasters' AS category
--FROM ClimateChangeProject..NaturalDisasters
--WHERE Entity = 'All natural disasters'
--ORDER BY ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100 DESC
--)

--SELECT *
--FROM CO2HighestGrowth
--UNION
--SELECT *
--FROM NatDisHighestGrowth