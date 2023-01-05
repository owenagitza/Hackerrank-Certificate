-- FULL TABLE
SELECT *
FROM Projects;


-- QUERY 1
SELECT
	Task_ID,
	Start_Date,
	End_Date,
	LAG(End_Date, 1) OVER (
		ORDER BY Start_Date
	) Lag_1,
	CASE 
		WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
		ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
	END Day_Diff
FROM Projects;


-- QUERY 2
WITH cte1 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		LAG(End_Date, 1) OVER (
			ORDER BY Start_Date
		) Lag_1,
		CASE 
			WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
			ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
		END Day_Diff
	FROM Projects
)

SELECT
	Task_ID,
	Start_Date,
	End_Date,
	Lag_1,
	Day_Diff,
	CASE WHEN Day_Diff = 1 THEN 0 ELSE 1 END AS Logic
FROM cte1;


-- QUERY 3
WITH cte1 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		LAG(End_Date, 1) OVER (
			ORDER BY Start_Date
		) Lag_1,
		CASE 
			WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
			ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
		END Day_Diff
	FROM Projects
),

cte2 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		Lag_1,
		Day_Diff,
		CASE WHEN Day_Diff = 1 THEN 0 ELSE 1 END AS Logic
	FROM cte1
)

SELECT
	Task_ID,
	Start_Date,
	End_Date,
	Lag_1,
	Day_Diff,
	Logic,
	1 + SUM(Logic) OVER (ORDER BY Start_Date) Groups
FROM cte2;


-- QUERY 4
WITH cte1 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		LAG(End_Date, 1) OVER (
			ORDER BY Start_Date
		) Lag_1,
		CASE 
			WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
			ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
		END Day_Diff
	FROM Projects
),

cte2 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		Lag_1,
		Day_Diff,
		CASE WHEN Day_Diff = 1 THEN 0 ELSE 1 END AS Logic
	FROM cte1
),

cte3 AS (
SELECT
	Task_ID,
	Start_Date,
	End_Date,
	Lag_1,
	Day_Diff,
	Logic,
	1 + SUM(Logic) OVER (ORDER BY Start_Date) Groups
FROM cte2
)

SELECT
	Groups,
	COUNT(*) Duration
FROM cte3
GROUP BY Groups;


-- QUERY 5
WITH cte1 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		LAG(End_Date, 1) OVER (
			ORDER BY Start_Date
		) Lag_1,
		CASE 
			WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
			ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
		END Day_Diff
	FROM Projects
),

cte2 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		Lag_1,
		Day_Diff,
		CASE WHEN Day_Diff = 1 THEN 0 ELSE 1 END AS Logic
	FROM cte1
),

cte3 AS (
SELECT
	Task_ID,
	Start_Date,
	End_Date,
	Lag_1,
	Day_Diff,
	Logic,
	1 + SUM(Logic) OVER (ORDER BY Start_Date) Groups
FROM cte2
),

cte4 AS (
	SELECT
		Groups,
		COUNT(*) Duration
	FROM cte3
	GROUP BY Groups
)

SELECT
	cte3.Task_ID,
	cte3.Start_Date,
	cte3.End_Date,
	cte3.Lag_1,
	cte3.Day_Diff,
	cte3.Logic,
	cte3.Groups,
	cte4.Duration
FROM cte3 JOIN cte4 ON cte3.Groups = cte4.Groups;


-- QUERY 6
WITH cte1 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		LAG(End_Date, 1) OVER (
			ORDER BY Start_Date
		) Lag_1,
		CASE 
			WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
			ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
		END Day_Diff
	FROM Projects
),

cte2 AS (
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		Lag_1,
		Day_Diff,
		CASE WHEN Day_Diff = 1 THEN 0 ELSE 1 END AS Logic
	FROM cte1
),

cte3 AS (
SELECT
	Task_ID,
	Start_Date,
	End_Date,
	Lag_1,
	Day_Diff,
	Logic,
	1 + SUM(Logic) OVER (ORDER BY Start_Date) Groups
FROM cte2
),

cte4 AS (
	SELECT
		Groups,
		COUNT(*) Duration
	FROM cte3
	GROUP BY Groups
),

