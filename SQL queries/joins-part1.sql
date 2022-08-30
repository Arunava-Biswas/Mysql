-- JOINS
-- JOIN is used to fetch data from multiple tables by joining them into a single query so we can find our intended data.

-- creating a database
CREATE DATABASE joins;

-- using the database
USE joins;

-- creating tables
CREATE TABLE employee (
    emp_id VARCHAR(20),
    emp_name VARCHAR(50),
    salary INT,
    dept_id VARCHAR(20),
    manager_id VARCHAR(20)
);

CREATE TABLE department (
    dept_id VARCHAR(20),
    dept_name VARCHAR(50)
);

CREATE TABLE manager (
    manager_id VARCHAR(20),
    manager_name VARCHAR(50),
    dept_id VARCHAR(20)
);

CREATE TABLE projects (
    project_id VARCHAR(20),
    project_name VARCHAR(100),
    team_member_id VARCHAR(20)
);


-- inserting data
INSERT INTO employee(emp_id, emp_name, salary, dept_id, manager_id)
VALUES
('E1', 'Rahul', 15000, 'D1', 'M1'),
('E2', 'Manoj', 15000, 'D1', 'M1'),
('E3', 'James', 55000, 'D2', 'M2'),
('E4', 'Michael', 25000, 'D2', 'M2'),
('E5', 'Ali', 20000, 'D10', 'M3'),
('E6', 'Robin', 35000, 'D10', 'M3');

INSERT INTO department(dept_id, dept_name)
VALUES
('D1', 'IT'),
('D2', 'HR'),
('D3', 'Finance'),
('D4', 'Admin');

INSERT INTO manager(manager_id, manager_name, dept_id)
VALUES
('M1', 'Prem', 'D3'),
('M2', 'Shripadh', 'D4'),
('M3', 'Nick', 'D1'),
('M4', 'Cory', 'D1');

INSERT INTO projects(project_id, project_name, team_member_id)
VALUES
('P1', 'Data Migration', 'E1'),
('P1', 'Data Migration', 'E2'),
('P1', 'Data Migration', 'M3'),
('P2', 'ETL Tool', 'E1'),
('P2', 'ETL Tool', 'M4');


-- checking the data
SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM manager;
SELECT * FROM projects;





-- INNER JOIN / JOIN
/*
- This is the basic join in SQL, it can be represented by either 'INNER JOIN' or by 'JOIN'. 
- The INNER JOIN matches each row in one table with every row in the other table to find the common data.
- It only shows those datas where there is a match between the 2 tables.
- Whenever joining 2 tables we need to specify the common columns on the basis of which we want the join to take place using the 
'ON' clause. 
- Remember it is not necessary for the column names to be same for both the tables, it is the value that is stored in the
columns which matters, i.e. the value has to be similar for both the tables. 
- Syntax:
SELECT * FROM table1 INNER JOIN table2 ON table1.column_name = table2.column_name;
*/

-- Q. Fetch the employee name and the department name they belong to.
/*
- First thing we need to do is to decide which are the tables that we will need to answer the question. As here we can see
that we need the 'employee' table for the employee name and 'department' table for the department name. Here the join will
happen on the basis of the column 'dept_id' which is available on both the tables. 
- Here 'D1' and 'D2' are the common factors. 
*/

-- using JOIN
SELECT 
    e.emp_name, d.dept_name
FROM
    employee e
        JOIN
    department d ON e.dept_id = d.dept_id;
   
   
-- using INNER JOIN
SELECT 
    e.emp_name, d.dept_name
FROM
    employee e
       INNER JOIN
    department d ON e.dept_id = d.dept_id;
    
   
   
    
-- LEFT JOIN
/*
- The LEFT JOIN returns all records from the left table along with the matched records from the right table.
- Here the left side table becomes the priority i.e. it becomes the main table. 
- So LEFT JOIN 1st do an INNER JOIN and whatever records are matching in both the tables it will fetch it. 
- Then it will check for any additional records in the left table which are not written by the Inner join. 
- Remeber if we select a column name in the right table for which the join condition will not get satisfied for those 
records it will return the value 'Null'. 

LEFT JOIN = INNER JOIN + Any additional records in the left table
*/

-- Q. Fetch all the employee name and the department name they belong to.
/*
Here if we use the INNER JOIN then it will only return the values where there is common factor between the two tables. 
But here we need all the employee names irrespective whether there is a common value between employee and department table.
So we will need to use the LEFT JOIN. 
So here although department 'D10' is not presented in the department table still we will get the employee name of that
department from the left table i.e. the employee table. Here we get value 'Null' for the employee names whose dept_id 
don't match with the dept_id of the department table.
*/

SELECT 
    e.emp_name, d.dept_name
FROM
    employee e
       LEFT JOIN
    department d ON e.dept_id = d.dept_id;
    

SELECT 
    *
FROM
    employee e
       LEFT JOIN
    department d ON e.dept_id = d.dept_id;
    
   
   
   
-- RIGHT JOIN
/*
- It is just the opposite of the LEFT JOIN.
- Here the right table gets the preference i.e. the right table becomes the main table. 

RIGHT JOIN = INNER JOIN + Any additional records from the right table
*/

-- Q. Fetch all the department names and the employee names who work there.
/*
Here we will get 'Null' value for the departments which has no employee in the employee table. 
*/

SELECT 
    d.dept_name, e.emp_name
FROM
    employee e
       RIGHT JOIN
    department d ON e.dept_id = d.dept_id;
    
    
    
    
-- Complicated examples using all the previous joins:


-- Q. Fetch names of all the employees, their managers, their departments and the projects they working on. 
/*
- Here we need to fetch all the employees means no employee to be kept out. 
- So here when we join all the 4 tables we need to keep in mind that we don't miss out a single employee from the employee 
table. 

- 1st step: find all the employee name and department name based on their department id
SELECT e.emp_name, d.dept_name 
FROM 
employee e 
LEFT JOIN 
department d 
ON e.dept_id = d.dept_id;

- 2nd step: now we will need the managers names, so joining the employee table and the manager table based on the manager id.
SELECT e.emp_name, d.dept_name, m.manager_name
FROM
employee e
LEFT JOIN
department d 
ON e.dept_id = d.dept_id
INNER JOIN 
manager m
ON m.manager_id = e.manager_id;

- 3rd step: Now we need all the project names that this employees are working on. 
- So here again we will do the LEFT join based of the column 'team_member_id' of the projects table and the emp_id
of the employee table as here we only need the name of all the employees and not all the managers as the column 
'team_member_id' has both 'emp_id' and 'manager_id' in it. 
- Here we use the LEFT JOIN as the employee table is the main table here. 
*/

SELECT 
    e.emp_name, d.dept_name, m.manager_name, p.project_name
FROM
    employee e
        LEFT JOIN
    department d ON e.dept_id = d.dept_id
        INNER JOIN
    manager m ON m.manager_id = e.manager_id
        LEFT JOIN
    projects p ON p.team_member_id = e.emp_id;