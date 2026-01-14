-- Active: 1767708104870@@127.0.0.1@3306@usersprogressdb
USE usersprogressdb;

-- 1. Analyse the data
-- Hint: use a SELECT statement via a JOIN to sample the data
-- ****************************************************************
SELECT u.*, p.learn_cpp "C++", p.learn_html "HTML", p.learn_java "Java", p.learn_javascript "JS", p.learn_sql "SQL"
FROM users u
    JOIN progress p ON u.user_id = p.user_id;

-- 2. What are the Top 25 schools (.edu domains)?
-- Hint: use an aggregate function to COUNT() schools with most students
-- ****************************************************************
SELECT email_domain, COUNT(*) AS domain_count
FROM users
GROUP BY
    email_domain
ORDER BY domain_count DESC
LIMIT 25;

-- 3. How many .edu learners are located in New York?
-- Hint: use an aggregate function to COUNT() students in New York
-- ****************************************************************
SELECT city, COUNT(*) AS user_count
FROM users
WHERE
    city = 'New York';

-- 4. The mobile_app column contains either mobile-user or NULL.
-- How many of these learners are using the mobile app?
-- Hint: COUNT()...WHERE...IN()...GROUP BY...
-- Hint: Alternate answers are accepted.
-- ****************************************************************
SELECT mobile_app, COUNT(*) AS mobile_user_count
FROM users
WHERE
    mobile_app = 'mobile-user';

-- 5. Query for the sign up counts for each hour.
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format
-- ****************************************************************
SELECT DATE_FORMAT(sign_up_at, '%H') AS hour, COUNT(*) AS hour_count
FROM users
GROUP BY
    hour
ORDER BY hour;

-- 6. What courses are the New Yorker Students taking?
-- Hint: SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "New Yorker learners taking C++"
-- ****************************************************************
SELECT
    u.city,
    SUM(CASE WHEN p.learn_cpp <> '' THEN 1 ELSE 0 END) AS "C++",
    SUM(CASE WHEN p.learn_html <> '' THEN 1 ELSE 0 END) AS "HTML",
    SUM(CASE WHEN p.learn_java <> '' THEN 1 ELSE 0 END) AS "Java",
    SUM(CASE WHEN p.learn_javascript <> '' THEN 1 ELSE 0 END) AS "JavaScript",
    SUM(CASE WHEN p.learn_sql <> '' THEN 1 ELSE 0 END) AS "SQL"
FROM users u
JOIN progress p ON u.user_id = p.user_id
WHERE u.city = 'New York';

-- 7. What courses are the Chicago Students taking?
-- Hint: SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "Chicago learners taking C++"
-- ****************************************************************
SELECT
    u.city,
    SUM(CASE WHEN p.learn_cpp <> '' THEN 1 ELSE 0 END) AS "C++",
    SUM(CASE WHEN p.learn_html <> '' THEN 1 ELSE 0 END) AS "HTML",
    SUM(CASE WHEN p.learn_java <> '' THEN 1 ELSE 0 END) AS "Java",
    SUM(CASE WHEN p.learn_javascript <> '' THEN 1 ELSE 0 END) AS "JavaScript",
    SUM(CASE WHEN p.learn_sql <> '' THEN 1 ELSE 0 END) AS "SQL"
FROM users u
JOIN progress p ON u.user_id = p.user_id
WHERE u.city = 'Chicago';
