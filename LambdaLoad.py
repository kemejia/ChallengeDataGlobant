import json
import os
import boto3
import pymysql
import csv

# S3 configuration
S3_BUCKET = 'challengedataglobant'
S3_KEY = 'hired_employees.csv'  
s3_client = boto3.client('s3')

# MSSQL configuration
RDS_HOST = 'db-msql-challenge.c5a6q4eg4u7u.us-east-2.rds.amazonaws.com'
RDS_USER = 'admin'
RDS_PASSWORD = 'ChallengeGl0b4nt'
RDS_DB = 'ChallengeGlobant'

def lambda_handler(event, context):

    # Conectar a SQL Server en RDS
    conn = pymysql.connect(
        server=os.getenv(RDS_HOST),
        user=os.getenv(RDS_USER),
        password=os.getenv(RDS_PASSWORD),
        database=os.getenv(RDS_DB)
    )
    # Obtén el archivo CSV desde S3
    csv_file = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
    csv_content = csv_file['Body'].read().decode('utf-8').splitlines()
        
    # Procesa el CSV sin encabezados
    csv_reader = csv.reader(csv_content)
    
    # Insertar cada fila en la base de datos
    with conn.cursor() as cursor:
        for row in csv_reader:
            # Detalla los campos que se insertarán (ajusta según tu tabla y CSV)
            field1, field2, field3, field4 = row[0], row[1], row[2], row[3]  # Ajusta los índices según tus columnas
            
            # Consulta SQL para la inserción (ajusta los nombres de columna)
            sql = "INSERT INTO stg_hired_employees (name, datetime, department_id, job_id)  VALUES (%s, %s, %s, %s)"
            
            # Ejecuta la consulta
            cursor.execute(sql, (field1, field2, field3, field4))
    
    # Confirma la transacción
    conn.commit()
        
    return {
            'statusCode': 200,
            'body': json.dumps('works')
        }
    

 