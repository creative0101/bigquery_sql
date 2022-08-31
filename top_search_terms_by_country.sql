#Google search international top terms by country

WITH base_table AS (
SELECT country_name,
  MAX(DISTINCT term) OVER(PARTITION BY country_name) AS top_terms_country
FROM `bigquery-public-data.google_trends.international_top_terms` 
)
SELECT country_name, top_terms_country
FROM base_table
GROUP BY 1, 2
ORDER BY 1
