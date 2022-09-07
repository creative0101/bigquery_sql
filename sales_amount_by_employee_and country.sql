-- For each employee, get their sales amount, broken down by country name.

SELECT 
	e.employee_id, e.first_name, e.last_name, o.order_id, od.sales_amount, e.country
FROM employees e
INNER JOIN 
(
	SELECT employee_id, order_id
	FROM orders 
) o
ON e.employee_id = o.employee_id
INNER JOIN
(
	SELECT order_id, 
	ROUND(SUM(unit_price * quantity*(1-discount))::numeric, 2) AS sales_amount
	FROM order_details
	GROUP BY order_id
) od
ON od.order_id = o.order_id
ORDER BY e.country
