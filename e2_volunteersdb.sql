-- ==========================================
-- 1. DDL: Create database
-- ==========================================
CREATE DATABASE IF NOT EXISTS volunteersdb;

-- ==========================================
-- 2. Use database
-- ==========================================
USE volunteersdb;

-- ==========================================
-- 3. Create table 'city'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.city (
  id INT NOT NULL AUTO_INCREMENT,
  city_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

-- Insert values to city table
INSERT INTO volunteersdb.city (city_name) VALUES
("London"),
("Bristol"),
("Hove");

-- ==========================================
-- 4. Create table 'language'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.language (
    id INT NOT NULL AUTO_INCREMENT,
    language_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to language table
INSERT INTO volunteersdb.language (language_name) VALUES
("German"),
("English"),
("Dutch");

-- ==========================================
-- 5. Create table 'volunteer'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    city_id INT NOT NULL,
    CONSTRAINT fk_city_id FOREIGN KEY (city_id) REFERENCES city(id)
);

-- Insert values to volunteers table
INSERT INTO volunteersdb.volunteer (surname, mobile, city_id) VALUES
('Kroner', '020 1234 5678',  1),    -- Kroner lives in London
('James', '020 5678 1234', 2),      -- James lives in Bristol
('Dexter', '020 7654 4321', 3),     -- Dexter lives in Hove
('Stephen', '020 4321 8765', 1);    -- Stephen lives in London


-- Q: Show all volunteers and the respective city one resides
SELECT c.city_name, v.surname, v.mobile
FROM volunteersdb.city c, volunteersdb.volunteer v
where c.id = v.city_id;

-- ==========================================
-- 6. Create table 'salutation'
-- ==========================================
CREATE TABLE volunteersdb.salutation (
    id INT NOT NULL AUTO_INCREMENT,
    salutation_name VARCHAR(10) NOT NULL,
    PRIMARY KEY(id)
);

-- Insert values to salutation table
INSERT INTO volunteersdb.salutation (id, salutation_name) VALUES
(1, 'Mr.'),
(2, 'Miss'),
(3, 'Mrs.');

-- ==========================================
-- 7. Alter table 'volunteer'
-- ==========================================

-- a. Alter table volunteer to include column 'salutation_id'
ALTER TABLE volunteersdb.volunteer
ADD COLUMN salutation_id INT NOT NULL AFTER id;

-- b. Update the salutations for each volunteer
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 1; -- Mr. Kroner
UPDATE volunteersdb.volunteer SET salutation_id = 2 WHERE id = 3; -- Miss James
UPDATE volunteersdb.volunteer SET salutation_id = 3 WHERE id = 2; -- Mrs. Dexter
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 4; -- Mr. Stephen

-- c. Add constraint where volunteer table salutation_id references id from table salutation
ALTER TABLE volunteersdb.volunteer
ADD CONSTRAINT fk_salutation_id FOREIGN KEY (salutation_id) REFERENCES salutation(id);

-- d. Create the referenential integrity between volunteer and language
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_language(
	volunteer_id INT NOT NULL, 	-- volunteer_id
    language_id INT NOT NULL, 	-- language_id
    PRIMARY KEY (volunteer_id, language_id) 														-- composite key (volunteer_id & language_id)
    CONSTRAINT fk_volunteer_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer(id),	-- constraint between table volunteer
    CONSTRAINT fk_language_id FOREIGN KEY (language_id) REFERENCES volunteersdb.language(id),		-- constraint between table language
);

-- e. Insert volunteers and languages associated
INSERT INTO volunteersdb.volunteer_language(volunteer_id, language_id) VALUES
(1, 1), -- Kroner, German
(1, 2), -- Kroner, English
(2, 2), -- James, English
(3, 1), -- Dexter, German
(3, 2), -- Dexter, English
(3, 3), -- Dexter, Dutch
(4, 1); -- Stephen, German

-- =============================================================================
-- 8. Create table 'volunteer_hour' to manage the hours a volunteer contributes
-- =============================================================================
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_hour(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 													 -- id
    volunteer_id INT NOT NULL, 																		 -- volunteer_id (foreign key)
    hours INT NOT NULL, 																			 -- hours
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 						 -- create_at
    CONSTRAINT fk_volunteer_hour_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer(id) -- constraint
);

-- Insert the hours each volunteer rakes up per event
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(1, 15),    -- Kroner, 15 hours
(1, 12),    -- Kroner, 15 hours;
(2, 32),    -- James,  32 hours
(3, 11),    -- Dexter, 11 hours
(3, 7),     -- Dexter, 7 hours
(3, 5);     -- Dexter, 5 hours

-- ==========================================
-- 9. DQL: Query relational tables
-- ==========================================
-- NOTE: Examples here relate to the assessment

-- Q1. Select information from each table from the database
SELECT * FROM volunteersdb.salutation;
SELECT * FROM volunteersdb.language;
SELECT * FROM volunteersdb.city;
SELECT * FROM volunteersdb.volunteer;
SELECT * FROM volunteersdb.volunteer_language;
SELECT * FROM volunteersdb.volunteer_hour;

-- Q2. Show the surname, mobile, city name of each volunteer
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v, city c
WHERE v.city_id = c.id;

-- 'Kroner','020 1234 5678','London'
-- 'Stephen','020 4321 8765','London'
-- 'James','020 5678 1234','Bristol'
-- 'Dexter','020 7654 4321','Hove'

-- Q3. Use a JOIN (INNER JOIN) to show a volunteer's details (mobile) and the city lived in
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id;

-- 'Kroner', '020 1234 5678', 'London'
-- 'Stephen', '020 4321 8765', 'London'
-- 'James', '020 5678 1234', 'Bristol'
-- 'Dexter', '020 7654 4321', 'Hove'

-- Q4. Show the surname, mobile and city name of each volunteer residing in "London" or "Bristol"
-- Note: Use a JOIN to relate tables volunteer - city
-- Note: Use a WHERE clause to set up a condition to displaying 
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id
WHERE c.city_name IN ("London", "Bristol");

-- 'Kroner','020 1234 5678','London'
-- 'Stephen','020 4321 8765','London'
-- 'James','020 5678 1234','Bristol'

-- Q5. Display volunteers who speaks German
-- Note: relationship table is involved include: volunteer -< volunteer_langauge >- language
SELECT v.surname, l.language_name
FROM volunteer v
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
WHERE l.language_name LIKE "g%";

-- Q6. Count the number of volunteers in each city
-- Note: Aggregate function COUNT() is applied
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id
GROUP BY c.city_name
ORDER BY c.city_name DESC; -- DEFAULT IN ASCENDING ORDER

SELECT COUNT(v.city_id) AS `Number of volunteers`, c.city_name
FROM volunteer v JOIN city c 
ON v.city_id = c.id
GROUP BY c.city_name
ORDER BY `Number of volunteers` DESC -- use aliases for sorting (back ticks used)
LIMIT 25;							 -- set the limt on the records to display



