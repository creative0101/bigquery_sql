# Find the top 10 etc classic addresses which have the the most transaction and the highest account balance
WITH transactions AS (
  SELECT * 
  FROM 
    `bigquery-public-data.crypto_ethereum_classic.transactions` 
  ), balances AS (
  SELECT * 
  FROM
    `bigquery-public-data.crypto_ethereum_classic.balances` 
), joined_table AS (
  SELECT *
  FROM 
    transactions 
  JOIN 
    balances
  ON 
    transactions.from_address = balances.address
), transaction_count_table AS (
# table for the highest number of transactions
  SELECT 
    from_address, COUNT(from_address) AS count_transactions
  FROM 
    joined_table
  GROUP BY
    1
  ORDER BY
    2 DESC
  LIMIT 
    10
), eth_balance_table AS (
# create another table for a union of both tables to display the adress twice in one final table
  SELECT 
    from_address, eth_balance
  FROM 
    joined_table
  GROUP BY
    1,2
  ORDER BY
    2 DESC
  LIMIT 
    10
)
# UNION the tables 
SELECT *
FROM 
  transaction_count_table 
UNION ALL
SELECT *
FROM 
  eth_balance_table
