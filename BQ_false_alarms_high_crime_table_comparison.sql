-- Find the total number of false alarms and match it with crime data
-- Hypothesis: Boroughs with a high number of false_alarms are generally more affected by crime.

WITH base_table AS 
(
SELECT borough_name, 
  SUM(CASE WHEN incident_group = 'Fire' THEN 1 ELSE 0 END) AS n_fire,
  SUM(CASE WHEN incident_group = 'False Alarm' THEN 1 ELSE 0 END) AS n_false_alarm
FROM `bigquery-public-data.london_fire_brigade.fire_brigade_service_calls`
GROUP BY 1
), per_false AS (
-- Get the percentage of false alarms in the top 10 most affected boroughs
SELECT *,
ROUND((n_false_alarm / (n_fire + n_false_alarm)) * 100, 2) AS percentage_false
FROM base_table
-- exclude no defined
WHERE borough_name NOT LIKE '%NOT GEO-CODED%'
), crime_table AS (
-- get crime data and UNION with false alarm table
SELECT UPPER(borough) AS borough_name, SUM(value) AS n_crimes
FROM `bigquery-public-data.london_crime.crime_by_lsoa` 
GROUP BY 1
), joined_table AS ( -- join tables
SELECT pf.borough_name, pf.n_fire, pf.n_false_alarm, pf.percentage_false, ct.n_crimes
FROM per_false pf
FULL JOIN crime_table ct
ON pf.borough_name = ct.borough_name
), top10_crime AS ( -- get top 10 crime affected boroughs
  SELECT borough_name, n_crimes
  FROM joined_table
  ORDER BY 2 DESC
  LIMIT 10
), top10_false_alarms AS(
  SELECT borough_name, percentage_false
  FROM joined_table
  ORDER BY 2 DESC
  LIMIT 10
)
-- full outer join table with the top 10 highest % false alarms and the top 10 highest crime
SELECT c10.borough_name, c10.n_crimes, f10.borough_name, f10.percentage_false
FROM (
  SELECT *, ROW_NUMBER() OVER (ORDER BY borough_name) AS borough
  FROM top10_crime
) c10 FULL OUTER JOIN
(
  SELECT *, ROW_NUMBER() OVER (ORDER BY borough_name) AS borough
  FROM top10_false_alarms
) f10
ON c10.borough = f10.borough

-- Conclusion: Since only three boroughs appear in both tables, the hypothesis is rejected. 