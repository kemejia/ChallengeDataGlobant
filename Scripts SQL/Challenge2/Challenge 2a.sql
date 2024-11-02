USE db;
SELECT d.department, j.job, -- QUARTER(e.datetime) AS quarter, COUNT(1) AS hires
	SUM(CASE WHEN QUARTER(e.datetime) = 1 THEN 1 ELSE 0 END) AS Q1,
    SUM(CASE WHEN QUARTER(e.datetime) = 2 THEN 1 ELSE 0 END) AS Q2,
    SUM(CASE WHEN QUARTER(e.datetime) = 3 THEN 1 ELSE 0 END) AS Q3,
    SUM(CASE WHEN QUARTER(e.datetime) = 4 THEN 1 ELSE 0 END) AS Q4
FROM db.hired_employees AS e
 INNER JOIN db.departments AS d ON e.department_id = d.id
 INNER JOIN db.jobs AS j ON e.job_id = j.id
WHERE YEAR(e.datetime) = 2021
GROUP BY d.department, j.job -- , QUARTER(e.datetime)
ORDER BY d.department, j.job -- , quarter;

