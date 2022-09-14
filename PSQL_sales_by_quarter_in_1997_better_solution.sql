--  group categories and products by quarters and shows sales amount for each quarter in 1997
-- overarching table
WITH joined_table AS (
-- table that defines the year, quarters + define the quarters
	SELECT o.order_id, o.order_date, EXTRACT(YEAR FROM o.order_date) AS year_order, EXTRACT(QUARTER FROM o.order_date) AS quarter, od. product_id, od.sub_total_rounded, prod.product_name, cat.category_name
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
	-- get the product names and categories for the corresponding product_id
	INNER JOIN
	(
		SELECT product_id, product_name, category_id
		FROM products
	) prod
	ON prod.product_id = od.product_id
	-- get the category_name
	INNER JOIN 
	(
		SELECT category_id, category_name
		FROM categories
	) cat 
	ON cat.category_id = prod.category_id
)
SELECT product_name, category_name, quarter, SUM(sub_total_rounded) AS sales_per_quarter
FROM joined_table
WHERE year_order = 1997
GROUP BY quarter, product_name, category_name
ORDER BY product_name, quarter 





