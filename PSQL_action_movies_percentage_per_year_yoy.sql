-- how many movies were action movies (%) throughout the years? What was the year on year change?

-- transform 'genres' into a string
ALTER TABLE title_basics
ALTER COLUMN genres TYPE TEXT USING genres::text;

-- get action genre as a single table and a yearly SUM
WITH base_table AS(
	SELECT genres, startyear
	FROM title_basics
	WHERE genres LIKE '%Action%'
	AND startyear IS NOT NULL
), count_table_action AS -- get a table assigning a incremented number to each movie by year
(
	SELECT startyear,
		SUM(COUNT(startyear)) OVER(PARTITION BY startyear) AS sum_action_year
	FROM base_table
	GROUP BY 1
), count_all_genres AS -- Get the count per year
(
	SELECT startyear,
	SUM(COUNT(startyear)) OVER(PARTITION BY startyear) AS sum_all_year
	FROM title_basics
	WHERE startyear IS NOT NULL
	GROUP BY 1
), joined_table AS 
(
-- joined table percentage table
SELECT cag.startyear, cag.sum_all_year, cta.sum_action_year,
ROUND((cta.sum_action_year/cag.sum_all_year)*100, 2) AS percentage_action
FROM count_all_genres cag
JOIN count_table_action cta
ON cag.startyear = cta.startyear
)
-- lag function for yoy change
SELECT *,
	ROUND((percentage_action - LAG(percentage_action) OVER(ORDER BY startyear))/ LAG(percentage_action) OVER(ORDER BY startyear) * 100, 2) AS percentage_change
FROM joined_table