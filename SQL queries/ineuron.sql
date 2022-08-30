SHOW DATABASES;

-- CREATE DATABASE ineuron;

USE ineuron;

SHOW TABLES;

-- Use the symbol ` when to use keywords as column names like `column_name`.
CREATE TABLE IF NOT EXISTS bank_details (
    age INT,
    job VARCHAR(30),
    marital VARCHAR(30),
    education VARCHAR(30),
    `default` VARCHAR(30),
    balance INT,
    housing VARCHAR(30),
    loan VARCHAR(30),
    contact VARCHAR(30),
    `day` INT,
    `month` VARCHAR(30),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(30),
    y VARCHAR(30)
);


SHOW TABLES;

DESC bank_details;

-- DROP TABLE bank_details;

insert into bank_details 
values (58,"management","married","tertiary","no",2143,"yes","no","unknown",5,"may",261,1,-1,0,"unknown","no");

SELECT * FROM bank_details;


insert into bank_details values 
(44,"technician","single","secondary","no",29,"yes","no","unknown",5,"may",151,1,-1,0,"unknown","no"),
(33,"entrepreneur","married","secondary","no",2,"yes","yes","unknown",5,"may",76,1,-1,0,"unknown","no"),
(47,"blue-collar","married","unknown","no",1506,"yes","no","unknown",5,"may",92,1,-1,0,"unknown","no"),
(33,"unknown","single","unknown","no",1,"no","no","unknown",5,"may",198,1,-1,0,"unknown","no"),
(35,"management","married","tertiary","no",231,"yes","no","unknown",5,"may",139,1,-1,0,"unknown","no"),
(28,"management","single","tertiary","no",447,"yes","yes","unknown",5,"may",217,1,-1,0,"unknown","no"),
(42,"entrepreneur","divorced","tertiary","yes",2,"yes","no","unknown",5,"may",380,1,-1,0,"unknown","no"),
(58,"retired","married","primary","no",121,"yes","no","unknown",5,"may",50,1,-1,0,"unknown","no"),
(43,"technician","single","secondary","no",593,"yes","no","unknown",5,"may",55,1,-1,0,"unknown","no"),
(41,"admin.","divorced","secondary","no",270,"yes","no","unknown",5,"may",222,1,-1,0,"unknown","no"),
(29,"admin.","single","secondary","no",390,"yes","no","unknown",5,"may",137,1,-1,0,"unknown","no"),
(53,"technician","married","secondary","no",6,"yes","no","unknown",5,"may",517,1,-1,0,"unknown","no"),
(58,"technician","married","unknown","no",71,"yes","no","unknown",5,"may",71,1,-1,0,"unknown","no"),
(57,"services","married","secondary","no",162,"yes","no","unknown",5,"may",174,1,-1,0,"unknown","no"),
(51,"retired","married","primary","no",229,"yes","no","unknown",5,"may",353,1,-1,0,"unknown","no"),
(45,"admin.","single","unknown","no",13,"yes","no","unknown",5,"may",98,1,-1,0,"unknown","no"),
(57,"blue-collar","married","primary","no",52,"yes","no","unknown",5,"may",38,1,-1,0,"unknown","no"),
(60,"retired","married","primary","no",60,"yes","no","unknown",5,"may",219,1,-1,0,"unknown","no");


SELECT * FROM bank_details;


SELECT age, job FROM bank_details;
SELECT `default`, age FROM bank_details; -- using the ` for the keyword named column name
SELECT * FROM bank_details WHERE age = 41;
SELECT job FROM bank_details WHERE age = 41;
SELECT * FROM bank_details WHERE job = 'retired' AND balance > 100;
SELECT * FROM bank_details WHERE education = 'primary' OR balance < 100 ORDER BY age;
SELECT DISTINCT job FROM bank_details;
SELECT * FROM bank_details ORDER BY age DESC;
SELECT count(*) AS total_records FROM bank_details;
SELECT sum(balance) AS sum_of_bal FROM bank_details;
SELECT avg(balance) AS avg_bal FROM bank_details;
SELECT min(balance) AS min_bal FROM bank_details;
SELECT * FROM bank_details WHERE balance = (SELECT min(balance) AS min_bal FROM bank_details);
SELECT marital, count(*) AS number_of_persons FROM bank_details GROUP BY marital;
SELECT marital, count(*) AS number_of_persons, sum(balance) AS sum_of_bal FROM bank_details GROUP BY marital;
SELECT marital, count(*), sum(balance) FROM bank_details GROUP BY marital HAVING sum(balance) > 300;

