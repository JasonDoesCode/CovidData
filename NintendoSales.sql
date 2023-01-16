-- Other test script intented to explore the data on a single publisher - Nintendo.

-- Nintendo's Top Genres by Global Sales
SELECT genre, SUM(global_sales)
FROM sales
WHERE publisher = 'Nintendo'
GROUP BY genre
ORDER BY 2 DESC;

-- Nintendo's Genre Sales Year by Year
SELECT year, genre, ROUND(SUM(global_sales),2) AS global_sales
FROM sales
WHERE publisher = 'Nintendo'
GROUP BY genre, year
ORDER BY genre
LIMIT 10;

-- Sales of Nintendo Platform games over time
SELECT year, ROUND(SUM(global_sales),2) AS global_sales
FROM sales
WHERE publisher = 'Nintendo' AND genre = 'Platform'
GROUP BY year
ORDER BY 1;

-- Sales of Nintendo Sports games over time
SELECT year, ROUND(SUM(global_sales),2) AS global_sales
FROM sales
WHERE publisher = 'Nintendo' AND genre = 'Sports'
GROUP BY year
ORDER BY 1;

-- Sales of Other Publishers' Platform games over time
SELECT year, ROUND(AVG(global_sales),2) AS global_sales
FROM sales
WHERE genre = 'Platform' AND NOT publisher = 'Nintendo'
GROUP BY year
ORDER BY 1;

-- Sales of Other Publishers' Sports games over time
SELECT year, ROUND(AVG(global_sales),2) AS global_sales
FROM sales
WHERE genre = 'Sports' AND NOT publisher = 'Nintendo'
GROUP BY year
ORDER BY 1;

-- Nintendo's most popular games
SELECT name, genre, global_sales
FROM sales
WHERE publisher = 'Nintendo'
ORDER BY sales.rank
LIMIT 10;


-- Nintendo's Genre Sales
SELECT genre, ROUND(SUM(global_sales),2) AS global_sales, COUNT(*) AS num_of_games
FROM sales
WHERE publisher = 'Nintendo'
GROUP BY genre
ORDER BY global_sales DESC;

-- Number of games released per genre
SELECT genre, COUNT(*) AS games_released
FROM sales
WHERE publisher = 'Nintendo'
GROUP BY genre
ORDER BY games_released DESC;

-- Nintendo's Sports games
SELECT sales.rank, name, year, global_sales
FROM sales
WHERE publisher = 'Nintendo' AND genre = 'Sports';

SELECT sales.rank, name, year, global_sales
FROM sales
WHERE publisher = 'Nintendo' AND genre = 'Platform';

SELECT sales.rank, name, year, global_sales
FROM sales
WHERE publisher = 'Nintendo' AND genre = 'Role-Playing';

-- What Genres in Nintendo's Catalog typically perform well? 
WITH nintendo_genre_sales AS (
	SELECT year, genre, ROUND(AVG(global_sales), 2) AS avg_nintendo_sales
	FROM sales
	WHERE publisher = 'Nintendo'
	GROUP BY year, genre
	ORDER BY genre, year
),
genre_sales AS (
	SELECT year, genre, ROUND(AVG(global_sales), 2) AS avg_global_sales
	FROM sales
    WHERE NOT publisher = 'Nintendo'
	GROUP BY year, genre
	ORDER BY genre, year
)
SELECT genre_sales.year, genre_sales.genre, avg_nintendo_sales, avg_global_sales
FROM genre_sales
INNER JOIN nintendo_genre_sales
ON genre_sales.year = nintendo_genre_sales.year AND genre_sales.genre = nintendo_genre_sales.genre;

-- Average Global Sales Grouped soley by Genre
WITH nintendo_genre_sales AS (
	SELECT genre, ROUND(AVG(global_sales), 2) AS nin_avg_sales
    FROM sales
    WHERE publisher = 'Nintendo'
    GROUP BY genre
),
other_genre_sales AS (
	SELECT genre, ROUND(AVG(global_sales), 2) AS other_avg_sales
    FROM sales
    WHERE NOT publisher = 'Nintendo'
    GROUP BY genre
)
SELECT nintendo_genre_sales.genre, nin_avg_sales, other_avg_sales
FROM nintendo_genre_sales
JOIN other_genre_sales
ON nintendo_genre_sales.genre = other_genre_sales.genre
ORDER BY 1;

SELECT publisher, COUNT(DISTINCT genre)
FROM sales
GROUP BY publisher
ORDER BY 2 DESC;


-- Comparing Nintendo Global Sales with other publishers who have sold games in 12 different genres
WITH notable_publishers AS (
	SELECT publisher, COUNT(DISTINCT genre) AS genre_count
    FROM sales
    GROUP BY publisher
    ORDER BY 2 DESC
),
nintendo_genre_sales AS (
	SELECT genre, ROUND(AVG(global_sales), 2) AS nin_avg_sales
    FROM sales
    WHERE publisher = 'Nintendo'
    GROUP BY genre
),
other_genre_sales AS (
	SELECT genre, ROUND(AVG(global_sales), 2) AS other_avg_sales
    FROM sales
    WHERE publisher IN (SELECT publisher FROM notable_publishers WHERE genre_count = 12)
    GROUP BY genre
)
SELECT nintendo_genre_sales.genre, nin_avg_sales, other_avg_sales
FROM nintendo_genre_sales
JOIN other_genre_sales
ON nintendo_genre_sales.genre = other_genre_sales.genre
ORDER BY 1;

