-- create a new table adding more to the categories table

CREATE TABLE categories_test
(
  category_id INT NOT NULL PRIMARY KEY,
  category_name VARCHAR(15) NOT NULL DEFAULT '',
  description TEXT NOT NULL,
  picture VARCHAR(200) NOT NULL DEFAULT '',
  UNIQUE (category_name)
);

-- Data for the table categories_test

INSERT INTO categories_test (category_id,category_name,description,picture) 
VALUES 
(1,'Beverages','Soft drinks, coffees, teas, beers, and ales','beverages.gif'),
(2,'Condiments','Sweet and savory sauces, relishes, spreads, and seasonings','condiments.gif'),
(3,'Confections','Desserts, candies, and sweet breads','confections.gif'),
(4,'Dairy Products','Cheeses','diary.gif'),
(5,'Grains/Cereals','Breads, crackers, pasta, and cereal','cereals.gif'),
(6,'Meat/Poultry','Prepared meats','meat.gif'),
(7,'Produce','Dried fruit and bean curd','produce.gif'),
(8,'Seafood','Seaweed and fish','seafood.gif'),
(9,'Herbs/Spices','Herbal plants and dried spices','herbs.gif'),
(10,'Vegetables','Plant roots, bulbs, leaf vegetables, stems, etc.','vegetables.gif');

-- update picture so that it shows that there are new categories are new

UPDATE categories_test
SET picture = CONCAT('new-', picture)
WHERE category_id NOT IN 
(
    SELECT category_id FROM categories     
);