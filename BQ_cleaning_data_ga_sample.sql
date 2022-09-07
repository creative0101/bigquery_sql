# Use PARSE to clean the date 
# Use REPLACE to clean product category
# Filter out unwanted data WHERE transactionId != 0.

WITH table1 AS (
  SELECT PARSE_DATE('%Y%m%d', date) AS parsed_date, REPLACE(p.v2ProductCategory,".*$/", "") AS category
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
  ,  UNNEST(hits) AS h
  ,  UNNEST(h.product) AS p
  WHERE item.transactionId IS NOT NULL
)

#second table to filter out "${productitem.product.origCatName}" and find the biggest categories
SELECT category, COUNT(category) AS buys_category
FROM table1 
WHERE category != "${productitem.product.origCatName}"
GROUP BY 1
ORDER BY 2 DESC
