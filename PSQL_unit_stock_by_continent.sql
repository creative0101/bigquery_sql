-- Number of units in stock by category and supplier continent

-- table with SUM of units
WITH stock_table AS (
SELECT category_id, supplier_id, SUM(units_in_stock) AS stock
FROM products
GROUP BY category_id, supplier_id
ORDER BY category_id
), continent_table AS (
-- table with supplier data converting the countries to continents
SELECT supplier_id, 
CASE 
 		WHEN country IN ('UK', 'Germany', 'Italy', 'France', 'Sweden', 'Norway', 'Denmark', 'Finland') THEN 'Europe'
 		WHEN country IN ('USA', 'Canada') THEN 'North America'
 		WHEN country IN ('Japan', 'Singapore', 'Australia') THEN 'APAC'
 		ELSE 'South America'
 		END AS continent
FROM suppliers
), category_table AS (
-- table with corresponding category names
SELECT category_name, category_id
FROM categories
)
-- Last table inner JOINing all three
SELECT category_name, continent, SUM(stock) AS sum_stock
FROM category_table
INNER JOIN stock_table ON stock_table.category_id =  category_table.category_id
INNER JOIN continent_table ON continent_table.supplier_id =  stock_table.supplier_id
GROUP BY 1,2
ORDER BY 1
