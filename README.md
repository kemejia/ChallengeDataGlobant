# ChallengeDataGlobant
This project is a **ChallengeDataGlobant** 

## Project Overview

1. **Historical Data Migration**:
   - Import historical data from CSV files into a SQL database, and create queries and dashboards to visualize and analyze this information.

2. **API Endpoints**:
   
* **Endpoint:** https://ehu8doasql.execute-api.us-east-2.amazonaws.com/

This API exposes three POST endpoints to interact with the database:

| Method | Route          | Description                               | Parameters         | Rules        | Status Codes |
|--------|---------------|-------------------------------------------|-------------------|-------------------|-------------------|
| POST    | /loadbd     | Load the date into database.     |  {table} eg: { "table": "**hired_employee**" }  | The table name in singular form (without the final "s") | 200, 400 |
| POST   | /backup     | Create a backup in avro format in AWS S3.  | {table} eg: { "table": "**hired_employees**" }  | The table name in the database| 200, 400 |
| POST    | /restore | Restore the table from an Avro backup.          | {table} eg: { "backup": "**hired_employees2024-11-05_20-18**" } | The table name in the database | 200, 400|

3. **Backup and Restore in AVRO**:
   - For backup purposes, please include the exact table name in the body of the POST request, formatted as follows: { "table": "hired_employees" }
   - The Avro files for backup must be created with the following naming structure: tablenameYYYY-MM-DD_HH-mm.avro (jobs2024-11-05_03-14.avro). These files will be located in the following path: https://challengedataglobant.s3.us-east-2.amazonaws.com/backup/
   - For restoration purposes, please include the name of the file you wish to restore, excluding the file extension in the body of the POST request, formatted as follows: { "backup": "departments2024-11-05_03-14" }
     
4.  **Security**:
   - IP Configuration
      Configuring allowed IP addresses is essential for controlling access to our resources and minimizing unauthorized access. Please provide your IP address to enable access. 
   - AWS Secrets Manager
      We use AWS Secrets Manager to manage database credentials securely. It encrypts sensitive data and automatically rotates passwords, enhancing our security by ensuring that credentials are always up-to-date.

# Dashboard

<p align="center">
  <img src="https://github.com/kemejia/ChallengeDataGlobant/blob/main/PowerBI/CaptureDashboardHiring.png?raw=true" alt="Hiring Insights" width="500">
</p>

## Technical Requirements
- **Origin CSV**: AWS S3 source: **s3://challengedataglobant/**.
- **Language**: Python
- **API**: AWS API Getaway
- **Database**: AWS RDS - MySQL
- **Backup Format**: AVRO
- **Backup location**: AWS S3 source: **s3://challengedataglobant/backup**.
- **Visualization Tool**: Power BI
- **Limitaciones:**: Support batch insertion (1 to 1000 rows) in a single request.
   
## Setup Instructions

 Clone the repository:
   ```bash
   git clone https://github.com/username/data-challenge.git


