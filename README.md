# ChallengeDataGlobant
This project is a **ChallengeDataGlobant** 

## Project Overview

1. **Historical Data Migration**:
   - Import historical data from CSV files into a SQL database, and create queries and dashboards to visualize and analyze this information.

2. **API Endpoints**:

## Rutas de la API

| Método | Ruta          | Descripción                               | Parámetros         | Respuesta        | Códigos de estado |
|--------|---------------|-------------------------------------------|-------------------|-------------------|-------------------|
| GET    | /usuarios     | Obtiene una lista de todos los usuarios.    |                   | Lista de usuarios | 200               |
| POST   | /usuarios     | Crea un nuevo usuario.                    | {nombre, email}   | Nuevo usuario    | 201               |
| PUT    | /usuarios/{id} | Actualiza un usuario existente.            | {id, nombre, email} | Usuario actualizado | 200               |

This API exposes three POST endpoints to interact with the database:

#### a. Load Data into a Table
* **Endpoint:** https://ehu8doasql.execute-api.us-east-2.amazonaws.com/loadbd
* **Request Body:**
  ```json
  { "table": "hired_employees" }


  
   - The file to be loaded must be placed in the following S3 source: **s3://challengedataglobant/**.
   - For load purposes, please include the singular form of the table name (without the final "s") in the body of the POST request, formatted as follows: { "table": "hired_employee" }
   - Support batch insertion (1 to 1000 rows) in a single request.

3. **Backup and Restore in AVRO**:
   - For backup purposes, please include the exact table name in the body of the POST request, formatted as follows: { "table": "hired_employees" }
   - The Avro files for backup must be created with the following naming structure: tablenameYYYY-MM-DD_HH-mm.avro (jobs2024-11-05_03-14.avro). These files will be located in the following path: https://challengedataglobant.s3.us-east-2.amazonaws.com/backup/
   - For restoration purposes, please include the name of the file you wish to restore, excluding the file extension in the body of the POST request, formatted as follows: { "backup": "departments2024-11-05_03-14" }
     
4.  **Security**:
   - IP Configuration
   Configuring allowed IP addresses is essential for controlling access to our resources and minimizing unauthorized access. Please provide your IP address to enable access. 
   - AWS Secrets Manager
   We use AWS Secrets Manager to manage database credentials securely. It encrypts sensitive data and automatically rotates passwords, enhancing our security by ensuring that credentials are always up-to-date.

5. 

# Dashboard

<img width="560" alt="CaptureDashboardHiring" src="https://github.com/user-attachments/assets/90340b18-742d-4dda-b7c1-2c301ab62019">

## Technical Requirements
- **Origin CSV**: AWS S3
- **Language**: Python
- **API**: AWS API Getaway
- **Database**: AWS RDS - MySQL
- **Backup Format**: AVRO
 - **Backup location**: AWS S3
 - **Visualization Tool**: Power BI

   
## Setup Instructions

 Clone the repository:
   ```bash
   git clone https://github.com/username/data-challenge.git


