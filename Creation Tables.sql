---------------------------------------------------------------------------------------
-- Creation tables stg
---------------------------------------------------------------------------------------
CREATE TABLE stg.`stg_hired_employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `datetime` varchar(45) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE stg.`departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE stg.`stg_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)  
) ENGINE=InnoDB AUTO_INCREMENT=0  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

---------------------------------------------------------------------------------------
-- Creation tables db
---------------------------------------------------------------------------------------
CREATE TABLE db.`departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE db.`jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE db.`hired_employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `datetime` varchar(45) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4047 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `log_errors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `table_error` varchar(20) DEFAULT NULL,
  `column_error` varchar(20) DEFAULT NULL,
  `desc_error` varchar(45) DEFAULT NULL,
  `datetime` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4096 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
