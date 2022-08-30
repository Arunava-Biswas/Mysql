-- Procedure:

CREATE DATABASE IF NOT EXISTS proc;

USE proc;

SHOW TABLES;

-- For the non parameter part
CREATE TABLE products(
	product_code VARCHAR(20),
    product_name VARCHAR(100),
    price DOUBLE,
    quantity_remaining INT,
    quantity_sold INT
);

CREATE TABLE sales(
	order_id INT NOT NULL AUTO_INCREMENT,
    order_date DATE,
    product_code VARCHAR(20),
    quantity_ordered INT,
    sale_price DOUBLE,
    PRIMARY KEY(order_id)
);



INSERT INTO products(product_code, product_name, price, quantity_remaining, quantity_sold)
VALUES
("P1", "iPhone 13 Pro Max", 1000, 5, 195);

INSERT INTO sales(order_date, product_code, quantity_ordered, sale_price)
VALUES
("2022-01-10", "P1", 100, 120000),
("2022-01-20", "P1", 50, 60000),
("2022-02-05", "P1", 45, 540000);


-- For the with parameter part
CREATE TABLE prod_params(
	product_code VARCHAR(20),
    product_name VARCHAR(100),
    price DOUBLE,
    quantity_remaining INT,
    quantity_sold INT
);

CREATE TABLE sale_params(
	order_id INT NOT NULL AUTO_INCREMENT,
    order_date DATE,
    product_code VARCHAR(20),
    quantity_ordered INT,
    sale_price DOUBLE,
    PRIMARY KEY(order_id)
);


INSERT INTO prod_params(product_code, product_name, price, quantity_remaining, quantity_sold)
VALUES
("P1", "iPhone 13 Pro Max", 1200, 5, 195),
("P2", "Airpods Pro", 279, 10, 90),
("P3", "MacBook Pro 16", 5000, 2, 48),
("P4", "iPad Air", 650, 1, 9);

INSERT INTO sale_params(order_date, product_code, quantity_ordered, sale_price)
VALUES
("2022-01-10", "P1", 100, 120000),
("2022-01-20", "P1", 50, 60000),
("2022-02-05", "P1", 45, 540000),
("2022-01-15", "P2", 50, 13950),
("2022-03-25", "P2", 40, 11160),
("2022-03-25", "P3", 10, 50000),
("2022-02-15", "P3", 10, 50000),
("2022-03-25", "P3", 20, 100000),
("2022-04-21", "P3", 8, 40000),
("2022-04-27", "P4", 9, 5850);


SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM prod_params;
SELECT * FROM sale_params;

DROP TABLE sales;

/*
1. What is a PROCEDURE?
- Procedure is a block of code which is named and stored in the database. This block of code can be any SQL queries or several SQL commands like
DML, DCL, DDL, TCL commands or several cocepts(collection types, Cursors, Loop & IF ELSE statements, variables, Exception handling, etc.)
- Procedures can be used to create complex logics for data validation, data cleanup and much more other than query data from tables.

2. Purpose of PROCEDURE:
- It provides more power to the SQL language. i.e. it is use to do things which are not possible to do with simple SQL queries.

3. Syntax of PROCEDURE:

- in POSTGRESSQL:
create or replace procedure procedure_name(p_name1 datatype, p_name2 datatype)
language plpgsql (It is specific to PGSQL as this RDBMS works with many languages, plpgsql: Procedural Language PGSQL)
as $$
declare
	variableNames datatypes;
begin
	procedure body - all logics
end;
$$

** The '$$' sign is used so we can handle the single quotes inside the code. 
** The 'or replace' is used so that if a procedure is already exists of the same name then it would not throw an error. 


- in ORACLE:
create or replace procedure procedure_name(p_name1 datatype, p_name2 datatype)
as
	variableNames datatypes;
begin
	procedure body - all logics
end;


- in Microsoft SQL Server - Azure database:
create or alter procedure procedure_name(@p_name1 datatype, @p_name2 datatype)
as
	declare @variableName1 datatype,
			@variableName2 datatype
            @variableName3 datatype;
begin
	procedure body - all logics
end;

** Here all the parameters and variable names must start with the sign '@' like '@param1'. 
** Here in place of 'replace' we need to use 'alter' to create a procedure. 


- in MySQL:
DELIMITER $$
DROP procedure IF EXISTS procedure_name
create procedure procedure_name(p_name1 datatype, p_name2 datatype)
begin
	declare @variableName1 datatype;
	declare	@variableName2 datatype;
	declare @variableName3 datatype;
    
	procedure body - all logics;
end$$


** Here we need to define the DELIMITER befor creating the procedure, by default it is ';'. But in MySQL if we pass many queries each ends with
a ';' it will take it as a procedure, so to overcome the problem we need to set the DELIMITER to some other sign like '$$' and we need to 
provide the same sign after the 'end' to let MySQL know that it is a whole statement. 
** Here to declare multiple variable we need to use multiple 'declare' sepearately as multiple declare not work here. 
** Here we need to use DROP procedure at begining as replace will not work.
** Here we need to declare inside the begin section.
*/


