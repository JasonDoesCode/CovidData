DESCRIBE sales;

SELECT * FROM sales
LIMIT 10;

-- The global sales of all Publishers
SELECT publisher, ROUND(SUM(global_sales), 2) AS Publisher_Global_Sales
FROM sales
GROUP BY publisher
ORDER BY 2 DESC;

-- Highest Global Sales per Year
SELECT year, MAX(global_sales)
FROM sales
GROUP BY year
ORDER BY 1;

-- The variety of genres from each publisher
SELECT publisher, COUNT(DISTINCT genre) AS Unique_Genres
FROM sales
GROUP BY publisher
ORDER BY Unique_Genres DESC;

-- Global sales grouped by their respective genres
SELECT genre, ROUND(SUM(global_sales), 2) AS global_sales
FROM sales
GROUP BY genre
ORDER BY 2 DESC;

-- Global sales of each genre split by regional sales
SELECT genre, 
	   ROUND(SUM(NA_sales), 2) AS NA_Sales, 
       ROUND(SUM(EU_sales), 2) AS EU_Sales, 
       ROUND(SUM(JP_sales), 2) AS JP_Sales, 
       ROUND(SUM(other_sales), 2) AS Other_Sales, 
       ROUND(SUM(global_sales), 2) AS Global_Sales
FROM sales
GROUP BY genre
ORDER BY 1;

-- Splitting the sales table into two tables to practice using joins in queries
-- Create table vginfo - holds all the descriptive information about the game excluding sales data
CREATE TABLE vginfo
AS (SELECT name, sales.rank, platform, year, genre, publisher
	FROM sales);

-- Create table vgsales - holds all sales data about a specfic video game
CREATE TABLE vgsales
AS (SELECT name, sales.rank, na_sales, eu_sales, jp_sales, other_sales, global_sales
	FROM sales);
    
SELECT * FROM vginfo
ORDER BY 3;

SELECT * FROM vgsales
ORDER BY 6 DESC;

-- returns the same table as the orignal table
SELECT * FROM vginfo
INNER JOIN vgsales
ON vginfo.name = vgsales.name;

-- Percent of sales within North America (NA)
SELECT vgsales.name, vgsales.rank, genre, na_sales, global_sales, ROUND((na_sales/global_sales)*100, 2) AS Percent_Sales_NA
FROM vgsales
INNER JOIN vginfo
ON vginfo.name = vgsales.name
ORDER BY 2;

-- Total amount of games per genre
SELECT genre, COUNT(name)
FROM vginfo
GROUP BY genre;

-- Global Sales Per Genre
SELECT vginfo.genre, ROUND(SUM(vgsales.global_sales), 2) AS Global_Sales_Per_Genre
FROM vginfo
INNER JOIN vgsales
ON vginfo.name = vgsales.name
GROUP BY vginfo.genre;

-- Each Genre's percent of total global sale
WITH global_sales_genre AS (
	SELECT genre, SUM(global_sales) AS genre_sales
	FROM sales
	GROUP BY genre
)
SELECT genre, genre_sales, ROUND((genre_sales/(SELECT SUM(global_sales) FROM sales)*100),2) AS genre_sales_percentage
FROM global_sales_genre
ORDER BY 3 DESC;


-- Genre as a percent of global sales with two different tables that require a join
WITH global_sales_genre AS (
	SELECT vginfo.genre, SUM(vgsales.global_sales) as genre_sales
	FROM vginfo
	JOIN vgsales
	ON vgsales.rank = vginfo.rank
	GROUP BY vginfo.genre
)
SELECT genre, 
	   ROUND(genre_sales,2) AS global_sales, 
	   ROUND(genre_sales/(SELECT SUM(global_sales) FROM vgsales)*100, 2) AS percent_global_sales
FROM global_sales_genre
ORDER BY 3 DESC;


-- Same Result without the need for a CTE
SELECT genre, 
	   ROUND(SUM(global_sales), 2) AS global_sales,
	   ROUND(SUM(global_sales) / (SELECT SUM(global_sales) FROM sales) * 100, 2) AS percent_global_sales
FROM sales
GROUP BY genre
ORDER BY 3 DESC;

SELECT vginfo.genre, 
	   ROUND(SUM(vgsales.global_sales), 2) AS global_sales,
	   ROUND(SUM(vgsales.global_sales) / (SELECT SUM(global_sales) FROM vgsales) * 100, 2) AS percent_global_sales
FROM vgsales
INNER JOIN vginfo
ON vgsales.rank = vginfo.rank
GROUP BY genre
ORDER BY 3 DESC;

-- Sales per platform
SELECT vginfo.platform, 
	   ROUND(SUM(vgsales.global_sales), 2) AS global_sales,
	   ROUND(SUM(vgsales.global_sales) / (SELECT SUM(global_sales) FROM vgsales) * 100, 2) AS percent_global_sales
FROM vgsales
INNER JOIN vginfo
ON vgsales.rank = vginfo.rank
GROUP BY platform
ORDER BY 3 DESC
LIMIT 10;

-- Sales per publisher
SELECT vginfo.publisher, 
	   ROUND(SUM(vgsales.global_sales), 2) AS global_sales,
	   ROUND(SUM(vgsales.global_sales) / (SELECT SUM(global_sales) FROM vgsales) * 100, 2) AS percent_global_sales
FROM vgsales
INNER JOIN vginfo
ON vgsales.rank = vginfo.rank
GROUP BY publisher
ORDER BY 3 DESC
LIMIT 10;

-- Every games regional sales as a percentage of that games global sales
-- Add optional WHERE clause to narrow down to a specfic publisher
SELECT vgsales.rank, vginfo.name, vginfo.publisher, 
	   ROUND((na_sales/global_sales)*100,2) AS na_sales_percent,
       ROUND((eu_sales/global_sales)*100,2) AS eu_sales_percent,
       ROUND((jp_sales/global_sales)*100,2) AS jp_sales_percent,
       ROUND((other_sales/global_sales)*100,2) AS other_sales_percent,
       vgsales.global_sales
FROM vginfo
INNER JOIN vgsales
ON vginfo.rank = vgsales.rank
LIMIT 10;
-- WHERE vginfo.publisher = 'Nintendo';


-- Comparing each game's global with the average global sales of that publisher
WITH game_gbsales AS ( 
SELECT vginfo.rank, vginfo.name, vginfo.publisher, vgsales.global_sales
FROM vginfo
INNER JOIN vgsales
ON vginfo.rank = vgsales.rank
),

publisher_global_sales AS (
SELECT publisher, ROUND(AVG(vgsales.global_sales), 2) AS publisher_avg_sales
FROM vgsales
INNER JOIN vginfo
ON vgsales.rank = vginfo.rank
GROUP BY publisher
)

SELECT game_gbsales.rank, name, game_gbsales.publisher, global_sales, publisher_avg_sales
FROM game_gbsales
INNER JOIN publisher_global_sales
ON game_gbsales.publisher = publisher_global_sales.publisher
ORDER BY game_gbsales.rank;

-- With a subquery instead of a second CTE
WITH publisher_sales AS (
	SELECT vginfo.publisher, AVG(global_sales) AS publisher_global_avg
	FROM vginfo
	INNER JOIN vgsales
	ON vginfo.rank = vgsales.rank
	GROUP BY publisher
)
SELECT vginfo.rank, vginfo.name, vginfo.publisher, vgsales.global_sales, publisher_global_avg
FROM ((vginfo
INNER JOIN vgsales
ON vginfo.rank = vgsales.rank) 
INNER JOIN publisher_sales
ON publisher_sales.publisher = vginfo.publisher)
ORDER BY 1;




