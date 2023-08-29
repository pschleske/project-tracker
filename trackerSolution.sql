-- createdb project-tracker
-- psql project-tracker
CREATE TABLE students (
	github VARCHAR(30),
	first_name VARCHAR(30),
    last_name VARCHAR(30)
);
-- \d students (to ensure table was properly created)
INSERT INTO students VALUES ('jhacks', 'Jane', 'Hacker');
-- or
-- INSERT INTO students (github, first_name, last_name) 
-- VALUES ('jhacks', 'Jane', 'Hacker');
DROP TABLE students;
-- modifying the above table to add Primary Key
CREATE TABLE students (
	github VARCHAR(30) PRIMARY KEY,
	first_name VARCHAR(30),
    last_name VARCHAR(30)
);

INSERT INTO students VALUES ('jhacks', 'Jane', 'Hacker');
INSERT INTO students VALUES ('sdevelops', 'Sarah', 'Developer');
INSERT INTO students VALUES ('kcodes', 'Kate', 'Code');

-- Show only the last name of all students
SELECT last_name FROM students;
-- Show only the GitHub username and first name of all students
SELECT github, first_name FROM students;
-- Show all columns for students whose first name is Sarah
SELECT * FROM students WHERE first_name = 'Sarah';
-- Show all columns for students whose GitHub username is sdevelops
SELECT * FROM students WHERE github = 'sdevelops';
-- Show only the first name and last name of students whose GitHub username is jhacks
SELECT first_name, last_name FROM students WHERE github = 'jhacks';
-- Create a projects table with a CREATE TABLE command.
CREATE TABLE projects (
	title VARCHAR(50) PRIMARY KEY,
	description TEXT,
	max_grade INTEGER
);
-- Add the Markov and Blockly projects to the table using INSERT commands.
INSERT INTO projects VALUES ('Markov', 'Tweets generated from Markov chains', 50);
INSERT INTO projects VALUES ('Blockly', 'Programmatic Logic Puzzle Game', 100);
-- PostgreSQL can generate a text file of all the commands required to re-build the database, and this file can be read and edited by humans. This kind of file, an SQL dump file, is useful for backup. In addition, if you want to store your database work on GitHub in order to work with it on multiple computers, you’ll need to create an SQL dump file to push to GitHub.
pg_dump project-tracker > project-tracker.sql
dropdb project-tracker
createdb project-tracker
-- Once you’ve created a new empty database, read the SQL you dumped into it like this:
psql project-tracker < project-tracker.sql
-- Select the title and max_grade for all projects with max_grade > 50.
SELECT title, max_grade FROM projects WHERE max_grade > 50;
-- Select the title and max_grade for all projects where the max_grade is between 10 and 60.
SELECT title, max_grade FROM projects WHERE max_grade > 10 AND max_grade < 60;
-- Select the title and max_grade for all projects where the max_grade is less than 25 or greater than 75.
SELECT title, max_grade FROM projects WHERE max_grade < 25 OR max_grade > 75;
-- Select all projects ordered by max_grade.
SELECT title, max_grade FROM projects WHERE max_grade < 25 OR max_grade > 75;
-- CREATE a grades table, this will use data from students and projects
CREATE TABLE grades(
	id SERIAL PRIMARY KEY, 
	student_github VARCHAR(30) REFERENCES students, 
	project_title VARCHAR REFERENCES projects, 
	grade INTEGER
	);
-- insert data into grades
INSERT INTO grades (student_github, project_title, grade) 
VALUES ('jhacks', 'Markov', 10);
INSERT INTO grades (student_github, project_title, grade)
VALUES ('jhacks', 'Blockly', 2);
INSERT INTO grades (student_github, project_title, grade)
VALUES ('sdevelops', 'Markov', 50);
INSERT INTO grades (student_github, project_title, grade)
VALUES ('sdevelops', 'Blockly', 100);
-- Joining tables to gather more information 
-- SELECT statement for first_name and last_name from the students table. Think of this as Query 1:
SELECT first_name, last_name
FROM students
WHERE github = 'jhacks';
-- Next, let’s select the grade and project_title for a student with a particular student_github value from the grades table. Think of this as Query 2:
SELECT project_title, grade
FROM grades 
WHERE student_github = 'jhacks';
-- Now we need to select the title and max_grade from the projects table. Think of this as Query 3:
SELECT title, max_grade
FROM projects;
-- Joining students and grades table
SELECT * 
FROM students 
JOIN grades ON (students.github = grades.student_github);
-- Choosing the Columns You Want
-- you can use dot syntax to identify the table and field, as in students.first_name and grades.project_title.
SELECT students.first_name, 
students.last_name, 
grades.project_title, 
grades.grade 
FROM students
JOIN grades 
ON (students.github = grades.student_github);
-- Adding the max_grade Column
-- you’ll need to get the max_grade out of the projects table, as in Query 3.
-- To do this, you can stack joins on top of each other. In this case, the common data connecting projects and grades is the title column in the projects table, and it needs to be joined on the project_title column in the grades table.
SELECT * 
FROM students 
JOIN grades ON (students.github = grades.student_github) 
JOIN projects ON (grades.project_title = projects.title);
-- Filtering for Jane’s Information
-- You can also add a WHERE clause to the above query in order to show only the lines for the student with the github column set to jhacks
SELECT * 
FROM students 
JOIN grades ON (students.github = grades.student_github) 
JOIN projects ON (grades.project_title = projects.title)
WHERE students.github = 'jhacks';
-- The Final Query
-- For this final step, write a query that selects only the columns that match the example table from the beginning of this step.
SELECT students.first_name, 
students.last_name, 
grades.project_title, 
grades.grade, 
projects.max_grade 
FROM students 
JOIN grades ON (students.github = grades.student_github) 
JOIN projects ON (grades.project_title = projects.title) 
WHERE students.github = 'jhacks';

-- Remember to run the following command to back up your database
pg_dump project-tracker > project-tracker.sql 