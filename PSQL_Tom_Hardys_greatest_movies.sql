-- find the top 10 movies of British actor Tom Hardy in the IMDB database

-- find Hardy's nconst
-- SELECT *
-- FROM name_basics
-- WHERE primaryname = 'Tom Hardy'

WITH base_table AS
(
	SELECT nb.nconst, nb.primaryname, pr.tconst, tb.startyear, tb.primaryTitle, r.averageRating
	FROM name_basics nb
	-- join with principals to get tconst (id of the title)
	JOIN 
	(
		SELECT nconst, tconst 
		FROM principals
		WHERE nconst = 'nm0362766' 
	) pr 
	ON pr.nconst = nb.nconst
	-- join with title basics to get the title and start year
	JOIN
	(
		SELECT tconst, startyear, primaryTitle
		FROM title_basics
		WHERE titleType = 'movie'
		AND startyear IS NOT NULL
	) tb
	ON tb.tconst = pr.tconst
	JOIN
	-- join with ratings
	(
		SELECT tconst, averageRating
		FROM ratings
		WHERE averageRating IS NOT NULL
	) r
	ON r.tconst = pr.tconst
)
SELECT primaryTitle AS title, startyear AS year, averageRating AS rating
FROM base_table
-- Get the 10 highest rated movies via order by and limit
ORDER BY 3 DESC
LIMIT 10
