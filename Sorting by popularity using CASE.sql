-- Which language is the most popular on stackoverflow?

WITH base_table AS
 (
SELECT
DISTINCT title, 
CASE
WHEN title LIKE "%python%" THEN "python" 
WHEN title LIKE "%sql%" THEN "sql" 
WHEN title LIKE "%java%" THEN "java"
WHEN title LIKE "%ruby%" THEN "ruby"
ELSE "other_case"
END AS language
FROM `jrjames83-1171.sampledata.top_questions`
)
SELECT language, COUNT(*)
FROM base_table
GROUP BY 1