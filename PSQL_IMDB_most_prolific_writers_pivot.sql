-- Find the 5 most prolific writers over the last 10 years
-- Pivot the table with startyears as columns and the count of the movies/episodes as corresponding rows

-- create a joined table that combines the necessary data
WITH join_table AS(
	SELECT cr.tconst, cr.writers, tb.primarytitle, tb.startyear, pr.nconst, nb.primaryname
	FROM crew cr
	JOIN 
		(SELECT tconst, primarytitle, originaltitle, startyear
		FROM title_basics) tb
	ON cr.tconst = tb.tconst
	JOIN
		(SELECT tconst, nconst
		FROM principals) pr
	ON cr.tconst = pr.tconst
	JOIN 
		(SELECT nconst, primaryname
		FROM name_basics) nb
	ON pr.nconst = nb.nconst
-- Join on writers = nconst because they are the same
), base_table AS(
	SELECT *
	FROM join_table
	WHERE writers = nconst
-- Find the 5 most prolific, i.e. most written movies and episodes, writers, define year range
), most_prolific AS(
	SELECT primaryname, COUNT(primarytitle) 
	FROM base_table
	WHERE startyear BETWEEN 2012 AND 2022
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5
), year_table AS (
-- Get a table that displays names, titles and startyear
	SELECT jt.primaryname, primarytitle, startyear
	FROM join_table jt
	JOIN most_prolific mp
	ON jt.primaryname = mp.primaryname
)
-- pivot table year and number of episodes/movies
SELECT primaryname, 
	COUNT(startyear) FILTER(WHERE startyear = 2012) AS "2012",
	COUNT(startyear) FILTER(WHERE startyear = 2013) AS "2013",
	COUNT(startyear) FILTER(WHERE startyear = 2014) AS "2014",
	COUNT(startyear) FILTER(WHERE startyear = 2015) AS "2015",
	COUNT(startyear) FILTER(WHERE startyear = 2016) AS "2016",
	COUNT(startyear) FILTER(WHERE startyear = 2017) AS "2017",
	COUNT(startyear) FILTER(WHERE startyear = 2018) AS "2018",
	COUNT(startyear) FILTER(WHERE startyear = 2019) AS "2019",
	COUNT(startyear) FILTER(WHERE startyear = 2020) AS "2020",
	COUNT(startyear) FILTER(WHERE startyear = 2021) AS "2021",
	COUNT(startyear) FILTER(WHERE startyear = 2022) AS "2022"
FROM year_table
GROUP BY 1



