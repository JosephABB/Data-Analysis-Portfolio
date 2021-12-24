/*
Climate Change & Natural Disaster Data Exploration
*/


SELECT * 
FROM ClimateChangeProject..NaturalDisasters;

SELECT * 
FROM ClimateChangeProject..CO2Emissions;


-- Total CO2 Emissions per year
-- Shows the constant increase in emissions
SELECT year, Sum(cumulative_co2) AS Cumulative_CO2_Per_Year
FROM ClimateChangeProject..CO2Emissions
GROUP BY year
ORDER BY year


-- Compare population vs CO2 per year in USA
SELECT country, Year, co2, population, (co2/population) AS CO2_Per_Capita
FROM ClimateChangeProject..CO2Emissions
WHERE country like '%United States%'
ORDER BY year


-- Regions with the highest CO2 per capita emissions in 2019
SELECT country, MAX((co2/population)) AS Highest_CO2_Per_Capita
FROM ClimateChangeProject..CO2Emissions
WHERE year = '2019'
GROUP BY country
ORDER BY MAX((co2/population)) DESC


-- Continents by total CO2 emissions in 2019
SELECT country, MAX(co2) AS emissions
FROM ClimateChangeProject..CO2Emissions
WHERE year = '2019' AND iso_code = 'CONT' 
GROUP BY country
ORDER BY MAX(CO2) DESC


-- Countries by total CO2 emissions in 2019
SELECT country, MAX(co2) AS CO2_Emissions_2019
FROM ClimateChangeProject..CO2Emissions
WHERE year = '2019'AND iso_code != 'CONT' AND country != 'World'
GROUP BY country
ORDER BY MAX(CO2) DESC


-- Compare cumulative CO2 emissions and natural disasters world wide
-- Shows linear relationship between CO2 and natural disasters
Select CO2.year, cumulative_co2, Amount AS natural_disasters
FROM ClimateChangeProject..CO2Emissions CO2
JOIN ClimateChangeProject..NaturalDisasters NatDis
	ON CO2.year = NatDis.Year
WHERE Entity = 'All natural disasters' AND country LIKE '%World%'


--Top 10 years with the highest co2 growth 
SELECT TOP 10 year, MAX(co2_growth_prct) AS co2_growth_pct
FROM ClimateChangeProject..CO2Emissions
WHERE country = 'World'
GROUP BY year
ORDER BY MAX(co2_growth_prct) DESC;


-- Top 10 years with the highest natural disasters growth percentages
Select TOP 10 year, Amount, ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100
AS nat_disaster_growth_pct
FROM ClimateChangeProject..NaturalDisasters
WHERE Entity = 'All natural disasters'
ORDER BY ((Amount/lag(Amount, 1) OVER (ORDER BY Year)) - 1) * 100 DESC;


-- Countries with the most co2 pollution per year (1900-2019)
SELECT CO2Emissions.country, CO2Emissions.year, CO2Emissions.co2
FROM ClimateChangeProject..CO2Emissions
INNER JOIN (
	SELECT year, MAX(co2) MaxCO2
	FROM ClimateChangeProject..CO2Emissions
	WHERE country != 'World' AND iso_code != 'CONT'
	GROUP BY year
) MaxCO2PerYear
ON MaxCO2PerYear.year = CO2Emissions.year
AND MaxCO2PerYear.MaxCO2 = CO2Emissions.co2
WHERE country != 'World' AND iso_code != 'CONT'
ORDER BY CO2Emissions.year DESC;
