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
    cursor = conn.cursor()

    #Take the file from S3
    csv_obj = s3_client.get_object(Bucket=S3_BUCKET, Key=S3_KEY)
    body = csv_obj['Body'].read().decode('utf-8')
    
    # Read CSV
    csv_data = csv.reader(StringIO(body))
    rows = [row for row in csv_data]  # Convertir a lista de listas

    with conn.cursor() as cursor:
        csv_reader = csv.reader(csv_data)
        # Indert to Staging
        insert_query = f"INSERT INTO db.stg_hired_employees(name,datetime,department_id,job_id) VALUES ()"

    
    

    return {
            'statusCode': 200,
            'body': json.dumps('works')
        }
    

 