import json
import os
import boto3
import pymysql
import csv

# S3 configuration
S3_BUCKET = 'challengedataglobant'
S3_KEY = 'hired_employees.csv'  
s3_client = boto3.client('s3')

# MySQL configuration
RDS_HOST = 'dbchallengeglobant.c5a6q4eg4u7u.us-east-2.rds.amazonaws.com'
RDS_USER = 'admin'
RDS_PASSWORD = 'ChallengeGl0b4nt'
RDS_DB = 'db-Challenge'


def lambda_handler(event, context):

    # connection to RDS MySQL
    conn = pymysql.connect(
        host = RDS_HOST,
        user = RDS_USER,
        password = RDS_PASSWORD,    
        #database = RDS_DB,
        port=3306
    )
    # Get CSV file from S3
    csv_file = s3_client.get_object(Bucket=S3_BUCKET, Key=S3_KEY)
    csv_content = csv_file['Body'].read().decode('utf-8').splitlines()
    csv_reader = csv.reader(csv_content)
    

    # Insert each row into staging table
    with conn.cursor() as cursor:
        sql = "TRUNCATE TABLE db.stg_hired_employees"
        cursor.execute(sql)
        for row in csv_reader:
            field1, field2, field3, field4 =  row[1], row[2], row[3], row[4]  
            sql = "INSERT INTO db.stg_hired_employees (name, datetime, department_id, job_id)  VALUES ( %s, %s, %s, %s)"
            cursor.execute(sql, (field1, field2, field3, field4))
            
    conn.commit()
        
    return {
            'statusCode': 200,
            'body': json.dumps('works')
        }
    

 