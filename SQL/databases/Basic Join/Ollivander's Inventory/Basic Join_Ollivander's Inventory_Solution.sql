-- Failed
-- WITH cte1 AS (
-- 	SELECT
-- 		w.id,
-- 		wp.age,
-- 		w.coins_needed,
-- 		w.power
-- 	FROM
-- 		Wands w
-- 		LEFT JOIN Wands_Property wp USING(code)
-- 	WHERE wp.is_evil = 0
-- )
-- SELECT
-- 	id,
-- 	age,
-- 	MIN(coins_needed),
-- 	power
-- FROM cte1
-- GROUP BY
-- 	age,
--     power
-- ORDER BY
-- 	w.power DESC,
--     wp.age DESC
    
-- Worked
WITH cte1 AS (
	SELECT
		w.id,
		wp.age,
		w.coins_needed,
		w.power,
		ROW_NUMBER() OVER (
			PARTITION BY age, power
			ORDER BY coins_needed
		) row_num
	FROM
		Wands w
		LEFT JOIN Wands_Property wp ON w.code = wp.code
	WHERE wp.is_evil = 0
)
SELECT
	id,
	age,
	coins_needed,
	power
FROM cte1
WHERE row_num = 1
ORDER BY
	power DESC,
    age DESC