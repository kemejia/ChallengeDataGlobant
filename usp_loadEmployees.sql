USE `db`;
DROP procedure IF EXISTS `usp_loadEmployees`;

DELIMITER $$
USE `db`$$
CREATE PROCEDURE usp_loadEmployees ()
BEGIN

	-- Create temporal table TMPlog_errors
    CREATE TABLE TMPlog_errors (
		id_to_delete int DEFAULT NULL,
		table_error varchar(20) DEFAULT NULL,
		column_error varchar(20) DEFAULT NULL,
		desc_error varchar(45) DEFAULT NULL,
		datetime varchar(20) DEFAULT NULL
	);

	# Load into TMPlog_errors
	INSERT INTO TMPlog_errors (table_error, column_error, desc_error,datetime)
	SELECT id
		'stg_hired_employees', 
		'name',
		'name empty',
        DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
	FROM db.stg_hired_employees
    WHERE name =''
    UNION ALL 
    -- INSERT INTO TMPlog_errors (table_error, column_error, desc_error,datetime)
	SELECT id
		'stg_hired_employees', 
		'department_id',
		'department_id empty',
		DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
	FROM db.stg_hired_employees
    WHERE department_id =''
    UNION ALL 
	SELECT id
		'stg_hired_employees', 
		'job_id',
		'job_id empty',
		DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
	FROM db.stg_hired_employees
    WHERE job_id =''
    UNION ALL 
	SELECT id
		'stg_hired_employees', 
		'datetime',
		'datetime empty',
		DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
	FROM db.stg_hired_employees
    WHERE datetime = ''
    UNION ALL 
    SELECT id
		'stg_hired_employees', 
		'datetime',
		'datetime ISO format',
		DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s') 
	FROM db.stg_hired_employees
    WHERE DATE_FORMAT(datetime, '%Y-%m-%dT%H:%i:%s') != datetime;
    
    -- Delete that don't accomplish the rules
    DELETE stg
	FROM db.stg_hired_employees AS stg
	JOIN TMPlog_errors AS tmp ON stg.id = tmp.id;

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
	FROM db.stg_hired_employees;

    
    
END$$

DELIMITER ;

