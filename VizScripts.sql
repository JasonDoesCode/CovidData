-- This script holds all the important scripts that were used to create visualizations for the Video Game Sales Dashboards

-- Total global sales
SELECT sales.year, ROUND(SUM(global_sales), 2) AS yearly_global_sales
FROM sales
GROUP BY sales.year
ORDER BY 1;

-- Sales over time by genre
SELECT genre, year, ROUND(SUM(global_sales), 2) AS yearly_global_sales
FROM sales
GROUP BY genre, year
ORDER BY 1;

-- Top 10 Publishers by Global Sales
SELECT publisher, ROUND(SUM(global_sales), 2) AS publisher_sales
FROM sales
GROUP BY publisher
ORDER BY 2 DESC
LIMIT 10; 

-- Top Platforms by Global Sales
SELECT platform, ROUND(SUM(global_sales), 2) AS platform_sales
FROM sales
GROUP BY platform
ORDER BY 2 DESC;

-- Global Sales vs NA Sales
SELECT name, genre, publisher, NA_sales, global_sales, ROUND((global_sales - NA_sales), 2)
FROM sales;

-- Regional Sales
CREATE TEMPORARY TABLE Region_Sales(
	region VARCHAR(13),
    region_sales DOUBLE
);

INSERT INTO region_sales
VALUES ('North America', 
	   (SELECT ROUND(SUM(NA_Sales), 2)
		FROM sales));
        
INSERT INTO region_sales
VALUES ('Europe', 
	   (SELECT ROUND(SUM(EU_Sales), 2)
		FROM sales));

INSERT INTO region_sales
VALUES ('Japan', 
	   (SELECT ROUND(SUM(JP_Sales), 2)
		FROM sales));

INSERT INTO region_sales
VALUES ('Other', 
	   (SELECT ROUND(SUM(other_Sales), 2)
		FROM sales));

SELECT * FROM region_sales
ORDER BY 2 DESC;

