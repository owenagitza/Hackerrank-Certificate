WITH cte1 AS (
    SELECT
        s.submission_id,
        s.hacker_id,
        h.name,
        s.challenge_id,
        s.score,
        d.score AS max_score
    FROM
        Submissions s
        LEFT JOIN Hackers h ON s.hacker_id = h.hacker_id
        LEFT JOIN Challenges c ON s.challenge_id = c.challenge_id
        LEFT JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    WHERE s.score = d.score
)
SELECT
    hacker_id,
    name
FROM cte1
GROUP BY
	hacker_id,
    name
HAVING COUNT(1) > 1
ORDER BY
	COUNT(1) DESC,
	hacker_id;