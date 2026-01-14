-- ==========================================
-- 1. DDL: Drop database if it exists
-- ==========================================


-- ==========================================
-- 2. DDL: Create database
-- ==========================================


-- ==========================================
-- 3. Use database
-- ==========================================


-- ==========================================
-- 4. DDL: Create table category
-- ==========================================


-- ==========================================
-- 5. DDL: Modify created_at constraints
-- ==========================================


-- ==========================================
-- 6. DML: Insert initial records into category
-- ==========================================


-- ==========================================
-- 7. DQL: View all inserted records
-- ==========================================


-- ==========================================
-- 8. DML: Update category name
-- ==========================================


-- ==========================================
-- 9. DDL: Modify created_at to auto-update
-- ==========================================


-- ==========================================
-- 10. Control: Disable safe updates (USE WITH CAUTION)
-- SQL editors (like MySQL Workbench) enable this mode to prevent users from accidentally running a DELETE or UPDATE query that could unintentionally wipe out or modify every row in a table.
-- SQL_SAFE_UPDATES is set to 1 (enabled):
-- > to prohibit executing UPDATE or DELETE statements unless you specify a key constraint (usually a Primary Key) in the WHERE clause.
-- > to prevents "blind" updates, such as DELETE FROM category;, which would empty the entire table.
-- ==========================================


-- ==========================================
-- 11. DML: Delete specific records
-- ==========================================


-- ==========================================
-- 12. DML: Insert additional records into category
-- ==========================================


-- ==========================================
-- 13. DDL: Drop table recipe if it exists
-- ==========================================


-- ==========================================
-- 14. DDL: Create recipe table
-- ==========================================


-- ==========================================
-- 15. DDL: Set category_id to NOT NULL
-- ==========================================


-- ==========================================
-- 16. DDL: Add author column
-- ==========================================


-- ==========================================
-- 17. DDL: Rename author to written_by
-- ==========================================


-- ==========================================
-- 18. DDL: Drop written_by column
-- ==========================================


-- ==========================================
-- 19. DML: Insert recipe records
-- ==========================================


-- ==========================================
-- 20. DQL: Retrieve recipes with category names
-- ==========================================


-- ==========================================
-- 21. DQL: Retrieve category name and all recipe attributes
-- ==========================================
