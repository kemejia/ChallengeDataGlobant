# ChallengeDataGlobant
This project is a **ChallengeDataGlobant** 

## Project Overview

1. **Historical Data Migration**:
   - Load historical data from CSV files into a SQL DB.

2. **REST API for New Transactions**:
   - Support batch insertion (1 to 1000 rows) in a single request.

3. **Backup and Restore in AVRO**:

## Technical Requirements
- **Origin CSV**: AWS S3
- **Language**: Python
- **Framework**: 
- **Database**: MySQL
- **Backup Format**: AVRO
 - **Backup location**: AWS S3 
## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/username/data-challenge.git

pendientes :#############################3
1. IP para acceso a la base de datos
2. para los backup es necesario poner el nombre exacto de la tabla
3. para la carga de datos es necesario poner el nombre de la tabal en singular: Tabla jobs - se debe enviar job
4. Para almacenar las credenciales en AWS Secrets Manager
5. donde deben ser puestos los archivos de las carga de tablas (Source: s3://challengedataglobant/)
6. dode quedan los archivos de backup (Source: s3://challengedataglobant/backup/)

Dashboard
<img width="560" alt="CaptureDashboardHiring" src="https://github.com/user-attachments/assets/90340b18-742d-4dda-b7c1-2c301ab62019">
