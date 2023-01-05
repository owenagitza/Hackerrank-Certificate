-- ALL TABLES
SELECT *
FROM Contests;


SELECT *
FROM Colleges;


SELECT *
FROM Challenges;


SELECT *
FROM View_Stats;


SELECT *
FROM Submission_Stats;


-- QUERY 1
-- Contests ([Can have] Many) => Colleges
-- Colleges ([Can have] One) => Contests
-- Colleges ([Can have] Many) => Challenges
-- Challenges ([Can have] One) => Colleges
-- Using this relationship, I need to combine Contests, Colleges, and Challenges (Since the problem states that she forgot the contest_id)
-- This query will be used to aggregate View_Stats and Submission_Stats
SELECT
	co.contest_id,
	co.college_id,
	ca.challenge_id
FROM
	Challenges ca
	LEFT JOIN Colleges co ON ca.college_id = co.college_id
ORDER BY ca.challenge_id;


-- QUERY 2
-- First of all, it is important to notice that we cannot merge View_Stats and Submission_Stats
-- This is because challenge_id will be used as connector for the merging and that will result in a false table
-- The merged table is false because some challenge ONLY has view stats (total_views & total_unique_views
-- And likewise some challenge ONLY has submission stats (total_submissions & total_accepted_submissions)
-- Therefore, I need to perform aggregation separately
-- This query is the aggregation of View_Stats based on contest_id

-- Temp table (cte2)
-- NULL values are changed to 0
WITH cte1 AS (
	SELECT
		co.contest_id,
		co.college_id,
		ca.challenge_id
	FROM
		Challenges ca
		LEFT JOIN Colleges co ON ca.college_id = co.college_id
)

SELECT 
	cte1.contest_id,
	cte1.challenge_id,
	CASE WHEN vs.total_views IS NULL THEN 0 ELSE vs.total_views END total_views,
	CASE WHEN vs.total_unique_views IS NULL THEN 0 ELSE vs.total_unique_views END total_unique_views
FROM
	cte1
	LEFT JOIN View_Stats vs ON cte1.challenge_id = vs.challenge_id
ORDER BY cte1.contest_id;


-- Q2 result (vsag)
WITH cte1 AS (
	SELECT
		co.contest_id,
		co.college_id,
		ca.challenge_id
	FROM
		Challenges ca
		LEFT JOIN Colleges co ON ca.college_id = co.college_id
),

cte2 AS (
	SELECT 
		cte1.contest_id,
		cte1.challenge_id,
		CASE WHEN vs.total_views IS NULL THEN 0 ELSE vs.total_views END total_views,
		CASE WHEN vs.total_unique_views IS NULL THEN 0 ELSE vs.total_unique_views END total_unique_views
	FROM
		cte1
		LEFT JOIN View_Stats vs ON cte1.challenge_id = vs.challenge_id
)

SELECT
	contest_id,
	SUM(total_views) sum_total_views,
	SUM(total_unique_views) sum_total_unique_views
FROM cte2
GROUP BY contest_id
ORDER BY contest_id;


-- QUERY 3
-- This query is the aggregation of Submission_Stats based on contest_id

-- Temp table (cte3)
-- NULL values are changed to 0
WITH cte1 AS (
	SELECT
		co.contest_id,
		co.college_id,
		ca.challenge_id
	FROM
		Challenges ca
		LEFT JOIN Colleges co ON ca.college_id = co.college_id
)

SELECT 
	cte1.contest_id,
	cte1.challenge_id,
	CASE WHEN ss.total_submissions IS NULL THEN 0 ELSE ss.total_submissions END total_submissions,
	CASE WHEN ss.total_accepted_submissions IS NULL THEN 0 ELSE ss.total_accepted_submissions END total_accepted_submissions
FROM
	cte1
	LEFT JOIN Submission_Stats ss ON cte1.challenge_id = ss.challenge_id
ORDER BY cte1.contest_id;


-- Q3 result (ssag)
WITH cte1 AS (
	SELECT
		co.contest_id,
		co.college_id,
		ca.challenge_id
	FROM
		Challenges ca
		LEFT JOIN Colleges co ON ca.college_id = co.college_id
),

cte3 AS (
	SELECT 
		cte1.contest_id,
		cte1.challenge_id,
		CASE WHEN ss.total_submissions IS NULL THEN 0 ELSE ss.total_submissions END total_submissions,
		CASE WHEN ss.total_accepted_submissions IS NULL THEN 0 ELSE ss.total_accepted_submissions END total_accepted_submissions
	FROM
		cte1
		LEFT JOIN Submission_Stats ss ON cte1.challenge_id = ss.challenge_id
)

SELECT
	contest_id,
	SUM(total_submissions) sum_total_submissions,
	SUM(total_accepted_submissions) sum_total_accepted_submissions
FROM cte3
GROUP BY contest_id
ORDER BY contest_id;


-- FINAL QUERY
-- All that's left to do is to take view stats from vsag and submission stats from ssag
-- This is done by left joining Contests to vsag and ssag
-- Records that have neither view stats and submission stats (NULL) are omitted
WITH cte1 AS (
	SELECT
		co.contest_id,
		co.college_id,
		ca.challenge_id
	FROM
		Challenges ca
		LEFT JOIN Colleges co ON ca.college_id = co.college_id
),

cte2 AS (
	SELECT 
		cte1.contest_id,
		cte1.challenge_id,
		CASE WHEN vs.total_views IS NULL THEN 0 ELSE vs.total_views END total_views,
		CASE WHEN vs.total_unique_views IS NULL THEN 0 ELSE vs.total_unique_views END total_unique_views
	FROM
		cte1
		LEFT JOIN View_Stats vs ON cte1.challenge_id = vs.challenge_id
),

vsagg AS (
	SELECT
		contest_id,
		SUM(total_views) sum_total_views,
		SUM(total_unique_views) sum_total_unique_views
	FROM cte2
	GROUP BY contest_id
),

cte3 AS (
	SELECT 
		cte1.contest_id,
		cte1.challenge_id,
		CASE WHEN ss.total_submissions IS NULL THEN 0 ELSE ss.total_submissions END total_submissions,
		CASE WHEN ss.total_accepted_submissions IS NULL THEN 0 ELSE ss.total_accepted_submissions END total_accepted_submissions
	FROM
		cte1
		LEFT JOIN Submission_Stats ss ON cte1.challenge_id = ss.challenge_id
),

ssagg AS (
	SELECT
		contest_id,
		SUM(total_submissions) sum_total_submissions,
		SUM(total_accepted_submissions) sum_total_accepted_submissions
	FROM cte3
	GROUP BY contest_id
)

SELECT 
	cn.contest_id,
	cn.hacker_id,
	cn.name,
	ssagg.sum_total_submissions,
	ssagg.sum_total_accepted_submissions,
	vsagg.sum_total_views,
	vsagg.sum_total_unique_views
FROM
	Contests cn
	LEFT JOIN ssagg ON cn.contest_id = ssagg.contest_id
	LEFT JOIN vsagg ON cn.contest_id = vsagg.contest_id
WHERE 
	ssagg.sum_total_submissions IS NOT NULL
	AND ssagg.sum_total_accepted_submissions IS NOT NULL
	AND vsagg.sum_total_views IS NOT NULL
	AND vsagg.sum_total_unique_views IS NOT NULL
ORDER BY cn.contest_id