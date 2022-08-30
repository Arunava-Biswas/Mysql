-- WINDOW Functions:
-- How to write SQL Query using Frame clause, CUME_DIST clause

-- using the database:
use window_func;

-- creating table:
CREATE TABLE product
( 
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);


-- inserting values:
INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);


-- checking the table's data:
SELECT * FROM product;


-- WINDOW Functions:

-- FIRST_VALUE 
-- first_value() : It can be use to extract the very first value of a column within a partition. It accepts one argument i.e. the column name. 
-- Remember it is necessary to use the 'over' whenever using the window function. 
-- Write query to display the most expensive product under each category (corresponding to each record)
SELECT *,
first_value(product_name) over(PARTITION BY product_category ORDER BY price DESC) as most_exp_product
from product;

-- Here the name of the most expensive product of each category will be shown for the rest products in that category. 


-- LAST_VALUE 
-- last_value() : fetch the very last record of a particular partition. It is almost the opposite of first_value(). 
-- Write query to display the least expensive product under each category (corresponding to each record)
SELECT *,
last_value(product_name) over(PARTITION BY product_category ORDER BY price) as least_exp_product  
FROM product;

-- But here it is not exactly correct because of the default FRAME clause the SQL is using. 
-- Whenever we use the Window function it creates an window or partition and apply that window function to each of those partitions.
-- Inside those partitions some subsets are created which are called 'FRAME'. 
-- So a FRAME is a subset of a partition. 



-- The FRAME clause is mentioned inside the over clause after the ORDER BY clause
-- So we need to mention our FRAME clause there after the ORDER BY clause. 
-- The default FRAME clause in SQL is: 'RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW'
-- unbounded preceding : row preceding to the current row and 'unbounded' means very first row of the partition. 
-- So what happens here is when it pursue the first record there is no preceding record as a result the preceding row and the current row become the same. 
-- Now for the second record the unbounded preceding will point to the first record of the partition and the current row will be the second row of the partition. 
-- Then the last value will be the last row i.e. the second row. Same will happen for the next records and so on. 
-- This is why the FRAME clause become important in last_value(), nth_value() and most of the aggregate functions.
-- Now we will change the FRAME clause. 
-- Here we will change the current row to something that will point the very last row of that partition. 
-- For this we will use UNBOUNDED FOLLOWING, i.e. all the records following the current row. And unbounded means either to the begining or the end. 

SELECT *,
last_value(product_name) 
	over(PARTITION BY product_category ORDER BY price DESC
		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
as least_exp_product  
FROM product;


-- Now using both the first_value and last_value:
SELECT *,
first_value(product_name) over(PARTITION BY product_category ORDER BY price DESC) 
as most_exp_product,
last_value(product_name) 
	over(PARTITION BY product_category ORDER BY price DESC
		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
as least_exp_product    
FROM product;

-- We can also use ROWS in place of RANGE in the FRAME clause as it will consider what different rows need to be considered within a frame. 
SELECT *,
first_value(product_name) over(PARTITION BY product_category ORDER BY price DESC) 
as most_exp_product,
last_value(product_name) 
	over(PARTITION BY product_category ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
as least_exp_product    
FROM product;



-- Difference between RANGE and ROWS come when there are duplicate records.
-- For this we create a condition using the WHERE clause. 
-- Change the unbounded following to current row.
-- Now for the products having the same price the least expensive product will change for each row. 
SELECT *,
first_value(product_name) over(PARTITION BY product_category ORDER BY price DESC) 
as most_exp_product,
last_value(product_name) 
	over(PARTITION BY product_category ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
as least_exp_product    
FROM product
WHERE product_category ='Phone';



-- if we use on the entire table without the Where clause
SELECT *,
first_value(product_name) over(PARTITION BY product_category ORDER BY price DESC) 
as most_exp_product,
last_value(product_name) 
	over(PARTITION BY product_category ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
as least_exp_product    
FROM product;



-- Now if we change it to RANGE the products will be same for the same price. 
SELECT *,
first_value(product_name) over(PARTITION BY product_category ORDER BY price DESC) 
as most_exp_product,
last_value(product_name) 
	over(PARTITION BY product_category ORDER BY price DESC
		RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
as least_exp_product    
FROM product
WHERE product_category ='Phone';




-- Alternate way to write SQL query using Window functions
-- Here we will use the window clause using an alias and put it after the OVER clause. 
SELECT *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product    
FROM product
-- WHERE product_category ='Phone'
window w as (PARTITION BY product_category ORDER BY price DESC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);
            


-- And for a particular category using the Where clause
SELECT *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product    
FROM product
WHERE product_category ='Phone' 
window w as (PARTITION BY product_category ORDER BY price DESC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);
            
            
            


-- NTH_VALUE 
-- nth_value() : Here we can specify the position from where the value to be fetched. 
-- Here we need to pass 2 arguments the column name and the position as here it is 2. 
-- So it will check every second record as we needed the second most expensive product for each category. 
-- It will return a null value if the position is not available, i.e. if we pass 5 we will get null for all the categories where the products numbers are less than 5. 
-- Write query to display the Second most expensive product under each category.
SELECT *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 2) over w as second_most_exp_product
FROM product
window w as (PARTITION BY product_category ORDER BY price DESC
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);



-- NTILE
-- ntile() : To group together a set of data within the partition and then place it into certain buckets. 
-- SQl will try to keep almost equal number of records for each partitions. 
-- Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.
SELECT x.product_name, 
CASE WHEN x.buckets = 1 THEN 'Expensive Phones'
     WHEN x.buckets = 2 THEN 'Mid Range Phones'
     WHEN x.buckets = 3 THEN 'Cheaper Phones' 
END as Phone_Category
FROM (
    SELECT *,
    ntile(3) over (ORDER BY price DESC) as buckets
    FROM product
    WHERE product_category = 'Phone') x;

-- So here we created three buckets for the each range of phones i.e. Expensive, Mid Range and Cheaper. 
-- As here we pass number of buckets as 3 so it creates 4 records for 1st and 3 records each for 2nd and 3rd. 



-- CUME_DIST (cumulative distribution) 
-- Use to find the distribution percentage of each record with respect to all the rows in a result set. It always return a value within range of 0 and 1. 
/*  Formula = Current Row no (or Row No with value same as current row) / Total no of rows */

-- Query to fetch all products which are constituting the first 30% 
-- of the data in products table based on price.
SELECT product_name, cume_dist_percetage
FROM (
    SELECT *,
    cume_dist() over (order by price desc) as cume_distribution,
    round(cume_dist() over (order by price desc) * 100,2) as cume_dist_percetage
    from product) x
where x.cume_distribution <= 0.3;

SELECT *,
cume_dist() over (ORDER BY price DESC) as cume_distribution,
round(cume_dist() over (ORDER BY price DESC)* 100, 2) as cume_dist_percentage
FROM product;




-- PERCENT_RANK (relative rank of the current row / Percentage Ranking)
-- It provides a relative rank to each row. 
/* Formula = Current Row No - 1 / Total no of rows - 1 */

-- Query to identify how much percentage more expensive is "Galaxy Z Fold 3" when compared to all products.
SELECT product_name, per
FROM (
    SELECT *,
    percent_rank() over(ORDER BY price),
    round(percent_rank() over(ORDER BY price)* 100, 2) as per
    from product) x
WHERE x.product_name='Galaxy Z Fold 3';

-- So the Galaxy Z Fold 3 is 80% more expensive than all the other products. 