CREATE DATABASE test;
USE test;
DROP TABLE vgsales;

CREATE TABLE vgsales (
	id INT AUTO_INCREMENT,
    name VARCHAR(132),
    platform VARCHAR(10),
    year YEAR,
    genre VARCHAR(20),
    publisher VARCHAR(38),
    na_sales DECIMAL(4, 2),
    eu_sales DECIMAL(4, 2),
    jp_sales DECIMAL(4, 2),
    other_sales DECIMAL(4, 2),
    global_sales DECIMAL(4, 2),
    PRIMARY KEY(id)
	);

SET sql_mode = "";

LOAD DATA INFILE '\vgsales.csv'
INTO TABLE vgsales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Create additional columns such as Sales_Percentage to calculate the proportion of each region's sales relative to Global_Sales.
SELECT name, platform, genre, publisher, global_sales 'Global Sales in Millions', 
	ROUND((na_sales/global_sales * 100), 2) AS 'NA Sales %', 
	ROUND((eu_sales/global_sales * 100), 2) AS 'EU Sales %', 
    ROUND((jp_sales/global_sales * 100), 2) AS 'JP Sales %', 
    ROUND((other_sales/global_sales * 100), 2) AS 'Other Sales %'
FROM vgsales;

-- Calculate the total number of games by genre, platform, and publisher.
SELECT genre, platform, publisher, COUNT(publisher) 'Total Number of Games'
FROM vgsales
GROUP BY genre, platform, publisher;

SELECT genre, COUNT(genre)
FROM vgsales
GROUP BY genre;

SELECT platform, COUNT(platform)
FROM vgsales
GROUP BY platform;

SELECT publisher, COUNT(publisher)
FROM vgsales
GROUP BY publisher;

-- Determine the average global sales per genre or publisher.
SELECT genre, AVG(global_sales), COUNT(genre)
FROM vgsales
GROUP BY genre
ORDER BY AVG(global_sales) DESC;

SELECT publisher, AVG(global_sales), COUNT(publisher)
FROM vgsales
GROUP BY publisher
ORDER BY AVG(global_sales) DESC;

-- Rank the top 10 publishers by total sales.
SELECT publisher, SUM(global_sales)
FROM vgsales
GROUP BY publisher
ORDER BY SUM(global_sales) DESC
LIMIT 10;

-- Group by Year and Genre to determine the most popular genres over time.
SELECT genre, year, COUNT(genre)
FROM vgsales
WHERE year != 0
GROUP BY year, genre;

-- Aggregate sales by platform to see which platform has generated the most sales.
SELECT platform, SUM(global_sales)
FROM vgsales
GROUP BY platform
ORDER BY SUM(global_sales) DESC;

-- Calculate the percentage contribution of each region (NA_Sales, EU_Sales, JP_Sales) to Global_Sales.
SELECT platform, SUM(global_sales), 
	ROUND(SUM(na_sales)/SUM(global_sales) * 100, 2) 'NA % Contribution',
    ROUND(SUM(eu_sales)/SUM(global_sales) * 100, 2) 'EU % Contribution',
    ROUND(SUM(jp_sales)/SUM(global_sales) * 100, 2) 'JP % Contribution',
    ROUND(SUM(other_sales)/SUM(global_sales) * 100, 2) 'Other % Contribution'
FROM vgsales
GROUP BY platform
ORDER BY SUM(global_sales) DESC;

-- Implement window functions to rank games by sales within each genre or platform.
SELECT genre, name, global_sales,
 RANK() OVER (PARTITION BY genre ORDER BY global_sales DESC) AS 'Rank'
 FROM vgsales;
 
SELECT platform, name, global_sales,
 RANK() OVER (PARTITION BY platform ORDER BY global_sales DESC) AS 'Rank'
 FROM vgsales;
 
SELECT platform, genre, name, global_sales,
RANK() OVER (PARTITION BY platform, genre ORDER BY global_sales DESC) AS 'Rank'
FROM vgsales;

SELECT platform, year, name, global_sales,
RANK() OVER (PARTITION BY platform, year ORDER BY global_sales DESC) AS 'Rank'
FROM vgsales
WHERE year != 0;

-- Use subqueries to find games that have more sales in Europe than in North America.
SELECT name, eu_sales, na_sales
FROM vgsales
WHERE eu_sales > na_sales;

-- Create CTEs (Common Table Expressions) to split the dataset into different time periods and compare sales trends.
-- time periods = pre 2000, 2000-2010, post 2010
WITH 
	cte1 AS (SELECT SUM(global_sales) FROM vgsales
	WHERE year < 2000 AND year != 0),
    cte2 AS (SELECT SUM(global_sales) FROM vgsales
    WHERE year >= 2000 AND year <= 2010),
    cte3 AS (SELECT SUM(global_sales) FROM vgsales
    WHERE year >= 2010)
SELECT * FROM cte1 JOIN cte2 JOIN cte3;

-- Create a view to show the top 10 games for each genre.
CREATE VIEW genrerank AS
	SELECT genre, name, global_sales,
	ROW_NUMBER() OVER (PARTITION BY genre ORDER BY global_sales DESC) AS ranking
FROM vgsales;

SELECT * FROM genrerank
WHERE ranking <= 10;

-- Create a view to show the total sales by platform and year.
CREATE VIEW platform_year_rank AS
	SELECT platform, year, name, global_sales,
	ROW_NUMBER() OVER (PARTITION BY platform, year ORDER BY global_sales DESC) AS 'Rank'
FROM vgsales
WHERE year != 0;

SELECT * FROM platform_year_rank;

-- Use CASE statements to categorize games based on their global sales (e.g., High Sales, Medium Sales, Low Sales).
SELECT COUNT(id) FROM vgsales;

SELECT name, CASE
	WHEN global_sales >= (SELECT global_sales FROM vgsales WHERE id = 4149) THEN 'High Sales'
    WHEN global_sales < (SELECT global_sales FROM vgsales WHERE id = 4149) 
		AND global_sales >= (SELECT global_sales FROM vgsales WHERE id = 12448) THEN 'Medium Sales'
    ELSE 'Low Sales'
	END 'Sales Category'
FROM vgsales;

-- Create new fields like Dominant_Region using CASE to show which region has the highest sales for each game.
SELECT name, CASE
	WHEN eu_sales > jp_sales AND eu_sales > na_sales AND eu_sales > other_sales THEN 'Europe'
    WHEN na_sales > jp_sales AND na_sales > eu_sales AND na_sales > other_sales THEN 'North America'
    WHEN jp_sales > eu_sales AND jp_sales > na_sales AND jp_sales > other_sales THEN 'Japan'
    ELSE 'Other'
	END 'Highest Selling Region'
FROM vgsales;