-- Find the top rated popular movies for each year and their genre
-- base table
WITH base_table AS (
	SELECT tb.primarytitle, r.averagerating, tb.startyear, tb.genres
	FROM ratings r
	JOIN 
	(
		SELECT tconst, primarytitle, startyear, genres
		FROM title_basics
			-- filter out anything that is not a movie
		WHERE titletype = 'movie'
	) tb ON r.tconst = tb.tconst
	-- threshold of votes constituting a popular movie
	WHERE r.numvotes > 30000
	)
-- Final table with the top movies for each year
SELECT primarytitle, genres, startyear, 
	MAX(averagerating) OVER(PARTITION BY startyear)
FROM base_table

