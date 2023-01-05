-- QUERY 1
-- I structured the select to fulfill the required output
-- Since I am required to order the output based on company code then founder alphabetically, then I used ORDER BY
SELECT
	c.company_code,
    c.founder,
    sm.senior_manager_code
FROM
	company c
    LEFT JOIN senior_manager sm USING(company_code)
ORDER BY
	c.company_code,
    c.founder;
    
-- QUERY 2
-- I chose to use COUNT, as a result I had to group it by something which is company_code
SELECT
	c.company_code,
    c.founder,
    COUNT(sm.senior_manager_code)
FROM
	company c
    LEFT JOIN senior_manager sm USING(company_code)
GROUP BY c.company_code
ORDER BY
	c.company_code,
    c.founder;

-- QUERY 3
-- Adding DISTINCT won't change anything since its function is to select only unique records (Rows with unique values across all columns
-- Since this query is just QUERY 2 with added DISTINCT keyword, you can see that QUERY 2's rows are already unique
-- As such, adding DISTINCT does not progress the solution
SELECT DISTINCT
	c.company_code,
    c.founder,
    COUNT(sm.senior_manager_code)
FROM
	company c
    LEFT JOIN senior_manager sm USING(company_code)
GROUP BY c.company_code
ORDER BY
	c.company_code,
    c.founder;

-- QUERY 4
-- Hence, I put DISTINCT inside COUNT
-- This counts the unique occurences of senior_manager_code per company_code (Because GROUP BY company_code)
-- This is the backbone of the solution
SELECT
	c.company_code,
    c.founder,
    COUNT(DISTINCT sm.senior_manager_code)
FROM
	company c
    LEFT JOIN senior_manager sm USING(company_code)
GROUP BY c.company_code
ORDER BY
	c.company_code,
    c.founder;