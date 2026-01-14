-- Active: 1767708104870@@127.0.0.1@3306@enrollmentdb
-- ==========================================
-- 1. DDL: Create and Use Database
-- ==========================================

DROP DATABASE IF EXISTS enrollmentdb;

CREATE DATABASE IF NOT EXISTS enrollmentdb;

USE enrollmentdb;

-- ==========================================
-- 2. DDL: Create Tables (Schema)
-- ==========================================

-- a. Table 'student'
CREATE TABLE IF NOT EXISTS student(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- b. Table 'teacher'
CREATE TABLE IF NOT EXISTS teacher(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- c. Table 'course'
CREATE TABLE IF NOT EXISTS course(
    id VARCHAR(10) PRIMARY KEY NOT NULL,
    teacher_id INT,
    CONSTRAINT FK_CourseTeacher FOREIGN KEY(teacher_id) 
    REFERENCES teacher(id)
);

-- d. Table 'enrolment' (The many-to-many relationship)
CREATE TABLE IF NOT EXISTS enrolment(
  student_id INT NOT NULL,
  course_id VARCHAR(10) NOT NULL,
  PRIMARY KEY (student_id, course_id),   -- composite key
  CONSTRAINT FK_EnrolmentStudent FOREIGN KEY (student_id) REFERENCES student(id),
  CONSTRAINT FK_EnrolmentCourse FOREIGN KEY (course_id) REFERENCES course(id)
);

-- ==========================================
-- 3. DML: Insert Records
-- ==========================================

-- Q: Who are the faculty members available for the upcoming semester?
INSERT INTO teacher (first_name, last_name)
VALUES
('Seetoh', 'Aung'),   -- ID 1
('Chan', 'Auying'),   -- ID 2
('Gretta', 'Lam'),    -- ID 3
('Teo', 'Hock See'),  -- ID 4
('Sim', 'Wong Hu');   -- ID 5

-- Q: What are the course codes and which teacher is assigned to each?
INSERT INTO course (id, teacher_id)
VALUES
('CS101', 1),   -- Seetoh Aung: 1
('CS102', 2),   -- Chang Auying: 2
('CS103', 3),   -- Gretta Lam: 3
('CS104', 4)   -- Teo Hock See: 4

-- Q: Who are the students enrolled in the programme?
INSERT INTO student (first_name, last_name) VALUES
('Alex', 'Lim'),     -- ID 1
('Belinda', 'Lam');  -- ID 2

-- Q: Which students have registered for which specific courses?
-- Alex Lim (id: 1) - CS101, CS102 and CS104
-- Belinda Lam (id: 2) - CS101 and CS103
INSERT INTO enrolment (student_id, course_id) VALUES
(1, 'CS101'),   -- Alex
(1, 'CS102'),   -- Alex
(1, 'CS104'),   -- Alex
(2, 'CS101'),   -- Belinda
(2, 'CS103');   -- Belinda

-- ==========================================
-- 4. SQL JOIN EXAMPLES
-- ==========================================

-- INNER JOIN: Complete Enrollment Overview
-- Q: Show student names, the courses they are taking, and their assigned teachers.
SELECT 
    s.id AS `Student ID`, 
    s.first_name AS `Student First Name`, 
    s.last_name AS `Student Last Name`, 
    c.id AS `Course ID`, 
    t.first_name AS `Teacher First Name`, 
    t.last_name AS `Teacher Last Name`
FROM student s 
INNER JOIN enrolment e ON s.id = e.student_id
INNER JOIN course c ON c.id = e.course_id
INNER JOIN teacher t ON t.id = c.teacher_id;

-- LEFT JOIN: Teacher Workload
-- Q: Is there any teacher in the system who hasn't been assigned a course yet?

-- USING THE WHERE CLAUSE
SELECT t.first_name, t.last_name, c.id AS `Course ID`
FROM teacher t 
LEFT JOIN course c ON t.id = c.teacher_id
WHERE c.id IS NULL;

-- USING THE HAVING CLAUSE
SELECT t.first_name, t.last_name, c.id AS `Course ID`
FROM teacher t 
LEFT JOIN course c ON t.id = c.teacher_id
HAVING `Course ID` IS NULL;

-- AGGREGATION: Course Popularity
-- Q: How many students are enrolled in each course?
SELECT course_id, COUNT(student_id) AS enrollment_count
FROM enrolment
GROUP BY course_id;