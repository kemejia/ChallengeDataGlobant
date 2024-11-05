CREATE DEFINER=`admin`@`%` PROCEDURE `usp_load_employees`()
BEGIN
    DECLARE exists_data INT;
	SELECT COUNT(*) INTO exists_data FROM stg.stg_hired_employees AS stg WHERE NOT EXISTS (SELECT db.name FROM db.hired_employees AS db WHERE db.name = stg.name);
	select 'afuera' as info;
    IF exists_data > 0 THEN
		select 'dentro' as info;
		DROP TABLE IF EXISTS TMPlog_errors;
		-- Create temporal table TMPlog_errors
		CREATE TEMPORARY  TABLE TMPlog_errors (
			id_to_delete int DEFAULT NULL,
			table_error char(20) DEFAULT NULL,
			column_error char(20) DEFAULT NULL,
			desc_error char(45) DEFAULT NULL,
			datetime char(20) DEFAULT NULL
		);

		# Load into TMPlog_errors
		INSERT INTO TMPlog_errors (id_to_delete, table_error, column_error, desc_error,datetime)
		SELECT id,
			CONVERT('stg_hired_employees', CHAR(20)), 
			CONVERT('name', CHAR(20)),
			CONVERT('name empty', CHAR(100)),
			CONVERT(DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s'), CHAR(20))
		FROM stg.stg_hired_employees
		WHERE name =''
		UNION ALL 
        SELECT id,
			CONVERT('stg_hired_employees', CHAR(20)), 
			CONVERT('name', CHAR(20)),
			CONVERT(CONCAT(stg.name,' - name already exist'), CHAR(100)),
			CONVERT(DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s'), CHAR(20))
		FROM stg.stg_hired_employees AS stg
		WHERE EXISTS (SELECT db.name FROM db.hired_employees AS db WHERE db.name = stg.name)
			AND stg.name != ''
		UNION ALL 
		-- INSERT INTO TMPlog_errors (table_error, column_error, desc_error,datetime)
		SELECT id,
			CONVERT('stg_hired_employees', CHAR(20)),
			CONVERT('department_id', CHAR(20)),
			CONVERT('department_id empty', CHAR(100)),
			DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
		FROM stg.stg_hired_employees
		WHERE department_id =''
		UNION ALL 
		SELECT id,
			CONVERT('stg_hired_employees', CHAR(20)),
			CONVERT('job_id', CHAR(20)),
			CONVERT('job_id empty', CHAR(100)),
			DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
		FROM stg.stg_hired_employees
		WHERE job_id =''
		UNION ALL 
		SELECT id,
			CONVERT('stg_hired_employees', CHAR(20)), 
			CONVERT('datetime', CHAR(20)),
			CONVERT('datetime empty', CHAR(100)),
			DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
		FROM stg.stg_hired_employees
		WHERE datetime = ''
		UNION ALL 
		SELECT id,
			CONVERT('stg_hired_employees', CHAR(20)), 
			CONVERT('datetime', CHAR(20)),
			CONVERT(CONCAT('Invalid datetime ISO format',datetime), CHAR(100)),
			DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')  
		FROM stg.stg_hired_employees AS stg
		WHERE stg.datetime != DATE_FORMAT(STR_TO_DATE(REPLACE(REPLACE(stg.datetime, 'T', ' '), 'Z', ''), '%Y-%m-%d %H:%i:%s'), '%Y-%m-%dT%H:%i:%sZ');
		
		-- Delete that don't accomplish the rules
		DELETE stg
		FROM stg.stg_hired_employees AS stg
		JOIN TMPlog_errors AS tmp ON stg.id = tmp.id_to_delete;

		-- Insert data issues
		INSERT INTO db.log_errors (table_error, column_error, desc_error, datetime)
		SELECT table_error, column_error, desc_error,datetime
		FROM TMPlog_errors;
		
		-- Insert into final table
		INSERT INTO db.hired_employees (name, datetime, department_id, job_id)
		SELECT name,
			datetime,
			department_id,
			job_id
		FROM stg.stg_hired_employees AS stg
		WHERE stg.name NOT IN (SELECT name FROM db.hired_employees AS db)
			AND stg.department_id IN (SELECT department_id FROM db.hired_employees AS db) 
			AND stg.job_id IN (SELECT job_id FROM db.hired_employees AS db) ;

		DROP TABLE IF EXISTS TMPlog_errors;
        
    END IF;
END