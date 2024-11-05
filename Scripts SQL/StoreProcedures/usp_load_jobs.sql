CREATE DEFINER=`admin`@`%` PROCEDURE `usp_load_jobs`()
BEGIN
	DECLARE exists_data INT;
	SELECT COUNT(*) INTO exists_data FROM stg.stg_jobs AS stg WHERE NOT EXISTS (SELECT job FROM db.jobs AS db WHERE db.job = stg.job);
	
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
		SELECT stg.id,
			CONVERT('stg_jobs', CHAR(20)), 
			CONVERT('job', CHAR(20)),
			CONVERT(CONCAT(stg.job,' - job name already exist'), CHAR(100)),
			CONVERT(DATE_FORMAT(NOW(), '%Y-%m-%dT%H:%i:%s'), CHAR(20))
		FROM stg.stg_jobs AS stg
		WHERE EXISTS (SELECT job FROM db.jobs AS db WHERE db.job = stg.job);
	 
		-- Delete that don't accomplish the rules
		DELETE stg
		FROM stg.stg_jobs AS stg
		JOIN TMPlog_errors AS tmp ON stg.id = tmp.id_to_delete;

		-- Insert data issues
		INSERT INTO db.log_errors (table_error, column_error, desc_error, datetime)
		SELECT table_error, column_error, desc_error,datetime
		FROM TMPlog_errors;
		
		-- Insert into final table
		INSERT INTO db.jobs(job)
		SELECT job
		FROM stg.stg_jobs AS stg
        WHERE stg.job NOT IN (SELECT job FROM db.jobs AS db) and stg.job IS NOT NULL ;

		DROP TABLE IF EXISTS TMPlog_errors;
        
	END IF;
    
END