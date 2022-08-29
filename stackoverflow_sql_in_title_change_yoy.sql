# CASE + annual average increase of SQL related questions on stackoverflow + percentage of posts containing SQL in comparison vs other languages

WITH table1 AS (
SELECT EXTRACT(year FROM creation_date) AS year, title,
  CASE 
  WHEN title LIKE "%SQL%" THEN "SQL"
  ELSE "Other"
  END AS language
FROM `bigquery-public-data.stackoverflow.posts_questions` 
), table2 AS (
# second table using ROW to get a value of how often a language was in the title
SELECT year, language,
  ROW_NUMBER() OVER(PARTITION BY language ORDER BY year) AS language_index_year
FROM table1
), table3 AS (
SELECT DISTINCT year, language , SUM(language_index_year) AS sum_language_year
FROM table2
GROUP BY 1, 2
ORDER BY 1
), table4 AS ( 
# LAG function to compare occurence to the previous year
SELECT *,
  LAG(sum_language_year) OVER(PARTITION BY language ORDER BY year)  AS value_previous_year
FROM table3
WHERE language = "SQL"
) # math. function for yearly change in percent
SELECT *, ROUND(sum_language_year * 100 / value_previous_year,2) AS pct_change_yoy
FROM table4