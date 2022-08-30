-- Recursive SQL query

CREATE DATABASE IF NOT EXISTS recur;
USE recur;
SELECT database();

-- Creating tables:

CREATE TABLE IF NOT EXISTS emp_details(
	id INT,
    name VARCHAR(100),
    manager_id INT,
    salary INT,
    designation VARCHAR(100)
);

INSERT INTO emp_details(id, name, manager_id, salary, designation)
VALUES
(1, "Shripadh", NULL, 10000, "CEO"),
(2, "Satya", 5, 1400, "Software Engineer"),
(3, "Jia", 5, 500, "Data Analyst"),
(4, "David", 5, 1800, "Data Scientist"),
(5, "Michael", 7, 3000, "Manager"),
(6, "Arvind", 7, 2400, "Architect"),
(7, "Asha", 1, 4200, "CTO"),
(8, "Maryam", 1, 3500, "Manager"),
(9, "Reshma", 8, 2000, "Business Analyst"),
(10, "Akshay", 8, 2500, "Java Developer");

SELECT * FROM emp_details;
-- TRUNCATE TABLE emp_details;

-- Recursive SQL query uses the WITH clause as well
/*
Syntax is:

WITH [RECURSIVE] CTE_name AS
	(
     SELECT query (Non Recursive query or the Base query)
		UNION [ALL]
	SELECT query (Recursive query using CTE_name [with a termination condition])
    )
SELECT * FROM CTE_name;


- Here the word 'RECURSIVE' is a keyword.
- Here we need to follow a special condition to write the queries. That is we need to have 2 seperate queries which are to be merged together
using the UNION / UNION ALL operator.
- The 1st query is the Base query. The recursion starts from the base query. 
- The 2nd query is the Recursive query where we need to use the CTE table which was created using the WITH clause. Also here we need to provide
a termination condition (a join or filter condition), whenever this condition fails the recursion will stop. 
- Remember the termination condition must be correct and proper or else the recursion will be infinite. 

- The 1st output record will be the result of the Base query that is written, as the Base query passes through the first iteration during the
recursion.
- Once it is done then the output of the Base query becomes the input for the Recursive query. Then it checks for the termination condition and
if it is not matched then again it goes for the recursion and here it will take output provided by the base query on 1st iteration as the input.
This is 2nd iteration.  
- Then on 3rd iteration in the Recursive query it will take output of 2nd iteration of the Recursive query as input. 
*/

-- Queries:
-- Q1: Display numbers from 1 to 10 without using any in-built functions. 
-- Q2: Find the hierarchy of employees under a given manager "Asha".
-- Q3: Find the hierarchy of managers for a given employee "Satya". 

-- Q1:
WITH RECURSIVE numbers AS
	(
     SELECT 1 as n
		UNION
	SELECT n + 1 FROM numbers 
    WHERE n < 10
    )
SELECT * FROM numbers;


-- Q2:
/*
Here under Asha we have Michael and Arvind and under Michael we have Satya, Jia and David.
So we need the hierarchical structure of all the employees working under each other starting from Asha. 
*/

WITH RECURSIVE emp_hierarchy AS
	(
     SELECT id, name, manager_id, designation, 1 AS level 
     FROM emp_details 
     WHERE name = "Asha"
		UNION
	SELECT E.id, E.name, E.manager_id, E.designation, H.level + 1 AS level
    FROM emp_hierarchy H 
    JOIN 
    emp_details E ON H.id = E.manager_id
    )
SELECT * FROM emp_hierarchy;


-- Now if we want the manager name also but don't want the designation

WITH RECURSIVE emp_hierarchy AS
	(
     SELECT id, name, manager_id, designation, 1 AS lvl 
     FROM emp_details 
     WHERE name = "Asha"
		UNION
	SELECT E.id, E.name, E.manager_id, E.designation, H.lvl + 1 AS lvl
    FROM emp_hierarchy H 
    JOIN 
    emp_details E ON H.id = E.manager_id
    )
SELECT H2.id AS emp_id, H2.name AS emp_name, E2.name AS manager_name, H2.lvl AS level
FROM emp_hierarchy H2
JOIN
emp_details E2 ON E2.id = H2.manager_id ORDER BY H2.lvl;





-- Q3:

WITH RECURSIVE emp_hierarchy AS
	(
     SELECT id, name, manager_id, designation, 1 AS level 
     FROM emp_details 
     WHERE name = "Satya"
		UNION
	SELECT E.id, E.name, E.manager_id, E.designation, H.level + 1 AS level
    FROM emp_hierarchy H 
    JOIN 
    emp_details E ON H.manager_id = E.id
    )
SELECT * FROM emp_hierarchy;




-- Again to see the names

WITH RECURSIVE emp_hierarchy AS
	(
     SELECT id, name, manager_id, designation, 1 AS level 
     FROM emp_details 
     WHERE name = "Satya"
		UNION
	SELECT E.id, E.name, E.manager_id, E.designation, H.level + 1 AS level
    FROM emp_hierarchy H 
    JOIN 
    emp_details E ON H.manager_id = E.id
    )
SELECT H2.id AS emp_id, H2.name AS emp_name, E2.name AS manager_name
FROM emp_hierarchy H2
JOIN
emp_details E2 ON E2.id = H2.manager_id;