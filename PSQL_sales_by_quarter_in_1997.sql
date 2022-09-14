--  group categories and products by quarters and shows sales amount for each quarter in 1997
-- overarching table
WITH joined_table AS (
-- table that defines the year, quarters + define the quarters
	WITH quarter_table AS (
	SELECT o.order_id, o.order_date, EXTRACT(YEAR FROM o.order_date) AS year_order, EXTRACT(MONTH FROM o.order_date) AS month_order, od. product_id, od.sub_total_rounded
	FROM orders o
	-- link orders and order_details with an INNER JOIN
		INNER JOIN 
	(
		SELECT order_id, product_id,
			ROUND(SUM(unit_price * quantity*(1-discount))::numeric, 2) AS sub_total_rounded
		FROM order_details
		GROUP BY order_id, product_id
	) od 
	ON od.order_id = o.order_id
	)
	SELECT *,
	CASE
		WHEN month_order BETWEEN 1 AND 3 THEN 'first'
		WHEN month_order BETWEEN 4 AND 6 THEN 'second'
		WHEN month_order BETWEEN 7 AND 9 THEN 'third'
		WHEN month_order BETWEEN 10 AND 12 THEN 'fourth'
		END AS quarter
	FROM quarter_table qt
	-- get the product names and categories for the corresponding product_id
	INNER JOIN
	(
		SELECT product_id, product_name, category_id
		FROM products
	) prod
	ON prod.product_id = qt.product_id
	-- get the category_name
	INNER JOIN 
	(
		SELECT category_id, category_name
		FROM categories
	) cat 
	ON cat.category_id = prod.category_id
)
-- final summarizing table
SELECT year_order, quarter, product_name, category_name, SUM(sub_total_rounded) AS sales_per_quarter
FROM joined_table
WHERE year_order = 1997
GROUP BY year_order, quarter, product_name, category_name
ORDER BY quarter

