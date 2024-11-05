CREATE DEFINER=`admin`@`%` PROCEDURE `usp_load_departments`()
BEGIN
	DECLARE exists_data INT;
	SELECT COUNT(*) INTO exists_data FROM stg.stg_departments AS stg WHERE NOT EXISTS (SELECT department FROM db.departments AS db WHERE db.department = stg.department);
	
	IF exists_data > 0 THEN
		-- Create temporal table TMPlog_errors
        DROP TABLE IF EXISTS TMPlog_errors;
		CREATE TEMPORARY  TABLE TMPlog_errors (
			id_to_delete int DEFAULT NULL,
			table_error char(20) DEFAULT NULL,
			column_error char(20) DEFAULT NULL,
			desc_error char(100) DEFAULT NULL,
			datetime char(20) DEFAULT NULL
		);
        
		# Load into TMPlog_errors
		INSERT INTO TMPlog_errors (id_to_delete, table_error, column_error, desc_error,datetime)
		SELECT  stg.id,
			CONVERT('stg_departments', CHAR(20)), 
			CONVERT('department', CHAR(20)),
			CONVERT(CONCAT(stg.department,' - department name already exist'), CHAR(100)),
			CONVERT(DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s'), CHAR(20))
		FROM stg.stg_departments AS stg
		WHERE EXISTS (SELECT db.department FROM db.departments AS db WHERE db.department = stg.department);
	 
     
        -- select * from stg.stg_departments
		-- Delete that don't accomplish the rules
		DELETE stg
		FROM stg.stg_departments AS stg
		JOIN TMPlog_errors AS tmp ON stg.id = tmp.id_to_delete;

		-- Insert data issues
		INSERT INTO db.log_errors (table_error, column_error, desc_error, datetime)
		SELECT table_error, column_error, desc_error,datetime
		FROM TMPlog_errors;
		
		-- Insert into final table
		INSERT INTO db.departments (department)
		SELECT stg.department
		FROM stg.stg_departments AS stg
        WHERE stg.department NOT IN (SELECT db.department FROM db.departments AS db);

		DROP TABLE IF EXISTS TMPlog_errors;
        
	END IF;
    
END