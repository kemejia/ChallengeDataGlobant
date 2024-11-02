#SELECT * FROM db.stg_hired_employees
#where name like '%Elia%';

# INSERT INTO db.log_errors (id, table_error, column_error, desc_error,datetime)
SELECT 'stg_hired_employees', 
		'name',
        'name empty',
		DATE_FORMAT(datetime, '%Y-%m-%dT%H:%i:%s') AS datetime,
		# DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') AS datetime,
		coalesce(department_id, -10) AS department_id,
		coalesce(job_id, -10) AS job_id
FROM db.stg_hired_employees
WHERE department_id =''

TRUNCATE TABLE db.stg_hired_employees

CALL usp_load_employees;

CALL db.usp_load_jobs;

SELECT COUNT(*)  FROM stg.stg_jobs AS stg WHERE NOT EXISTS (SELECT job FROM db.jobs AS db WHERE db.job = stg.job);

select count(1) from db.jobs; -- 183
select count(1) from db.departments; -- 12
select count(1) from db.hired_employees; -- 1000
select count(1) from db.log_errors; -- 1000

select count(1) from stg.stg_jobs; -- 183
select count(1) from stg.stg_departments; -- 12
select count(1) from stg.stg_hired_employees; -- 1000

