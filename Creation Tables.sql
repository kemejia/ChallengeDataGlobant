---------------------------------------------------------------------------------------
-- Creation tables stg
---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS stg.`stg_hired_employees`;
CREATE TABLE stg.`stg_hired_employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` char(45) DEFAULT NULL,
  `datetime` char(45) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS stg.`stg_departments`;
CREATE TABLE stg.`stg_departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department` char(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS stg.`stg_jobs`;
CREATE TABLE stg.`stg_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job` char(45) DEFAULT NULL,
  PRIMARY KEY (`id`)  
) ENGINE=InnoDB AUTO_INCREMENT=0  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

---------------------------------------------------------------------------------------
-- Creation tables db
---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS db.`departments`;
CREATE TABLE db.`departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department` char(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS db.`jobs`;
CREATE TABLE db.`jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job` char(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS db.`hired_employees`;
CREATE TABLE db.`hired_employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` char(45) DEFAULT NULL,
  `datetime` char(45) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS db.`log_errors`;
CREATE TABLE `log_errors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `table_error` char(20) DEFAULT NULL,
  `column_error` char(20) DEFAULT NULL,
  `desc_error` char(45) DEFAULT NULL,
  `datetime` char(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
