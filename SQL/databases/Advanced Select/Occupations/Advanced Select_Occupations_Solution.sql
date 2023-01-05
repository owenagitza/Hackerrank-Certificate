-- SELECT *
-- FROM OCCUPATIONS;

-- Query 1
-- SELECT
-- 	Name,
--     Occupation
-- FROM OCCUPATIONS
-- ORDER BY
-- 	Occupation,
--     Name;

-- Query 2
-- SELECT
-- 	Name,
--     Occupation,
--     ROW_NUMBER() OVER (
-- 		PARTITION BY Occupation
--         ORDER BY Name
--         ) R_number
-- FROM OCCUPATIONS;

-- Query 3
-- WITH cte1 AS (
-- 	SELECT
-- 		Name,
-- 		Occupation,
-- 		ROW_NUMBER() OVER (
-- 			PARTITION BY Occupation
-- 			ORDER BY Name
-- 			) R_number
-- 	FROM OCCUPATIONS
--     )
-- SELECT
-- 	R_number,
--     CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END AS Doctor,
--     CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END AS Professor,
--     CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END AS Singer,
--     CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END AS Actor
-- FROM cte1;

-- Query 4
-- WITH cte1 AS (
-- 	SELECT
-- 		Name,
-- 		Occupation,
-- 		ROW_NUMBER() OVER (
-- 			PARTITION BY Occupation
-- 			ORDER BY Name
-- 			) R_number
-- 	FROM OCCUPATIONS
--     )
-- SELECT
-- 	R_number,
--     MAX(CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END) AS Doctor,
--     MAX(CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END) AS Professor,
--     MAX(CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END) AS Singer,
--     MAX(CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END) AS Actor
-- FROM cte1
-- GROUP BY R_number;

-- Result
WITH cte1 AS (
	SELECT
		Name,
		Occupation,
		ROW_NUMBER() OVER (
			PARTITION BY Occupation
			ORDER BY Name
			) R_number
	FROM OCCUPATIONS
    )
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END) AS Actor
FROM cte1
GROUP BY R_number;