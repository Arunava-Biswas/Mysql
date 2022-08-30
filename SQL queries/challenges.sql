CREATE DATABASE IF NOT EXISTS challenge;
USE challenge;

/*
										Problem from Hackerrank

- 15 Days of Learning SQL

Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least 1 submission each day (starting on the first day of the contest), 
and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number 
of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

*/

-- Creating tables for the challenge:
CREATE TABLE IF NOT EXISTS hackers(
	sl_no INT NOT NULL AUTO_INCREMENT,
	hacker_id INT,
    name VARCHAR(50),
    PRIMARY KEY(sl_no)
);

CREATE TABLE IF NOT EXISTS submissions(
	sl_no INT NOT NULL AUTO_INCREMENT,
	submission_date DATE,
    submission_id INT,
    hacker_id INT,
    score INT,
    PRIMARY KEY(sl_no)
);


INSERT INTO hackers(hacker_id, name)
VALUES
(15758, "Rose"),
(20703, "Angela"),
(36396, "Frank"),
(38289, "Patrick"),
(44065, "Lisa"),
(53473, "Kimberly"),
(62529, "Bonnie"),
(79722, "Michael");


INSERT INTO submissions(submission_date, submission_id, hacker_id, score)
VALUES
("2016-03-01", 8494, 20703, 0),
("2016-03-01", 22403, 53473, 15),
("2016-03-01", 23965, 79722, 60),
("2016-03-01", 30173, 36396, 70),
("2016-03-02", 34928, 20703, 0),
("2016-03-02", 38740, 15758, 60),
("2016-03-02", 42769, 79722, 25),
("2016-03-02", 44364, 79722, 60),
("2016-03-03", 45440, 20703, 0),
("2016-03-03", 49050, 36396, 70),
("2016-03-03", 50273, 79722, 5),
("2016-03-04", 50344, 20703, 0),
("2016-03-04", 51360, 44065, 90),
("2016-03-04", 54404, 53473, 65),
("2016-03-04", 61533, 79722, 45),
("2016-03-05", 72852, 20703, 0),
("2016-03-05", 74546, 38289, 0),
("2016-03-05", 76487, 62529, 0),
("2016-03-05", 82439, 36396, 10),
("2016-03-05", 90006, 36396, 40),
("2016-03-06", 90404, 20703, 0);

-- checking the tables:
SELECT * FROM hackers;
SELECT * FROM submissions;

-- 1st part
-- Write a query to print total number of unique hackers who made at least 1 submission each day (starting on the first day of the contest).

/*
To solve this 1st we need to find how many unique hackers made submission on Day 1. Then on Day 2 we need to find the unique hackers who have
made submissions on both Day 1 and Day 2. Same will go for all the rest of the days likewise, i.e. unique hackers who already was present on
previous days. 
So we need to use the recursive SQL query to solve this as we need to fetch data from 1 day at a time.
*/

-- Syntax is:
/*
WITH RECURSIVE cte AS
	(base query
    union
    recursive query)
select * from cte;
*/

-- base query
SELECT 
    DISTINCT submission_date, hacker_id
FROM
    submissions
WHERE
    submission_date = (SELECT 
            MIN(submission_date)
        FROM
            submissions);


-- recursive query            
WITH RECURSIVE cte AS
	(SELECT 
		DISTINCT submission_date, hacker_id
	FROM
		submissions
	WHERE
		submission_date = (SELECT 
				MIN(submission_date)
			FROM
				submissions)
    UNION
    SELECT 
		s.submission_date, s.hacker_id
	FROM
		submissions s
	JOIN cte on cte.hacker_id = s.hacker_id WHERE s.submission_date = (SELECT MIN(submission_date) FROM submissions 
																		WHERE submission_date > cte.submission_date))
SELECT submission_date, COUNT(1) AS No_of_unique_hackers 
FROM cte 
GROUP BY submission_date 
ORDER BY 1;


-- 2nd Part

-- Find the hacker_id and name of the hacker who made maximum number of submissions each day. 


/*
- 1st we need to find for each date how many submissions are done by each hacker. 
- Based on the data count the maximum submissions for each dates.
*/

WITH count_submissions as
		(SELECT submission_date, hacker_id, COUNT(1) AS no_of_submissions 
        FROM submissions GROUP BY submission_date, hacker_id ORDER BY 1),
     max_submissions as
		(SELECT submission_date, MAX(no_of_submissions) 
        FROM count_submissions GROUP BY submission_date)
SELECT * FROM max_submissions;



-- Now join both the cte tables using a join clause on the submission_date and then fetch the hacker_name for maximum submission for each day

WITH count_submissions as
		(SELECT submission_date, hacker_id, COUNT(1) AS no_of_submissions 
        FROM submissions GROUP BY submission_date, hacker_id ORDER BY 1),
     max_submissions as
		(SELECT submission_date, MAX(no_of_submissions) AS max_submissions
        FROM count_submissions GROUP BY submission_date)
SELECT c.submission_date, c.hacker_id, c.no_of_submissions
FROM max_submissions m
JOIN
count_submissions c 
	ON c.submission_date = m.submission_date
    AND c.no_of_submissions = m.max_submissions;
    
  
  
  
-- 3rd part:

/*
If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. 
The query should print this information for each day of the contest, sorted by the date.
*/

-- Here for each day we got the hacker id who has done maximum number of submissions

WITH count_submissions as
		(SELECT submission_date, hacker_id, COUNT(1) AS no_of_submissions 
        FROM submissions GROUP BY submission_date, hacker_id ORDER BY 1),
     max_submissions as
		(SELECT submission_date, MAX(no_of_submissions) AS max_submissions
        FROM count_submissions GROUP BY submission_date)
SELECT c.submission_date, MIN(c.hacker_id) AS hacker_id
FROM max_submissions m
JOIN
count_submissions c 
	ON c.submission_date = m.submission_date
    AND c.no_of_submissions = m.max_submissions
GROUP BY c.submission_date;



-- Now merge all the queries so we get all the columns together specific to each date

WITH RECURSIVE cte AS
		(SELECT DISTINCT submission_date, hacker_id
		FROM submissions 
		WHERE submission_date = (SELECT MIN(submission_date) FROM submissions)
		UNION
		SELECT s.submission_date, s.hacker_id
		FROM submissions s
		JOIN cte on cte.hacker_id = s.hacker_id 
        WHERE s.submission_date = (SELECT MIN(submission_date) FROM submissions 
									WHERE submission_date > cte.submission_date)
		),
        
    unique_hackers AS                                                                    
		(SELECT submission_date, COUNT(1) AS No_of_unique_hackers 
		FROM cte 
		GROUP BY submission_date),
        
	count_submissions AS
		(SELECT submission_date, hacker_id, COUNT(1) AS no_of_submissions 
        FROM submissions GROUP BY submission_date, hacker_id ORDER BY 1),
        
     max_submissions AS
		(SELECT submission_date, MAX(no_of_submissions) AS max_submissions
        FROM count_submissions GROUP BY submission_date),
        
	final_hackers as
		(SELECT c.submission_date, MIN(c.hacker_id) AS hacker_id
		FROM max_submissions m
		JOIN
		count_submissions c 
			ON c.submission_date = m.submission_date
			AND c.no_of_submissions = m.max_submissions
		GROUP BY c.submission_date)
        
SELECT u.submission_date, u.No_of_unique_hackers, f.hacker_id, hck.name AS Hacker_name
FROM unique_hackers u
JOIN 
final_hackers f ON f.submission_date = u.submission_date
JOIN
hackers hck ON hck.hacker_id = f.hacker_id
ORDER BY 1;