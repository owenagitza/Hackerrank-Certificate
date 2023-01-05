-- SOLUTION
SELECT
	c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code),
    COUNT(DISTINCT sm.senior_manager_code),
    COUNT(DISTINCT m.manager_code),
    COUNT(DISTINCT e.employee_code)
FROM
	Company c 
    LEFT JOIN Lead_manager lm USING(company_code)
	LEFT JOIN Senior_manager sm USING(company_code)
	LEFT JOIN Manager m USING(company_code)
	LEFT JOIN Employee e USING(company_code)
GROUP BY c.company_code
ORDER BY 
	c.company_code,
    c.founder;

-- SUBMITTED SOLUTION
-- For some reason Hackerrank MySQL requires GROUP BY company_code and founder, otherwise it spits out error
-- But, the output is EXACTLY the same between this solution and the above (Checked with a program)
SELECT
	c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code),
    COUNT(DISTINCT sm.senior_manager_code),
    COUNT(DISTINCT m.manager_code),
    COUNT(DISTINCT e.employee_code)
FROM
	company c 
    LEFT JOIN lead_manager lm USING(company_code)
	LEFT JOIN senior_manager sm USING(company_code)
	LEFT JOIN manager m USING(company_code)
	LEFT JOIN employee e USING(company_code)
GROUP BY
	c.company_code,
    c.founder
ORDER BY 
	c.company_code,
    c.founder;

-- Without DISTINCT
SELECT
	c.company_code,
    c.founder,
    COUNT(m.lead_manager_code),
    COUNT(sm.senior_manager_code),
    COUNT(m.manager_code),
    COUNT(e.employee_code)
FROM
	company c 
    LEFT JOIN lead_manager lm USING(company_code)
	LEFT JOIN senior_manager sm USING(company_code)
	LEFT JOIN manager m USING(company_code)
	LEFT JOIN employee e USING(company_code)
GROUP BY
	c.company_code
ORDER BY 
	c.company_code,
    c.founder;

-- TRIAL
SELECT DISTINCT
	c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code),
	COUNT(DISTINCT sm.senior_manager_code),
    COUNT(DISTINCT m.manager_code),
    COUNT(DISTINCT e.employee_code)
FROM 
	company c
    LEFT JOIN lead_manager lm USING(company_code)
    LEFT JOIN senior_manager sm USING(company_code)
    LEFT JOIN manager m USING(company_code)
    LEFT JOIN employee e USING(company_code)
GROUP BY
	1
ORDER BY
	1,
    2