-- ==========================================
-- 1. DDL: Create database
-- ==========================================
CREATE DATABASE IF NOT EXISTS customersdb;

-- ==========================================
-- 2. Use database
-- ========================================== 
USE customersdb;

-- ==========================================
-- 3. Create tables (customers, orders)
-- ==========================================
CREATE TABLE customers(
	id INT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE orders(
	id INT NOT NULL,									-- unique identifier
    customer_id INT NOT NULL,							-- other attributes
    product_name VARCHAR(50) NOT NULL,  				-- more attributes
    PRIMARY KEY (id),									-- primary key
	FOREIGN KEY (customer_id) REFERENCES customers(id) 	-- constraints (FK)
);

-- ===============================================
-- 3.1. Create table 'orders' with named constraints 
-- =============================================== 
DROP TABLE orders;

CREATE TABLE orders(
	id INT NOT NULL,									
    customer_id INT NOT NULL,							
    product_name VARCHAR(50) NOT NULL,  				
    PRIMARY KEY (id),									
	CONSTRAINT FK_CustomersOrders FOREIGN KEY (customer_id)	-- named constraint
    REFERENCES customers(id) 
);

-- ==========================================
-- 4. Show all tables in the database
-- ========================================== 
SHOW TABLES;

-- ============================================
-- 5. Insert one record into table 'customers'
-- ============================================
INSERT INTO customers 
VALUES (111, 'Steve Ball', 'Derby');

SELECT * FROM customers;

-- ==================================================
-- 6. Insert multiple records into table 'customers'
-- ==================================================
INSERT INTO customers
VALUES
(116, 'Andrew Hill', 'Luton'),
(211, 'Mitchelle Pele', 'Carlisle'),
(212, 'Audrie Samah', 'Truro'),
(105, 'Jamie Fisher', 'Cambridge');  

SELECT * FROM customers;

-- ==================================================
-- 7. Altering tables attributes and characteristics
-- ==================================================

-- alter table 'orders' dropping its initial constraint
ALTER TABLE orders
DROP FOREIGN KEY orders_ibfk_1;

-- set the named constraint 'FK_CustomersOrders'
ALTER TABLE orders
ADD CONSTRAINT FK_CustomersOrders
FOREIGN KEY (customer_id) REFERENCES customers(id);

-- set the id attribute of table 'orders' to AUTO_INCREMENT
ALTER TABLE orders
MODIFY COLUMN id INT AUTO_INCREMENT;

-- ==================================================
-- 8. Insert one record into table 'orders' 
-- ==================================================
INSERT INTO orders (customer_id, product_name)
VALUES (105, 'InterTV');

-- ==================================================
-- 9. DML: View ALL records from table 'orders' 
-- ==================================================
SELECT * FROM orders;

-- ================================================
-- 10.  Insert multiple records into table 'orders'
-- ================================================
INSERT INTO orders (customer_id, product_name)
VALUES 
(211, 'Daikin AC'),
(212, 'Goodrej AC'),
(212, 'Hitachi AC'),
(211, 'Aircool AC');

-- ====================================================================
-- 11.  Record insertion failed (customer with id:1000 does not exist)
-- ====================================================================
INSERT INTO orders (customer_id, product_name)
VALUE (1000, 'Media AC');