cte5 AS (
	SELECT
		cte3.Task_ID,
		cte3.Start_Date,
		cte3.End_Date,
		cte3.Lag_1,
		cte3.Day_Diff,
		cte3.Logic,
		cte3.Groups,
		cte4.Duration
	FROM cte3 JOIN cte4 ON cte3.Groups = cte4.Groups
)

SELECT
	MIN(Start_Date) Group_Start_Date,
	MAX(End_Date) Group_End_Date,
	Groups,
	Duration
FROM cte5
GROUP BY
	Groups,
	Duration;


-- FULL QUERY
WITH cte1 AS (
	-- QUERY 1
	-- Create Lag_1 column that is the previous End_Date with the lag of 1
	-- Create Day_Diff column that is the difference between End_Date and Lag_1 in days
	-- If the value is NULL, which is at the first row, then change to 1
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		LAG(End_Date, 1) OVER (
			ORDER BY Start_Date
		) Lag_1,
		CASE 
			WHEN DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date) IS NULL THEN 1
			ELSE DATEDIFF(day, LAG(End_Date, 1) OVER (ORDER BY Start_Date), End_Date)
		END Day_Diff
	FROM Projects
),

cte2 AS (
	-- QUERY 2
	-- I want to group the rows if Day_Diff is NOT 1 (Given by the problem)
	-- I need 2 steps for this, first is by creating a logic column for which rows to be counted as different groups
	-- Create Logic column that returns 0 if Day_Diff = 1, otherwise return 1
	SELECT
		Task_ID,
		Start_Date,
		End_Date,
		Lag_1,
		Day_Diff,
		CASE WHEN Day_Diff = 1 THEN 0 ELSE 1 END AS Logic
	FROM cte1
),

cte3 AS (
SELECT
	-- QUERY 3
	-- The grouping will group projects that are differing only by 1 day as 1 group
	-- This effect is achieved using SUM() OVER, hence, Logic returns 0 (The same group) if Day_Diff = 1
	-- Window function (OVER) is needed since sum requires GROUP BY
	-- Groups column is added by 1 to make the first group as Group 1 not Group 0
	Task_ID,
	Start_Date,
	End_Date,
	Lag_1,
	Day_Diff,
	Logic,
	1 + SUM(Logic) OVER (ORDER BY Start_Date) Groups
FROM cte2
),

cte4 AS (
	-- QUERY 4
	-- Now I need to get the duration of days for each group
	-- However, this could easily be done using plain GROUP BY since the duration of each rows is guaranteed as 1 day (Given by the problem)
	-- This query will perform as a lookup table
	SELECT
		Groups,
		COUNT(*) Duration
	FROM cte3
	GROUP BY Groups
),

cte5 AS (
	-- QUERY 5
	-- Now, every group has its duration
	-- Next, I need to join cte3 and the lookup table (cte4) using JOIN 
	SELECT
		cte3.Task_ID,
		cte3.Start_Date,
		cte3.End_Date,
		cte3.Lag_1,
		cte3.Day_Diff,
		cte3.Logic,
		cte3.Groups,
		cte4.Duration
	FROM cte3 JOIN cte4 ON cte3.Groups = cte4.Groups
),

cte6 AS (
	-- QUERY 6
	-- Now I need to get the start and end date for every group
	-- Group_Start_Date by definition is the MINIMUM start date for that group
	-- Group_End_Date by definition is the MAXIMUM end date for that group
	-- The query is grouped by Groups and Duration
	-- Duration is included in GROUP BY since I want to include it in the table to order by the that column
	SELECT
		MIN(Start_Date) Group_Start_Date,
		MAX(End_Date) Group_End_Date,
		Groups,
		Duration
	FROM cte5
	GROUP BY
		Groups,
		Duration
)

-- FINAL QUERY
-- All that is left to do is to select only Group_Start_Date and Group_End_Date
-- Ordered by Duration ascending and Group_Start_Date
SELECT
	Group_Start_Date,
	Group_End_Date
FROM cte6
ORDER BY
	Duration,
	Group_Start_Date;