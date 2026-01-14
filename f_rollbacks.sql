-- ==========================================
-- 1. Creates a new database named 'usersdb' 
-- if it doesn't already exist to avoid errors.
-- ==========================================
CREATE DATABASE IF NOT EXISTS usersdb;

-- ==========================================
-- 2. Sets the newly created 'usersdb' as the
-- active database for subsequent commands.
-- ==========================================
USE usersdb;

-- ==========================================
-- 3. Defines the 'users' table structure, 
--including an auto-incrementing ID (Primary Key) and basic user details.
-- ==========================================
CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

-- ==========================================
-- 4. Inserts a starting record into the table
-- so there is data to manipulate.
-- ==========================================
INSERT INTO users (first_name, last_name, email)
VALUES ("John", "Doe", "johndoe@gmail.com");

-- ==========================================
-- 5. Disables the automatic saving of changes. 
-- This allows you to group multiple actions and undo them if needed.
-- ==========================================
SET AUTOCOMMIT = 0; -- turns off auto commit (so that one can roll back accidental changes)

-- ==========================================
-- 6. Removes the record where id is 1 
-- (simulating an accidental deletion).
-- ==========================================
DELETE FROM users 
WHERE id = 1;

-- ==========================================
-- 7. Undoes the DELETE command above, 
-- restoring the data to the state it was in at the last COMMIT.
-- ==========================================
ROLLBACK;

-- ==========================================
-- 8. Retrieves all records from the table to
-- verify the ROLLBACK successfully restored the deleted user.
-- ==========================================

SELECT * FROM users;

-- ==========================================
-- 9. Modifies the email address (simulating
-- an incorrect or "erroneous" update).
-- ==========================================
UPDATE users
SET email = "johndoh@gmail.com"
WHERE id = 1;

-- ==========================================
-- 10. Undoes the incorrect update, reverting
-- the email back to the original value.
-- ==========================================
ROLLBACK;

-- ==========================================
-- 11. Modifies the email again, this time 
-- with the intended correct information.
-- ==========================================
UPDATE users
SET email = "johndoe@yahoo.com"
WHERE id = 1;

-- ==========================================
-- 12. Permanently saves all changes made 
-- since the last commit (this makes the new email permanent).
-- ==========================================
COMMIT;

-- ==========================================
-- 13. Attempts to undo; however, since COMMIT
-- was just called, this has no effect on the saved data.
-- ==========================================
ROLLBACK;

-- ==========================================
-- 14. Changes the last name of the user (Part 1
-- of a multi-step update).
-- ==========================================
UPDATE users
SET last_name = "doh"
WHERE id = 1;

-- ==========================================
-- 15. Changes the email of the user (Part 2
-- of a multi-step update).
-- ==========================================
UPDATE users
SET email = "johndoh@yahoo.com"
WHERE id = 1;

-- ==========================================
-- 16. Undoes BOTH Change #1 and Change #2 
--simultaneously because neither was committed.
-- ==========================================
ROLLBACK;

-- ==========================================
-- 17. Re-enables automatic saving, meaning 
-- every future instruction will be permanent immediately after execution.
-- ==========================================
SET AUTOCOMMIT = 1;