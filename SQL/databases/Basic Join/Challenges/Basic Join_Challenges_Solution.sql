-- FAILED SOLUTION
-- This solution actually worked in my workbench
-- However, HackerRank's MySQL does not support my solution, as such I had to use MS SQL Server
-- The solution is shown below
WITH cte1 AS (
	SELECT
		h.hacker_id,
		h.name,
		COUNT(*) AS challenge_created,
		DENSE_RANK() OVER (
			ORDER BY COUNT(*) DESC
		) ranking
	FROM
		Hackers2 h
		INNER JOIN Challenges2 c ON h.hacker_id = c.hacker_id
	GROUP BY
		h.hacker_id,
		h.name
	ORDER BY
		challenge_created DESC,
		hacker_id
)
SELECT
	hacker_id,
    name,
    challenge_created
FROM cte1
WHERE ranking = 1 OR ranking IN (SELECT ranking FROM cte1 GROUP BY ranking HAVING COUNT(ranking) = 1);


-- WORKED SOLUTION
-- In MS SQL Server, subquery and CTE both return UNORDERED SET, as such, they cannot contain ORDER BY clause inside
-- ORDER BY should be placed outside subquery and CTE i.e. in the main SELECT clause


-- INITIAL
SELECT
	h.hacker_id,
	h.name,
	COUNT(*) AS challenge_created,
	DENSE_RANK() OVER (
		ORDER BY COUNT(*) DESC
	) ranking
FROM
	Hackers2 h
	INNER JOIN Challenges2 c ON h.hacker_id = c.hacker_id
GROUP BY
	h.hacker_id,
	h.name;


-- SUBQUERY
-- This lists the ranking where none of them are repeated
-- This feature is achieved using GROUP BY ranking with COUNT(ranking) = 1
WITH cte1 AS (
    SELECT
        h.hacker_id,
        h.name,
        COUNT(*) AS challenge_created,
        DENSE_RANK() OVER (
            ORDER BY COUNT(*) DESC
        ) ranking
    FROM
        Hackers2 h
        INNER JOIN Challenges2 c ON h.hacker_id = c.hacker_id
    GROUP BY
        h.hacker_id,
        h.name
)
SELECT ranking 
FROM cte1 
GROUP BY ranking 
HAVING COUNT(ranking) = 1;


-- FINAL QUERY
WITH cte1 AS (
    SELECT
        h.hacker_id,
        h.name,
        COUNT(*) AS challenge_created,
        DENSE_RANK() OVER (
            ORDER BY COUNT(*) DESC
        ) ranking
    FROM
        Hackers2 h
        INNER JOIN Challenges2 c ON h.hacker_id = c.hacker_id
    GROUP BY
        h.hacker_id,
        h.name
)
SELECT
    hacker_id,
    name,
    challenge_created
FROM cte1
WHERE ranking = 1 OR ranking IN (SELECT ranking FROM cte1 GROUP BY ranking HAVING COUNT(ranking) = 1)
ORDER BY
    challenge_created DESC,
    hacker_id;