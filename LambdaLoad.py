import json
import os
import boto3
import pymysql
import csv

# S3 configuration
S3_BUCKET = 'challengedataglobant'
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
        port=3306
    )
    
    try:
        event_string = json.dumps(event, indent=2)
        body = json.loads(event_string)
        table_api = body.get('table', 'department') # By default is department table
        S3_KEY = table_api + 's.csv'  

        # Get CSV file from S3
        csv_file = s3_client.get_object(Bucket=S3_BUCKET, Key=S3_KEY)
        csv_content = csv_file['Body'].read().decode('utf-8').splitlines()
        csv_reader = csv.reader(csv_content)

        # Request 2.2
        validate_csv(csv_content)

        # Insert data into staging base on the specified table
        if table_api == 'hired_employees':
            # Insert each row into staging table
            with conn.cursor() as cursor:
                sql = "TRUNCATE TABLE stg.stg_hired_employees"
                cursor.execute(sql)

                for row in csv_reader:
                    field1, field2, field3, field4 =  row[1], row[2], row[3], row[4]  
                    sql = "INSERT INTO stg.stg_hired_employees (name, datetime, department_id, job_id)  VALUES ( %s, %s, %s, %s)"
                    cursor.execute(sql, (field1, field2, field3, field4))
                
                sql = "CALL usp_load_employees;"
                cursor.execute(sql)

        else:
            # Insert each row into staging table
            with conn.cursor() as cursor:
                sql = f"TRUNCATE TABLE stg.stg_{table_api}s"
                cursor.execute(sql)

                for row in csv_reader:
                    field =  row[1]
                    sql = f"INSERT INTO stg.stg_{table_api}s({table_api}) VALUES ('{field}')"
                    print(sql)
                    cursor.execute(sql)
                
                sql = f"CALL db.usp_load_{table_api}s;"
                print(sql)
                cursor.execute(sql)
        
        conn.commit()

    except Exception as e:
        print("Error:", e)
        raise
    finally:
        conn.close()
        
    return {
            #'statusCode': 200,
            #'body': json.dumps('works')
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Información de la solicitud recibida',
                'event': event  # Retornamos el event completo
            })
        }
    
############################################################################################
def validate_csv(csv_content):
    # Check that the CSV file is not empty and does not exceed 1,000 rows.
    if len(csv_content) == 0:
        raise ValueError("'Error: The CSV file is empty.")
    if len(csv_content) > 1000:
        raise ValueError("Error: The CSV file has more than 1000 rows.")


 