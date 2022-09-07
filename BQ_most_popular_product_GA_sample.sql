# Find the most popular product of the Google Merchandise store

#First table UNNESTing the values from the STRUCT ARRAYS and adds a ROW for each transaction
WITH orders_table AS
  (SELECT 
  DISTINCT p.v2ProductName AS product_name, h.item.transactionId AS transaction_id,
  # ROW NUMBER OVER product names related to transactions
    ROW_NUMBER() OVER(PARTITION BY p.v2ProductName ORDER BY p.v2ProductName) AS transactions_product
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
  # double UNNEST to get product name from STRUCT ARRAY
  UNNEST(hits) AS h,
  UNNEST(h.product) AS p
  #remove rows without transactionId i.e. no orders
  WHERE item.transactionId IS NOT NULL
  GROUP BY 1, 2
  ORDER BY 1)
#second table to get the sum of transactions as "number of orders"
SELECT product_name, SUM(transactions_product) AS n_orders
FROM orders_table
GROUP BY 1
ORDER BY 2 DESC

