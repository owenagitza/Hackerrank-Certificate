-- FULL TABLE
SELECT *
FROM Functions;


WITH cte1 AS (
	-- QUERY 1
	-- First, I need to create a joined Functions table [X1, Y1, X2, Y2]
	-- As stated by the problem, it needs to satisfy the following criteria
	-- X1 = Y2
	-- X2 = Y1
	-- X1 < Y1
	-- The first 2 conditions are satisfied inside the JOIN clause
	SELECT
		t1.X X1,
		t1.Y Y1,
		t2.X X2,
		t2.Y Y2
	FROM
		Functions t1
		JOIN Functions t2 ON t1.X = t2.Y AND t2.X = t1.Y
	WHERE t1.X <= t1.Y
)

-- FINAL QUERY
-- QUERY 1 lists all possible combinations of (X1, Y1) and (X2, Y2) that satisfies the conditions
-- I want rows that matches either of these criterias:
-- 1. X1 != Y1
-- 2. Appears more than once (COUNT(*) > 1)
-- Ordered by X1
SELECT
	X1,
	Y1
FROM cte1
GROUP BY 
	X1,
	Y1
HAVING X1 != Y1 OR COUNT(*) > 1
ORDER BY X1;