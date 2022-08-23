-- Year on year change for etherum transaction value

-- base table needed with extracted year:
WITH base_table AS (
  SELECT EXTRACT(year FROM block_timestamp) AS single_year, value
  FROM `bigquery-public-data.crypto_ethereum.transactions`)
-- second table including yearly change function
, second_table AS (
SELECT single_year, SUM(value) AS sum_values, 
  LAG(SUM(value)) OVER(ORDER BY single_year) AS last_years_sum,
FROM base_table
GROUP BY 1 -- group by year to get the SUM for the year
ORDER BY 1 -- order by year
)
-- third table using a function for the yoy_change
SELECT single_year, sum_values , last_years_sum, ROUND((sum_values / last_years_sum) * 100, 2) AS yoy_change_percent
FROM second_table
GROUP BY 1, 2, 3
ORDER BY 1