-- ==========================================
-- 1. DDL: Drop database if it exists
-- ==========================================
DROP DATABASE IF EXISTS recipedb;

-- ==========================================
-- 2. DDL: Create database
-- ==========================================
CREATE DATABASE IF NOT EXISTS recipedb;

-- ==========================================
-- 3. Use database
-- ==========================================
USE recipedb;

-- ==========================================
-- 4. DDL: Create table category
-- ==========================================
CREATE TABLE recipedb.category(
    id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(45) DEFAULT NULL,
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ==========================================
-- 5. DDL: Modify created_at constraints
-- ==========================================
ALTER TABLE recipedb.category
MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;



-- ==========================================
-- 6. DML: Insert initial records into category
-- ==========================================
INSERT INTO recipedb.category(category_name) 
VALUES 
("breakfast"),
("lunch"),
("dinner"),
("dessert");

-- ==========================================
-- 7. DQL: View all inserted records
-- ==========================================
SELECT * FROM recipedb.category;

-- ==========================================
-- 8. DML: Update category name
-- ==========================================
UPDATE recipedb.category
SET category_name = "bkfst"
WHERE category_name = "breakfast";

-- ==========================================
-- 9. DDL: Modify created_at to auto-update
-- ==========================================
ALTER TABLE recipedb.category
MODIFY created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- ==========================================
-- 10. Control: Disable safe updates (USE WITH CAUTION)
-- SQL editors (like MySQL Workbench) enable this mode to prevent users from accidentally running a DELETE or UPDATE query that could unintentionally wipe out or modify every row in a table.
-- SQL_SAFE_UPDATES is set to 1 (enabled):
-- > to prohibit executing UPDATE or DELETE statements unless you specify a key constraint (usually a Primary Key) in the WHERE clause.
-- > to prevents "blind" updates, such as DELETE FROM category;, which would empty the entire table.
-- ==========================================
SET SQL_SAFE_UPDATES = 0;

-- ==========================================
-- 11. DML: Delete specific records
-- ==========================================
DELETE FROM recipedb.category
WHERE category_name IN ("dessert", "breakfast");

-- ==========================================
-- 12. DML: Insert additional records into category
-- ==========================================
INSERT INTO recipedb.category (category_name) 
VALUES ("appetiser"), ("dessert");

-- ==========================================
-- 13. DDL: Drop table recipe if it exists
-- ==========================================
DROP TABLE IF EXISTS recipe;

-- ==========================================
-- 14. DDL: Create recipe table
-- ==========================================
CREATE TABLE recipedb.recipe(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_name VARCHAR(45) DEFAULT NULL,
    recipe_description LONGTEXT DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    category_id INT,
    CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES recipedb.category(id)
);

-- ==========================================
-- 15. DDL: Set category_id to NOT NULL
-- ==========================================
ALTER TABLE recipedb.recipe
MODIFY category_id INT NOT NULL;

-- ==========================================
-- 16. DDL: Add author column
-- ==========================================
ALTER TABLE recipedb.recipe
ADD author VARCHAR(50);

-- ==========================================
-- 17. DDL: Rename author to written_by
-- ==========================================
ALTER TABLE recipedb.recipe
CHANGE author written_by VARCHAR(255);

-- ==========================================
-- 18. DDL: Drop written_by column
-- ==========================================
ALTER TABLE recipedb.recipe
DROP written_by;

-- ==========================================
-- 19. DML: Insert recipe records
-- ==========================================
INSERT INTO recipedb.recipe (recipe_name, recipe_description, category_id) 
VALUES 
("Chicken Cordon Bleu", 
"4 boneless skinless chicken, salt to taste, pepper o taste, 1 tablespoon garlic powder, 1 tablespoon onion powder, 16 slices swiss cheese, 1/2 lb ham(225 g)thinly sliced, peanut oil or vegetable oil for frying, 1 cup all-purpose flour(125 g), 4 eggs beaten, 2 cups panko bread crumbs(100 g)",
2),
("Tiramisu",
"Dutch processed cocoa powder, espresso (2 shots), vanilla extract (1 g), 5 pasteurized eggs, sugar (1/2 cup), kosher salt (2 tspn), Mascarpone cheese (1 cup), Heavy cream (1/2 cup)",
6);

-- ==========================================
-- 20. DQL: Retrieve recipes with category names
-- ==========================================
SELECT c.category_name, r.recipe_name, r.recipe_description
FROM category c, recipe r
WHERE c.id = r.category_id;

-- ==========================================
-- 21. DQL: Retrieve category name and all recipe attributes
-- ==========================================
SELECT c.category_name, r.*
FROM category c, recipe r
WHERE c.id = r.category_id;