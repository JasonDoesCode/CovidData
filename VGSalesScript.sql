DESCRIBE sales;

-- The global sales of all Publishers
SELECT publisher, ROUND(SUM(global_sales), 2) AS Publisher_Global_Sales
FROM sales
GROUP BY publisher
ORDER BY 2 DESC;

-- The variety of genres from each publisher
SELECT publisher, COUNT(DISTINCT genre) AS Unique_Genres
FROM sales
GROUP BY publisher
ORDER BY Unique_Genres DESC;

-- Global sales grouped by their respective genres
SELECT genre, SUM(global_sales)
FROM sales
GROUP BY genre
ORDER BY 2 DESC;

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

SELECT vginfo.genre, SUM(vgsales.global_sales) AS Global_Sales_Per_Genre
FROM vginfo
INNER JOIN vgsales
ON vginfo.name = vgsales.name
GROUP BY vginfo.genre;

SELECT vginfo.genre, 
ROUND(SUM(vgsales.global_sales),2) AS Global_Sales_Per_Genre, 
(SUM(vgsales.global_sales)/(SELECT SUM(global_sales) FROM vgsales))*100 AS Global_sales_per_genre_percentage
FROM vginfo
INNER JOIN vgsales
ON vginfo.name = vgsales.name
GROUP BY vginfo.genre;

SELECT SUM(global_sales) 
FROM sales
WHERE genre = 'Action';

SELECT genre, SUM(global_sales)
FROM sales
GROUP BY genre;

-- Genre as a percent of global sales
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
SELECT genre, genre_sales, ROUND(genre_sales/(SELECT SUM(global_sales) FROM vgsales)*100, 2) AS genre_sales_percentage
FROM global_sales_genre
ORDER BY 3 DESC;







