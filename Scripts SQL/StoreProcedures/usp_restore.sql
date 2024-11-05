CREATE DEFINER=`admin`@`%` PROCEDURE `usp_restore`(IN table_restore varchar(20))
BEGIN
	
	-- Re-create and load tables 
    IF table_restore = 'departments' THEN
    	DROP TABLE IF EXISTS db.`departments`;
		CREATE TABLE db.`departments` (
		  `id` int NOT NULL AUTO_INCREMENT,
		  `department` char(45) DEFAULT NULL,
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        
        -- Load
        INSERT INTO db.departments (id, department)
		SELECT department
		FROM stg.stg_departments;
        
	ELSEIF table_restore = 'jobs' THEN
    	DROP TABLE IF EXISTS db.`jobs`;
		CREATE TABLE db.`jobs` (
		  `id` int NOT NULL AUTO_INCREMENT,
		  `job` char(45) DEFAULT NULL,
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        
        -- Load
        INSERT INTO db.jobs (id, job)
		SELECT id, job
		FROM stg.stg_jobs;
        
	ELSEIF table_restore = 'hired_employees' THEN
    	DROP TABLE IF EXISTS db.`hired_employees`;
		CREATE TABLE db.`hired_employees` (
		  `id` int NOT NULL AUTO_INCREMENT,
		  `name` char(45) DEFAULT NULL,
		  `datetime` char(45) DEFAULT NULL,
		  `department_id` int DEFAULT NULL,
		  `job_id` int DEFAULT NULL,
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        
		-- Load
        INSERT INTO db.hired_employees (id, name, datetime, department_id, job_id)
		SELECT id, name, datetime, department_id, job_id
		FROM stg.stg_hired_employees AS stg;
        
	END IF;
	
     
END