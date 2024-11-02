USE db;
SELECT d.id, d.department, COUNT(e.id) AS hired
FROM db.hired_employees AS e
	INNER JOIN db.departments AS d ON e.department_id = d.id
WHERE  YEAR(e.datetime) = 2021
GROUP BY  d.id, d.department
HAVING COUNT(e.id) > (
	SELECT AVG(hire_count) AS average_hires -- The mean of employees hired in 2021
	FROM (
		SELECT COUNT(1) AS hire_count
		FROM db.hired_employees AS eavg
		WHERE YEAR(eavg.datetime) = 2021
		GROUP BY MONTH(eavg.datetime)
		) AS tbl
	)
ORDER  BY 3 DESC;




