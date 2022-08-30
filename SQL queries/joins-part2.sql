-- JOINS

-- using the database
USE joins;

-- creating table
CREATE TABLE company (
    company_id VARCHAR(10),
    company_name VARCHAR(50),
    location VARCHAR(20)
);

CREATE TABLE family (
    member_id VARCHAR(10),
    member_name VARCHAR(50),
    age INTEGER,
    parent_id VARCHAR(10)
);


-- inserting data
INSERT INTO company(company_id, company_name, location)
VALUES
('C001', 'techTFQ Solutions', 'Kuala Lumpur');

INSERT INTO family(member_id, member_name, age, parent_id)
VALUES
('F1', 'David', 4, 'F5'),
('F2', 'Carol', 10, 'F5'),
('F3', 'Michael', 12, 'F5'),
('F4', 'Johnson', 36, ' '),
('F5', 'Maryam', 40, 'F6'),
('F6', 'Stewart', 70, ' '),
('F7', 'Rohan', 6, 'F4'),
('F8', 'Asha', 8, 'F4');


-- checking the data
SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM company;
SELECT * FROM family;





-- Full Outer Join / FULL JOIN / UNION
/*
- FULL JOIN joins both the table and give all the results whether the data gets matched or not.
- It will return null value for any column fetched where the join condition will not matched. 
- Remember from MySQL 4.0.0 onwards there is no FULL OUTER JOIN, it is now replaced by UNION. So we can get the same result using UNION. 

FULL JOIN = INNER JOIN + All remaining records in the left table + All remaining records in the right table
*/

/*
SELECT e.emp_name, d.dept_name
FROM
employee e 
FULL OUTER JOIN
department d 
ON e.dept_id = d.dept_id;
*/

-- Now we need to write the query like this:
SELECT 
    e.emp_name, d.dept_name
FROM
    employee e
        LEFT JOIN
    department d ON e.dept_id = d.dept_id 
UNION 
SELECT 
    e.emp_name, d.dept_name
FROM
    employee e
        RIGHT JOIN
    department d ON e.dept_id = d.dept_id;






-- Cross Join / Cartesian Join
/*
- CROSS JOIN makes combination of each record from left table with each record from right table. 
- So lets say if in left table we have 4 records and in right we have 3 records so total number of combination will be 3*4 = 12. 
- Cross Join returns cartesian product. 
- It is not use that much. If you add a WHERE clause, in case table t1 and t2 has a relationship, the CROSS JOIN works like the INNER JOIN clause.
- Note that different from the INNER JOIN, LEFT JOIN , and RIGHT JOIN clauses, the CROSS JOIN clause does not have a join predicate. 
- In other words, it does not have the ON or USING clause. So here we don't need to provide any join condition.
*/

SELECT 
    e.emp_name, d.dept_name
FROM
    employee e
        CROSS JOIN
    department d;
    
-- Here the number of records will be 24. As there are 6 records in the employee table and 4 records in the department table. 

-- Real world usage, for this we will use the company table. 

-- Q. Write a query to fetch the employee name and their corresponding department names. 
-- Also make sure to display the company name and the company location corresponding to each employee. 

/*
- So here first to use the inner join to get the employee and company name. 
- Now for each of the result we found from the inner join we need to display the company name and company location, for this we need 
to use the CROSS JOIN. 
- So, whenever need to use a table which cannot be joined with any other table but we need some information from this table, there we need to use
the CROSS JOIN. 
*/

SELECT 
    e.emp_name, d.dept_name, c.company_name, c.location
FROM
    employee e
        JOIN
    department d ON e.dept_id = d.dept_id
        CROSS JOIN
    company c;








-- Self join
/*
- Here the table gets joined with itself. 
- Whenever we need to match one record of a table with some other record of that same table to find result, there we need to use this join.
- Remember here we need to use the same table twice.  
- Important to give proper alias in this case. 
- For SELF JOIN there is no keyword like 'SELF JOIN', we use the regular 'JOIN' keyword for this. 
*/

-- For this we will use the table family. 
-- Q. Write a query to fetch the child name and their age correspopnding to their parent name and age. 
/*
- Here we will find the parent child relationship. As there is only one table available so we need to use the SELF JOIN. 
*/

SELECT 
    child.member_name AS child_name,
    child.age AS child_age,
    parent.member_name AS parent_name,
    parent.age AS parent_age
FROM
    family AS child
        JOIN
    family AS parent ON child.parent_id = parent.member_id
ORDER BY child_age;


-- Now we can also use LEFT JOIN here to fetch all the children records even if they don't have a parent record.

SELECT 
    child.member_name AS child_name,
    child.age AS child_age,
    parent.member_name AS parent_name,
    parent.age AS parent_age
FROM
    family AS child
        LEFT JOIN
    family AS parent ON child.parent_id = parent.member_id
ORDER BY child_age;






-- Natural Join
/*
- There are certain similarities between NATURAL JOIN and INNER JOIN, but it is not the same. 
- In a NATURAL JOIN, SQL will decide what is the join condition and not the user. So the SQL will decide which column has similar column name
between the tables and based on that the join will take place. It can be a major problem in using NATURAL JOIN. 
- There can be case where the column names can be same in two tables but they store different values in them. So there if we use NATURAL JOIN
then we might face some issues. 
- Here also we don't need to specify the join condition like in CROSS JOIN, so there is no use of 'ON' keyword. 
- So in short in NATURAL JOIN if there are two tables share the same column name the SQL will perform an INNER JOIN but if there are no 
same column names then it will perform a CROSS JOIN. And if tables have more than one columns sharing the same name then the join will happen on
all the columns. 
- So it is not recommendable to use this join as the control is with the SQL and not the user. 
*/

SELECT *
FROM employee e
NATURAL JOIN department d;
