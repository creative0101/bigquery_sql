-- For each category, we get the list of products sold and the total sales amount. 

-- First table using double INNER JOIN to get results from the category and products tables
SELECT cat.category_id, cat.category_name, prod.product_name, prod.product_id, od.sales_amount
FROM categories cat
INNER JOIN
(
	SELECT category_id, product_id, product_name
	FROM products 
) prod
ON cat.category_id = prod.category_id
INNER JOIN
(
	-- Second table for the sum of sales per product_id
	SELECT product_id,
		ROUND(SUM(CAST(unit_price * quantity*(1-discount) AS NUMERIC)), 2) AS sales_amount
	FROM order_details 
	GROUP BY 1
) od
ON od.product_id = prod.product_id
ORDER BY category_id 


