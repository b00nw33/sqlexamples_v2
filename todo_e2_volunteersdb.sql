-- Active: 1767708104870@@127.0.0.1@3306@volunteersdb
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
INSERT INTO
    volunteersdb.city (city_name)
VALUES ("London"),
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
INSERT INTO
    volunteersdb.language (language_name)
VALUES ("German"),
    ("English"),
    ("Dutch");

-- ==========================================
-- 5. Create table 'volunteer'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    surname VARCHAR(50) NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    city_id INT NOT NULL,
    CONSTRAINT fk_city_id FOREIGN KEY (city_id) REFERENCES volunteersdb.city (id)
);

-- Insert values to volunteers table
INSERT INTO
    volunteersdb.volunteer (surname, mobile, city_id)
VALUES ('Kroner', '020 1234 5678', 1), -- Kroner lives in London
    ('James', '020 5678 1234', 2), -- James lives in Bristol
    ('Dexter', '020 7654 4321', 3), -- Dexter lives in Hove
    ('Stephen', '020 4321 8765', 1);
-- Stephen lives in London

-- Q: Show all volunteers and the respective city one resides
SELECT v.*, c.city_name
FROM volunteer v
    JOIN city c ON v.city_id = c.id;

-- ==========================================
-- 6. Create table 'salutation'
-- ==========================================
CREATE TABLE volunteersdb.salutation (
    id INT NOT NULL AUTO_INCREMENT,
    salutation_name VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to salutation table
INSERT INTO
    volunteersdb.salutation (id, salutation_name)
VALUES (1, 'Mr.'),
    (2, 'Miss'),
    (3, 'Mrs.');

-- ==========================================
-- 7. Alter table 'volunteer'
-- ==========================================

-- a. Alter table volunteer to include column 'salutation_id'

ALTER TABLE volunteersdb.volunteer
ADD salutation_id INT NOT NULL AFTER id;

-- b. Update the salutations for each volunteer
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 1;
-- Mr. Kroner
UPDATE volunteersdb.volunteer SET salutation_id = 2 WHERE id = 2;
-- Miss. James
UPDATE volunteersdb.volunteer SET salutation_id = 3 WHERE id = 3;
-- Mrs. Dexter
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 4;
-- Mr. Stephen

SELECT s.salutation_name, v.surname
FROM volunteer v
    JOIN salutation s ON v.salutation_id = s.id;

-- c. Add constraint where volunteer table salutation_id references id from table salutation
ALTER TABLE volunteersdb.volunteer
ADD CONSTRAINT fk_salutation_id FOREIGN KEY (salutation_id) REFERENCES volunteersdb.salutation (id);

-- d. Create the JUNCTION table between volunteer and language
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_language (
    volunteer_id INT NOT NULL,
    language_id INT NOT NULL,
    PRIMARY KEY (volunteer_id, language_id), -- composite key
    CONSTRAINT fk_volunteer_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer (id),
    CONSTRAINT fk_language_id FOREIGN KEY (language_id) REFERENCES volunteersdb.language (id)
);

-- e. Insert volunteers and languages associated
INSERT INTO
    volunteersdb.volunteer_language (volunteer_id, language_id)
VALUES (1, 1), -- Kroner, German
    (1, 2), -- Kroner, English
    (2, 2), -- James, English
    (3, 1), -- Dexter, German
    (3, 2), -- Dexter, English
    (3, 3), -- Dexter, Dutch
    (4, 1);
-- Stephen, German

-- =============================================================================
-- 8. Create table 'volunteer_hour' to manage the hours a volunteer contributes
-- =============================================================================
CREATE TABLE volunteersdb.volunteer_hour (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    hour INT NOT NULL,
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_hour_volunteer_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer (id)
);

-- Insert the hours each volunteer rakes up per event
INSERT INTO
    volunteersdb.volunteer_hour (volunteer_id, hour)
VALUES (1, 15), -- Kroner, 15 hours
    (1, 12), -- Kroner, 15 hours;
    (2, 32), -- James,  32 hours
    (3, 11), -- Dexter, 11 hours
    (3, 7), -- Dexter, 7 hours
    (3, 5);
-- Dexter, 5 hours

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
WHERE
    v.city_id = c.id;

-- Q3. Use a JOIN (INNER JOIN) to show a volunteer's details (mobile) and the city lived in
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
    INNER JOIN city c ON v.city_id = c.id;

-- Q4. Show the surname, mobile and city name of each volunteer residing in "London" or "Bristol"
-- Note: Use a JOIN to relate tables volunteer - city
-- Note: Use a WHERE clause to set up a condition to displaying
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
    INNER JOIN city c ON v.city_id = c.id
WHERE
    c.city_name IN ("London", "Bristol");

-- Q5. Display volunteers who speaks German
-- Note: relationship table is involved include: volunteer -< volunteer_langauge >- language
-- Challenge: Adding the saluation to each name.

SELECT v.surname, l.language_name
FROM
    volunteer v
    JOIN volunteer_language vl ON v.id = vl.volunteer_id
    JOIN language l ON l.id = vl.language_id
WHERE
    LOWER(l.language_name) IN ("german");
-- where LOWER(l.language_name) = "german"
-- WHERE LOWER(l.language_name) LIKE "g%";  -- this is a wild card search

-- Q6. Count the number of volunteers in each city
-- Note: Aggregate function COUNT() is applied
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city_name
FROM volunteer v
    JOIN city c ON v.city_id = c.id
GROUP BY
    c.city_name
ORDER BY c.city_name DESC;

-- SIMPLE USE OF AN AGRREGATE FUNCTION (Total number of volunteers)
SELECT COUNT(volunteer.id) AS "Total number of volunteers"
FROM volunteer;

-- Q7. Which city do most volunteers come from? (Using JOIN and GROUP BY and LIMIT)
SELECT COUNT(v.city_id) "Number of volunteers", c.city_name
FROM volunteer v
    JOIN city c ON v.city_id = c.id
GROUP BY
    c.city_name
ORDER BY `Number of volunteers` -- using the alias as the sort parameter
LIMIT 3;
-- limits results returned

-- Q8. Display volunteers who speak MORE THAN ONE language (COUNT, GROUP BY, HAVING)
SELECT COUNT(v.id) "Number of languages spoken", v.surname
FROM
    volunteer v
    JOIN volunteer_language vl ON v.id = vl.volunteer_id
GROUP BY
    v.surname
HAVING
    `Number of languages spoken` > 1;

-- Q9. Display the languages spoken by volunteers in the database (DISTINCT)
SELECT DISTINCT (l.language_name)
FROM
    language l
    JOIN volunteer_language vl ON l.id = vl.language_id;

-- 10. Display the number of distinct cities from volunteers (DISTINCT)
SELECT COUNT(DISTINCT c.city_name) "Number of Cities"
FROM volunteer v
    JOIN city c ON v.city_id = c.id;

-- 11. Display the least number of hours clocked by a volunteer (MIN)
SELECT v.surname, vh.hour
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
WHERE
    vh.hour <= ( -- sub-query
        SELECT MIN(hour) "Minimum hours clocked"
        FROM volunteer_hour vh
    );

-- 12. Display the most number of hours clocked by a volunteer (MAX)
SELECT v.surname, vh.hour
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
WHERE
    vh.hour = (
        SELECT MAX(hour)
        FROM volunteer_hour
    );

-- 13. display the total volunteered hours per volunteer (SUM)
SELECT SUM(vh.hour), v.surname
FROM
    volunteer_hour vh
    JOIN volunteer v ON vh.volunteer_id = v.id
GROUP BY
    v.surname;

-- 14. Display the average volunteered hours per volunteer (AVG)
SELECT AVG(vh.hour), v.surname
FROM
    volunteer_hour vh
    JOIN volunteer v ON vh.volunteer_id = v.id
GROUP BY
    v.surname;

-- 15. Display the occasions each volunteer put up more than 1O hours per visit (case expression)
SELECT v.surname, SUM(
        CASE
            WHEN vh.hour > 10 THEN 1
            ELSE 0
        END
    )
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
GROUP BY
    v.surname;

-- Visualsing Q15:
-- Kroner: 1 x 15hr (:white_tick:), 1 x 12hr (:white_tick:)          = 2 times more than 10 hours
-- James : 1 x 32hr (:white_tick:)                                   = 1 time more than 10 hours
-- Dexter: 1 x 11hr (:white_tick:), 1 x 7hr (:x:), 1 x 5 hr (:x:)    =  1 time more than 10 hours

-- 16. Display the cumulative volunteer hours from all volunteers (sub-query)
SELECT SUM(`Total hours volunteered`) "Cumulative volunteer hours"
FROM (
        SELECT SUM(vh.hour) "Total hours volunteered" -- derived table
        FROM
            volunteer v
            JOIN volunteer_hour vh ON v.id = vh.volunteer_id
        GROUP BY
            vh.volunteer_id
    ) AS `Cumulative`;
-- derived table MUST be assigned a name to be used

-- step 1: sub-query returns 27, 32, 23 from all the volunteers' hours
-- step 2:
-- > outer query uses the returned results from the sub-query, and
-- > sums up all the data

-- 17. Display the least number of hours clocked CUMULATIVELY from the volunteers
SELECT SUM(vh.hour) AS "Least Hours Volunteered", v.surname AS `Volunteer Surname`
FROM
    volunteer_hour vh
    JOIN volunteer v ON vh.volunteer_id = v.id
GROUP BY
    v.surname
HAVING
    `Least Hours Volunteered` = (
        SELECT MIN(`Total Hours Volunteered`) AS "Cumulative Volunteer Hours"
        FROM (
                SELECT SUM(vh.hour) AS "Total Hours Volunteered"
                FROM
                    volunteer v
                    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
                GROUP BY
                    vh.volunteer_id
            ) AS `Cumulative`
    );