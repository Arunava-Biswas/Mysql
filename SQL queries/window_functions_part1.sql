-- WINDOW Functions
-- These are also refer as Analytic Function.
-- They are used to perform data analysis calculations.
-- They address an important need compared to 'GROUP BY' clause to return the underlying data.
-- 'OVER' clause determines windows(sets of rows).
-- 'PARTITION BY' clause splits the result set in to partitions on which the Window function is applied.


-- Functions are:

-- Aggregate: COUNT, SUM, AVG, MIN, MAX
-- Offset: FIRST_VALUE, LAST_VALUE, LEAD, LAG
-- Statistical: PERCENT_RANK, CUME_DIST, PERCENTILE_CONT, PERCENTILE_DISC

-- Frames:
-- Rows
-- Range



-- using database window_func:
use window_func;

-- creating table:
CREATE TABLE employee (
    emp_ID INT,
    emp_NAME VARCHAR(50),
    DEPT_NAME VARCHAR(50),
    SALARY INT
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


SELECT * from employee;

-- Using Aggregate functions:

-- To know the max salaried employee in the table:
SELECT MAX(SALARY) as max_salary from employee;							  -- to see the maximum salary
SELECT * FROM employee WHERE SALARY = (SELECT MAX(SALARY) from employee); -- to see the employee record with maximum salary

-- Using Aggregate function as Window Function
-- Without window function, SQL will reduce the no of records.
-- Here we will find the max salaried employee from each department. 
SELECT 
    dept_name, MAX(salary) as maximum_salary
FROM
    employee
GROUP BY dept_name;


-- By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.
-- Here for every record we will be able to see the column max_salary. 
-- Here we are using an 'over()' clause. As a result the 'MAX()' transform to a WINDOW function from an Aggregate Function.
-- Here it will show the maximum salary of the entire salary column
SELECT e.*,
MAX(SALARY) over() as max_salary
FROM employee e;


-- Now if we want to catch the max_salary corresponding to each department
-- Then we will use the 'partition by' clause with the column name as here it is 'DEPT_NAME' inside the over clause.
-- Here it will show maximum salary for each department
SELECT e.*,
MAX(SALARY) over(PARTITION BY dept_name) as max_salary
FROM employee e;


-- row_number(), rank() and dense_rank()
-- row_number() is use to get unique row numbers

-- Here we will get row number upto 24 as there are 24 records
SELECT e.*,
row_number() over() as rn
FROM employee e;


-- Here we will get row number for each departmets separately as we use the partition by clause. 
-- Here for each department the row number will reset from 1. 
SELECT e.*,
row_number() over(PARTITION BY dept_name) as rn
FROM employee e;


-- Actual usage:
-- Fetch the first 2 employees from each department to join the company.
-- Assume that the emp_ID of the employee joined later is higher than the older employees. 
SELECT * FROM (
	SELECT e.*,
	row_number() over(PARTITION BY dept_name ORDER BY emp_id) as rn
	FROM employee e) x
WHERE x.rn < 3;


-- Fetch the top 3 employees in each department earning the max salary.
-- Here if 2 employees earning same salary then it will assign the same rank.  
-- But for every duplicate record it is going to skip a value. 
SELECT * FROM (
	SELECT e.*,
	rank() over(PARTITION BY dept_name ORDER BY salary DESC) as rnk
	FROM employee e) x
WHERE x.rnk < 4;

-- dense_rank() will not skip any value even if there is duplicate values
SELECT e.*,
dense_rank() over(PARTITION BY dept_name ORDER BY salary DESC) as dense_rnk
FROM employee e;


-- Checking the difference between rank, dense_rnk and row_number window functions:
SELECT e.*, 
rank() over(PARTITION BY dept_name ORDER BY salary DESC) as rnk,
dense_rank() over(PARTITION BY dept_name ORDER BY salary DESC) as dense_rnk,
row_number() over(PARTITION BY dept_name ORDER BY salary DESC) as rn,
row_number() over() as serial_No
FROM employee e;


-- lead and lag
-- lag() : To check if the salary of the current employee is higher or lower than the previous employee. 
-- lead() : It is similar to lag but here it will show rows that following the current record i.e. the next record. 
-- Here it will return null for the 1st salary for each department as there is no previous salary for that department. 
-- lag(m,n) : The parameter 'm' means to how many records previous to the current record and 'n' is for the default value.
-- lead() can also take 2 parameters like lag(). 
SELECT e.*,
lag(salary) over (PARTITION BY dept_name ORDER BY emp_id) as prev_emp_salary,
lead(salary) over (PARTITION BY dept_name ORDER BY emp_id) as next_emp_salary
FROM employee e;

-- Here to check 2 records previous to the current record and default value is 0. 
-- Here to check 2 records next to the current record and default value is 0. 
-- Here instad of null it will show 0 as a default value.
SELECT e.*,
lag(salary, 2, 0) over (PARTITION BY dept_name ORDER BY emp_id) as prev_emp_salary,
lead(salary, 2, 0) over (PARTITION BY dept_name ORDER BY emp_id) as next_emp_salary
FROM employee e;



-- Actual usage:
-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.
SELECT e.*,
lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) as prev_empl_sal,
case when e.salary > lag(salary) over(partition by dept_name ORDER BY emp_id) then 'Higher than previous employee'
     when e.salary < lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) then 'Lower than previous employee'
	 when e.salary = lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) then 'Same than previous employee' 
end as sal_range
FROM employee e;

-- actual result with default previous salary value changed from null to 0
SELECT e.*,
lag(salary, 1, 0) over(PARTITION BY dept_name ORDER BY emp_id) as prev_empl_sal,
case when e.salary > lag(salary) over(partition by dept_name ORDER BY emp_id) then 'Higher than previous employee'
     when e.salary < lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) then 'Lower than previous employee'
	 when e.salary = lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) then 'Same as previous employee' 
end as sal_range
FROM employee e;


-- Let's do the same on the basis of next employee
SELECT e.*,
lead(salary, 1, 0) over(PARTITION BY dept_name ORDER BY emp_id) as next_empl_sal,
case when e.salary > lead(salary) over(partition by dept_name ORDER BY emp_id) then 'Higher than next employee'
     when e.salary < lead(salary) over(PARTITION BY dept_name ORDER BY emp_id) then 'Lower than next employee'
	 when e.salary = lead(salary) over(PARTITION BY dept_name ORDER BY emp_id) then 'Same as next employee' 
end as sal_range
FROM employee e;