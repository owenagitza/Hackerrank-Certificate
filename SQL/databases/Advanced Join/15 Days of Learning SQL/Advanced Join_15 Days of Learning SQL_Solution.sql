--OBSERVATIONS
--1. On the same day, hackers can submit more than once
--2. The hackers that are considered for the next day has to consecutively submit at least once for that day
--3. If more than one such hacker has the maximum number of submissions, print the LOWEST hacker_id

--OUTPUT
--1. Date
--2. Number of consistent hackers for that date
--3. Hacker ID
--4. Hacker name

-- APPROACH
-- Solve column 1, 2 and column 3, 4 separately
-- PART A: I tackled column 1 and 2, meaning I had to find the remaining consistent hackers for a given day
-- PART B: I tackled column 3 and 4, meaning I had to find hackers with the most submissions for a given day


-- PART A

-- TABLE VARIABLE INSTANTIATION
-- I needed to create a new table lists all distinct consistent hackers for each date
-- Consistent hackers are hackers who submit a submission every single day
DECLARE @consistent_hackers TABLE (
    submission_date DATE,
    hacker_id INT
)

-- VARIABLE DECLARATION FOR @consistent_hackers
-- For this query to work, I needed 2 variables:
-- 1. @currentdate => Keeps track of the current date
-- 2. @previousdate => Keeps track of the previous date
-- Both values are set to the first day i.e. 2016-03-01
-- These variables are needed since I needed to compare new hackers of the current date with the consistent ones from the previous date 
DECLARE @currentdate DATE;
SET @currentdate = '2016-03-01';

DECLARE @previousdate DATE;
SET @previousdate = '2016-03-01';

-- TABLE VARIABLE INITIATION
-- @consistent_hackers table was populated using the query below
-- This query gets all the hackers who submit on the first day
-- In other words, they were all the consistent hackers on 2016-03-01
-- DISTINCT keyword is used since there can be multiple submissions by the same hacker
INSERT INTO @consistent_hackers
SELECT DISTINCT
    submission_date,
    hacker_id
FROM Submissions
WHERE submission_date LIKE '2016-03-01';

-- TABLE VARIABLE POPULATION USING WHILE LOOP
-- From the initial @consistent_hackers table, I needed to populate it for the remaining days up until 2016-03-15
-- The conditions for a hacker to be considered consistent are:
-- 1. They submit on the current day [s.submission_date LIKE @currentdate]
-- 2. They've been submitting everyday since the first day, i.e. they also submit yesterday, and the day before, and so on [ch.submission_date LIKE @previousdate] 
WHILE @currentdate < '2016-03-15'
    BEGIN
        SET @currentdate = DATEADD(day, 1, @currentdate)

        INSERT INTO @consistent_hackers
        SELECT DISTINCT
            s.submission_date,
            s.hacker_id
        FROM 
            Submissions s
            JOIN @consistent_hackers ch ON s.hacker_id = ch.hacker_id AND ch.submission_date LIKE @previousdate
        WHERE s.submission_date LIKE @currentdate

        SET @previousdate = DATEADD(day, 1, @previousdate)
    END;

-- PART B
-- cte1 comprised of the first 2 column of the desired output
-- The approach for column 3 and 4 would be to count the number of total submissions for each day
-- Using row number, I could get the top 1 result for a given day by setting rnum = 1
WITH cte1 AS (
    SELECT 
        submission_date,
        COUNT(*) AS consistent_hackers
    FROM @consistent_hackers
    GROUP BY submission_date
),

cte2 AS (
    SELECT
        submission_date,
        hacker_id,
        COUNT(*) AS total_submissions,
        ROW_NUMBER() OVER (
            PARTITION BY submission_date
            ORDER BY 
                COUNT(*) DESC,
                hacker_id
        ) AS rnum
    FROM Submissions
    GROUP BY 
       submission_date,
       hacker_id
)

SELECT
    cte1.submission_date,
    cte1.consistent_hackers,
    cte2.hacker_id,
    h.name
FROM 
   cte2
   JOIN cte1 ON cte2.submission_date = cte1.submission_date
   JOIN Hackers h ON cte2.hacker_id = h.hacker_id
WHERE rnum = 1
ORDER BY submission_date