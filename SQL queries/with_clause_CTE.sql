-- CTE (Common Table Expression)
-- WITH clause
USE cte;

-- Creating tables
CREATE TABLE emp (
    emp_ID INT,
    emp_NAME VARCHAR(50),
    SALARY INT
);


CREATE TABLE sales (
    store_id INT,
    store_name VARCHAR(50),
    product VARCHAR(50),
    quantity INT,
    cost INT
);



-- inserting values
insert into emp(emp_ID, emp_NAME, SALARY)
values
(101, 'Mohan', 40000),
(102, 'James', 50000),
(103, 'Robin', 60000),
(104, 'Carol', 70000),
(105, 'Alice', 80000),
(106, 'Jimmy', 90000);


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


-- checking tables
SELECT 
    *
FROM
    emp;
SELECT 
    *
FROM
    sales;


-- Now using CTE it is also known as Sub Query Factoring.

-- 1st case:
-- Fetch only employees who earn more than average salary of all the employees.

-- Here 1st we need to find the average salary and for that we will use the 'WITH' clause.
-- Always remember whenever using the 'WITH' clause it should take place before the main 'select' statement.
-- Here the 'avg_sal' is the returning column from the 'with' clause 
-- which we will use in the main 'select' statement for the condition.
-- In SQL whenever there is a query associated with the 'WITH' clause it first runs that query.
-- In the 'cast()' 'signed' is used for integer.

with average_salary (avg_sal) as
			(select cast(avg(SALARY) as signed) from emp)
select *
from emp as e, average_salary as av
where e.salary > av.avg_sal;



-- 2nd case
-- Find stores whose sales were better than the average sales accross all the stores.

-- seperating the query into parts:

-- without the with clause
-- 1) Total sales per each store and keep it as 'Total_Sales'
SELECT 
    s.store_id, SUM(cost) AS total_sales_per_store
FROM
    sales AS s
GROUP BY s.store_id;


-- 2) Find the average sales with respect to all the stores and keep it 'Avg_Sales'
SELECT 
    CAST(AVG(total_sales_per_store) AS UNSIGNED) AS avg_sales_for_all_stores
FROM
    (SELECT 
        s.store_id, SUM(cost) AS total_sales_per_store
    FROM
        sales AS s
    GROUP BY s.store_id) AS x;


-- 3) Find the stores where Total_Sales is greater than Avg_Sales of all the stores. 
SELECT 
    *
FROM
    (SELECT 
        s.store_id, SUM(cost) AS total_sales_per_store
    FROM
        sales AS s
    GROUP BY s.store_id) AS Total_Sales
        JOIN
    (SELECT 
        CAST(AVG(total_sales_per_store) AS UNSIGNED) AS avg_sales_for_all_stores
    FROM
        (SELECT 
        s.store_id, SUM(cost) AS total_sales_per_store
    FROM
        sales AS s
    GROUP BY s.store_id) AS x) AS Avg_Sales ON Total_Sales.total_sales_per_store > Avg_Sales.avg_sales_for_all_stores;

-- Here we did it using sub queries. 
-- Here the problem is the query is very complex as we used sub query inside another sub query.
-- Also it use same sub query multiple times, hence it impacts the performence.  
-- So when we need to run same sub query multiple times or the query has become too big or complex to read then we should use CTE. 



-- Now using the 'WITH' clause

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









