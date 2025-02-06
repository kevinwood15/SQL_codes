*searching for a city near my location
SELECT DISTINCT city, country
FROM city_data
WHERE country = 'United States'

*pull city level data for Dallas, TX
SELECT city, avg_temp, year
FROM city_data
WHERE city = 'Dallas'
ORDER BY year 

*data in Dallas, TX ranges from 1820 to 2013, so I pull the corresponding world data
SELECT *
FROM global_data
WHERE year BETWEEN '1820' AND '2013'
ORDER BY year 