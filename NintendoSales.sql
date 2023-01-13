-- Nintendo's Genre Sales Year by Year
SELECT genre, year, ROUND(SUM(global_sales),2) AS global_sales
FROM sales
WHERE publisher = 'Nintendo'
GROUP BY genre, year
ORDER BY genre;

-- Nintendo's Genre Sales
SELECT genre, ROUND(SUM(global_sales),2) AS global_sales
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