-- PROCEDURE WITHOUT PARAMETERS:
-- For this we will use tables 'products' and 'sales'

-- Q1: For every iPhone 13 Pro Max sale modify the database table accordingly. 
/*
To do this everytime a sale took place we need to add it into the sales table and we need to update the columns quantity_remaining and 
quantity_sold of the products table. 
Now instead of doing the task again and again manually let's create a procedure for the modification.
*/

-- Creating the PROCEDURE:
DELIMITER $$
DROP procedure if exists pr_buy_products;
CREATE procedure pr_buy_products()
begin
	declare v_product_code VARCHAR(20);
	declare	v_price DOUBLE;
    
	SELECT product_code, price
    into v_product_code, v_price
    FROM products
    WHERE product_name = 'iPhone 13 Pro Max';
    
    INSERT INTO sales(order_date, product_code, quantity_ordered, sale_price)
	VALUES
	(current_date, v_product_code, 1, (v_price * 1));
    
    UPDATE products SET quantity_remaining = (quantity_remaining - 1), 
    quantity_sold = (quantity_sold + 1) WHERE product_code = v_product_code;
    
    SELECT 'Product Sold!' AS Result;		-- to print the message
end$$




-- PROCEDURE WITH PARAMETERS:
-- For this we will use tables 'prod_params' and 'sale_params'.

/*
 -- Q2: For every given product and the quantity,
		1) Check if the product is available based on the required QUANTITY. 
        2) If available then modify the database tables accordingly. 
*/

/*
Here we need to pass the parameters along with their datatypes in the procedure based on the requirement.
As in this case the product name and quantity will be provided so they are our parameters to be passed. 
If we don't mention 'IN' or 'OUT' then parameters declared in the procedure will be taken as the input parameters passed by the user by default. 
These parameters will be used when the procedure is called. We can use these input parameters anywhere in the procedure. 
In case the required quantity doesnot match the quantity remaining in that case we should show a message instead of throwing an error. To do
this 1st we need to check whether given required data match the amount available in the database. 
Once we create the condition then we use the CASE statement in IF ELSE to print the message or do our task. 
A good practice is to keep the variable names as 'v_name' and parameter names as 'p_name'
*/

-- Creating the PROCEDURE:
DELIMITER $$
DROP procedure if exists pr_buy_prods;
CREATE procedure pr_buy_prods(p_productName VARCHAR(100), p_quantity INT)
begin	
	declare v_product_code VARCHAR(20);
	declare	v_price DOUBLE;
    declare v_cnt INT;
    
    -- Creating condition to check if the required quantity matches with the quantity available for a particular product
    -- Here v_cnt is a variable to store the result we get from the condition
	SELECT count(1)
    into v_cnt
    FROM prod_params
    WHERE product_name = p_productName
    and quantity_remaining >= p_quantity;
    
    -- Now using the variable we create our IF ELSE statement
    -- Now we will not hardcode the product name as we have more than one product so we use the input parameter for product name
    -- Need to do the same for quasntity also
    if v_cnt > 0 then
		SELECT product_code, price
		into v_product_code, v_price
		FROM prod_params
		WHERE product_name = p_productName;				
		
		INSERT INTO sale_params(order_date, product_code, quantity_ordered, sale_price)
		VALUES
		(current_date, v_product_code, p_quantity, (v_price * p_quantity));
		
		UPDATE prod_params SET quantity_remaining = (quantity_remaining - p_quantity), 
		quantity_sold = (quantity_sold + p_quantity) WHERE product_code = v_product_code;
		
		SELECT 'Product Sold!' AS Result;		-- to print the success message
	else
		SELECT 'Insufficient Quantity!' AS Result;  -- to print the error message
    end if;
end$$