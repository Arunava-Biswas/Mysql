-- MySQL subquery:
-- Running query inside a query. 
-- A subquery has no dependency i.e. it can be run by it's own. 

 USE demo1;
 
-- creating table:
CREATE TABLE employee (
    emp_ID INT,
    emp_NAME VARCHAR(50),
    DEPT_NAME VARCHAR(50),
    SALARY INT
);

CREATE TABLE department (
    dept_ID INT,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE sales (
    store_id INT,
    store_name VARCHAR(50),
    product VARCHAR(50),
    quantity INT,
    cost INT
);

CREATE TABLE employee_history (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_name VARCHAR(50),
    salary INT,
    location VARCHAR(100)
);

-- inserting data:
insert into employee (emp_ID, emp_NAME, DEPT_NAME, SALARY) 
values
(101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh',  'Finance', 5000),
(107, 'Preet', 'HR', 7000),
(108, 'Maryam', 'Admin', 4000),
(109, 'Sanjay', 'IT', 6500),
(110, 'Vasudha', 'IT', 7000),
(111, 'Melinda', 'IT', 8000),
(112, 'Komal', 'IT', 10000),
(113, 'Gautham', 'Admin', 2000),
(114, 'Manisha', 'HR', 3000),
(115, 'Chandni', 'IT', 4500),
(116, 'Satya', 'Finance', 6500),
(117, 'Adarsh', 'HR', 3500),
(118, 'Tejaswi', 'Finance', 5500),
(119, 'Cory', 'HR', 8000),
(120, 'Monica', 'Admin', 5000),
(121, 'Rosalin', 'IT', 6000),
(122, 'Ibrahim', 'IT', 8000),
(123, 'Vikram', 'IT', 8000),
(124, 'Dheeraj', 'IT', 11000);


insert into department (dept_ID, dept_name, location) 
VALUES
(1, "Admin", "Bangalore"),
(2, "HR", "Bangalore"),
(3, "IT", "Bangalore"),
(4, "Finance", "Mumbai"),
(5, "Marketing", "Bangalore"),
(6, "Sales", "Mumbai");

insert into sales(store_id, store_name, product, quantity, cost)
values
(1, 'Apple Originals 1','iPhone 12 Pro', 1, 1000),
(1, 'Apple Originals 1','MacBook pro 13', 3, 2000),
(1, 'Apple Originals 1','AirPods Pro', 2, 280),
(2, 'Apple Originals 2','iPhone 12 Pro', 2, 1000),
(3, 'Apple Originals 3','iPhone 12 Pro', 1, 1000),
(3, 'Apple Originals 3','MacBook pro 13', 1, 2000),
(3, 'Apple Originals 3','MacBook Air', 4, 1100),
(3, 'Apple Originals 3','iPhone 12', 2, 1000),
(3, 'Apple Originals 3','AirPods Pro', 3, 280),
(4, 'Apple Originals 4','iPhone 12 Pro', 2, 1000),
(4, 'Apple Originals 4','MacBook pro 13', 1, 2500);

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM sales;


-- Q. Find the employees whose salary is more than the average salary earned by all the employees. 

-- part 1: Find the average salary earned by all the employees
-- part 2: Filter the employees based on the above result

SELECT avg(SALARY) FROM employee; -- avg salry is 5791.66666666666667

SELECT *  -- Outer query / main query
FROM employee
WHERE SALARY > (SELECT avg(SALARY) AS avg_salary FROM employee); -- subquery / inner query


/*
-- Different types of subquerries:
- Scalar Subquery: It is a subquery which always return just one row and one column only. 
- Multiple row Subquery: Here the subquery returns multiple rows. 
- Correlated Subquery: This is a query where the inner query is related to the outer query. 
*/


-- Scalar Subquery
/*
- As in case of the average salary the query for the avg_salary is an example of Scalar Subquery, as it returns
just one row and one column.
*/
SELECT avg(SALARY) AS avg_salary FROM employee;

-- Using the same query in a FROM clause 
SELECT *
FROM employee AS e
join (SELECT avg(SALARY) AS sal FROM employee) AS avg_sal
	on e.salary > avg_sal.sal;




-- Multiple row Subquery:
/*
There are mainly 2 types of Multiple row Subquery:
- Subquery which returns multiple columns and rows
- Subquery which returns only one column and multiple rows
*/


-- Multiple columns and multiple rows
-- Q. Find the employees who earn the highest salary in each department. 

/*
- 1st find the highest salary for each department. 
- Now compare that salary and department information with the employee table to get the final result. 
*/

-- Using the GROUP BY clause to group each department and MAX() to get the highest salry for that department
SELECT DEPT_NAME, MAX(SALARY)
FROM employee
GROUP BY DEPT_NAME;

-- 2nd part to create the filter
SELECT *
FROM employee
WHERE (DEPT_NAME, SALARY) IN (SELECT DEPT_NAME, MAX(SALARY)
							  FROM employee
							  GROUP BY DEPT_NAME);



-- Single column and multiple rows
-- Q. Find department who do not have any employees. 

/*
- Here we need to use both the department and employee table to find out which are the departments are not present
in the employee table. So in those departments there will be no employees. 
*/

SELECT *
FROM department
WHERE dept_name not in (SELECT DISTINCT DEPT_NAME FROM employee);

-- Here the inner query returning multiple rows but just a single column




-- Correlated Subquery

/*
- It is a bit different than the other two subqueries.
- Here the processing of the subquery depends upon the values return from the outer query. 
- So here the inner query / subquery is not independent. 
*/


-- Q. Find the employees in each department who earn more than the average salary in that department. 

/*
Here we need to find the average salary of employees for each department. 
Then we need to compare the salries of employees of each department with the average salary of that department. 
*/

/*
-- inner query:
SELECT avg(SALARY) AS avg_salary 
FROM employee
WHERE DEPT_NAME = "specific_dept";
*/

SELECT *
FROM employee AS e1
WHERE SALARY > (SELECT avg(SALARY) AS avg_salary 
				FROM employee AS e2
				WHERE e2.DEPT_NAME = e1.DEPT_NAME
                );

-- Here the inner query cannot run independently as one column 'e1.DEPT_NAME' coming from the outer query.
-- Here for every record of the outer query SQL will process the subquery once. 
-- It is a very source consuming process. 


-- Using Correlated subquery in actual usage
-- To compare data between two or more tables
-- Q. Find department who do not have any employees. 

SELECT *
FROM department AS d
WHERE NOT EXISTS (SELECT 1 FROM employee AS e WHERE e.DEPT_NAME = d.dept_name);


SELECT 1 FROM employee AS e WHERE e.DEPT_NAME = "Marketing";



-- Nested Subquery:
-- subquery inside a subquery

-- Q. Find the stores whose sales were better than the average sales accross all the stores?

/*
- Find total sales for each store. 
- Average sales for all the stores. 
- Compare the both. 
*/

-- finding total sales for each store
SELECT store_name, sum(cost) as total_sales
FROM sales
GROUP BY store_name;

-- getting average of all the stores
SELECT avg(total_sales)
FROM (SELECT store_name, sum(cost) as total_sales
	  FROM sales
	  GROUP BY store_name) as x;

-- making the comparison
SELECT *
FROM (SELECT store_name, sum(cost) as total_sales
	  FROM sales
	  GROUP BY store_name) as sales
JOIN (SELECT avg(total_sales) as sales
	 FROM (SELECT store_name, sum(cost) as total_sales
		   FROM sales
		   GROUP BY store_name) as x) as avg_sales
	 ON sales.total_sales > avg_sales.sales;


-- It is not a good practice instead use the WITH clause

with Total_Sales(store_id, total_sales_per_store) as
		(select s.store_id, sum(cost) as total_sales_per_store
		 from sales as s
		 group by s.store_id),
	 Avg_Sales(avg_sales_for_all_stores) as
		(select cast(avg(total_sales_per_store) as unsigned) as avg_sales_for_all_stores
		 from Total_Sales)
select *
from Total_Sales as ts
join Avg_Sales as av
on ts.total_sales_per_store > av.avg_sales_for_all_stores;



/*
Different SQL clauses where subquery is allowed:
-- SELECT
-- FROM
-- WHERE
-- HAVING
*/

-- Use subquery in SELECT clause. 
-- Q. Fetch all employee details and add remarks to those employees who earn more than the average pay. 

SELECT 
    *,
    (CASE
        WHEN
            SALARY > (SELECT 
                    AVG(SALARY)
                FROM
                    employee)
        THEN
            'Higher than average'
        ELSE NULL
    END) AS remarks
FROM
    employee;



-- It is not a good practice instead use a JOIN condition

SELECT 
    *,
    (CASE
        WHEN SALARY > avg_sal.sal THEN 'Higher than average'
        ELSE NULL
    END) AS remarks
FROM
    employee
        CROSS JOIN
    (SELECT 
        AVG(SALARY) AS sal
    FROM
        employee) AS avg_sal;
        
        
        
        
        
-- subquery with the HAVING clause
-- Q. Find the stores who have sold more units than the average units sold by all the stores. 

SELECT 
    store_name, SUM(quantity)
FROM
    sales
GROUP BY store_name
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);







/*
SQL commands that allow subquery
-- INSERT
-- UPDATE
-- DELETE
*/

-- INSERT
-- Q. Insert data to employee history table. Make sure not to insert duplicate records.
/*
- Here we need refer to the employee and the department table and fetch data from those two tables and then load
it into this history table. 
- Here we don't need to write insert for all the data as it is already available in some other tables. 
*/

SELECT * FROM employee_history;

insert into employee_history
SELECT e.emp_ID, e.emp_NAME, d.dept_name, e.SALARY, d.location
FROM employee as e
JOIN department as d ON d.dept_name = e.DEPT_NAME
WHERE not EXISTS (SELECT 1 
				  FROM employee_history as eh 
                  WHERE eh.emp_id = e.emp_ID);  -- this is to eliminate duplicate data


-- For the 1st run it will insert 24 records 
-- 24 row(s) affected Records: 24  Duplicates: 0  Warnings: 0	0.094 sec
-- but on rerun it will not insert anything as now data will be duplicated
-- 0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0	0.000 sec


-- UPDATE
/*
Q. Give 10% increament to all employees in Bangalore location based on the maximum salary earned by an employee
in each department. Only consider employees in employee_history table. 
*/

UPDATE employee as e
SET SALARY = (SELECT MAX(SALARY) + (MAX(SALARY) * 0.1)
			  FROM employee_history as eh
			  WHERE eh.dept_name = e.DEPT_NAME)
WHERE e.DEPT_NAME in (SELECT dept_name 
					  FROM department 
                      WHERE location = "Bangalore")
AND e.emp_ID in (SELECT emp_id 
				 FROM employee_history);


-- Here only 20 records get updated as they satisfy all the clauses. 
-- 20 row(s) affected Rows matched: 20  Changed: 20  Warnings: 0	0.188 sec



-- DELETE
-- Q. Delete all the departments who do not have any employees. 

DELETE FROM department
WHERE dept_name in (SELECT dept_name
					FROM department AS d
					WHERE NOT EXISTS (SELECT 1 
									  FROM employee AS e 
									  WHERE e.DEPT_NAME = d.dept_name)
					);


SELECT * FROM department;