UPDATE bank_details SET balance = 0 WHERE job = 'unknown';
SELECT * FROM bank_details;
UPDATE bank_details SET contact="known", y="yes" WHERE month = 'may';
UPDATE bank_details SET `default`="NULL" WHERE `default` = 'no';
DELETE FROM bank_details WHERE job = 'unknown';

-- use copy of the database or the table to make it secure as the DELETE option is non reversable. 

/*
Creating a procedure inside the mysql:
for this the syntax is:

DELIMITER &&  
CREATE PROCEDURE procedure_name [[IN | OUT | INOUT] parameter_name datatype [, parameter datatype]) ]    
BEGIN    
    Declaration_section    
    Executable_section    
END &&   
*/

-- creating the procedure
DELIMITER && 
CREATE PROCEDURE select_proc()
BEGIN
	SELECT * FROM bank_details;
END &&



-- calling the procedure
CALL select_proc();


-- with passing parameters
DELIMITER && 
CREATE PROCEDURE select_proc_filt(IN var INT)
BEGIN
	SELECT * FROM bank_details WHERE job = 'retired' AND balance > var;
END &&

CALL select_proc_filt(200); -- here the 100 is the parameter we passed




DELIMITER && 
CREATE PROCEDURE select_proc_filt2(IN var1 INT, IN var2 VARCHAR(30))
BEGIN
	SELECT * FROM bank_details WHERE job = var2 AND balance > var1;
END &&

CALL select_proc_filt2(100, 'services'); -- here the 100 and services are the parameters we passed



-- VIEW
/*
- To avoid call the entire table each time
- A set of data that we want to view is used in VIEW
- It's equivalent to a virtual table created from the actual table
- It is a subset of the actual table

syntax is:
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;

*/
-- creating the view
CREATE VIEW bank_view AS
SELECT job, age, education, y FROM bank_details;

-- using the view to run a query
SELECT * FROM bank_view WHERE age = 58;



-- JOINS

CREATE TABLE IF NOT EXISTS bank_details1 (
    age INT,
    job VARCHAR(30),
    marital VARCHAR(30),
    education VARCHAR(30),
    `default` VARCHAR(30),
    balance INT,
    housing VARCHAR(30),
    loan VARCHAR(30),
    contact VARCHAR(30),
    `day` INT,
    `month` VARCHAR(30),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(30),
    y VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS bank_details2 (
    age INT,
    job VARCHAR(30),
    marital VARCHAR(30),
    education VARCHAR(30),
    `default` VARCHAR(30),
    balance INT,
    housing VARCHAR(30),
    loan VARCHAR(30),
    contact VARCHAR(30),
    `day` INT,
    `month` VARCHAR(30),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(30),
    y VARCHAR(30)
);

insert into bank_details2 select * from bank_details where age = 58;

select * from bank_details2;


-- putting the same data from bank_detail table
/*
syntax is:
insert into destination_table select * from source_table
*/

insert into bank_details1 select * from bank_details;

select * from bank_details1;
select * from bank_details;

SELECT 
    bank_details.age, bank_details.job, bank_details.marital
FROM
    bank_details
        INNER JOIN
    bank_details1 ON bank_details.age = bank_details1.age
    
    
SELECT 
    bank_details.age, bank_details.job, bank_details.marital
FROM
    bank_details
        RIGHT JOIN
    bank_details2 ON bank_details.age = bank_details2.age
    
    
SELECT 
    bank_details.age, bank_details.job, bank_details.marital
FROM
    bank_details
        LEFT JOIN
    bank_details2 ON bank_details.age = bank_details2.age
    
    
