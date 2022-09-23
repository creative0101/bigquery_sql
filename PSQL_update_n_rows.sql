-- Update n rows

UPDATE products
SET unit_price = unit_price * 1.1
WHERE category_id IN (
	SELECT category_id 
	FROM employees 
	WHERE category_id = 2 
	LIMIT 10);
