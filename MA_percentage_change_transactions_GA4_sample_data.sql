# Calculate a month on month moving average change for the event "purchase"

# Clean date and time data
WITH base_table AS(
  SELECT *, PARSE_DATE('%Y%m%d', event_date) AS parsed_date, TIMESTAMP_MICROS(event_timestamp) AS time_stamp
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
), purchases_day AS (
  # SUM of purchases per day, to have the data necessary for a moving average
  SELECT parsed_date, COUNT(event_name) AS n_purchase
  FROM base_table
  WHERE event_name = 'purchase'
  GROUP BY 1
  ORDER BY 1
), sum_month AS (
  # SUM by month
  SELECT DATE_TRUNC(parsed_date, MONTH) AS month, SUM(n_purchase) AS n_month
  FROM purchases_day
  GROUP BY 1
), moving_average AS (
  # moving average
  SELECT month, n_month,
  AVG(n_month) OVER(ORDER BY month ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS ma_number
  FROM sum_month
) # moving average change in percent
SELECT *, 
  LAG(ma_number) OVER (ORDER BY month) AS previous_ma_number,
  ROUND((ma_number - LAG(ma_number) OVER (ORDER BY month)) / LAG(ma_number) OVER (ORDER BY month) * 100, 2) AS ma_change_percent 
FROM moving_average
ORDER BY month



