import json
import pymysql
import fastavro
import csv
import boto3
from datetime import datetime
from io import BytesIO


S3_BUCKET = 'challengedataglobant'
SECRET_NAME = "mysql/credentials"  

def lambda_handler(event, context):

     # MySQL configuration with AWS Secrets
    db_credentials = get_db_credentials(SECRET_NAME)
    conn = pymysql.connect(
        host=db_credentials["host"],
        user=db_credentials["user"],
        password=db_credentials["password"],
        port=3306
    )

    try:
        event_string = json.dumps(event, indent=2)
        body = json.loads(event_string)
        backup_api = body.get('backup') 
        avro_file_key = f"backup/{backup_api}.avro"
        table_delete = substring = backup_api.split("20")[0]
        print("table_delete: ")
        print(table_delete)

        # Download avro file from S3
        s3_client = boto3.client('s3')
        avro_obj = s3_client.get_object(Bucket=S3_BUCKET, Key=avro_file_key)
        avro_data = avro_obj['Body'].read()
        #avro_byte = avro_data.encode('utf-8')
        
        csv_file = avro_to_csv(avro_data)

        # Leer el CSV en memoria y cargar en MySQL
        with conn.cursor() as cursor:
  
            sql = f"TRUNCATE TABLE stg.stg_{table_delete}s"
            cursor.execute(sql)

            csv_reader = csv.reader(csv_file.getvalue().decode().splitlines())
            headers = next(csv_reader)  
            insert_query = f"INSERT INTO {os.environ['DB_TABLE']} ({','.join(headers)}) VALUES ({','.join(['%s'] * len(headers))})"
            
            for row in csv_reader:
                cursor.execute(insert_query, row)
                
            conn.commit()

    finally:
        conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps(f'Backup table {table_delete} sucessfully!')
    }
    
############################################################################################
def avro_to_csv(avro_data):
    avro_file = BytesIO(avro_data)
    reader = fastavro.reader(avro_file)
    
    csv_file = BytesIO()
    writer = csv.writer(csv_file)
    
    # Columns
    headers = [field['name'] for field in reader.schema['fields']]
    
    writer.writerow(headers)
    
    # Rows
    for record in reader:
        writer.writerow(record.values())
    
    csv_file.seek(0)
    return csv_file

############################################################################################
def get_db_credentials(secret_name):
    client = boto3.client("secretsmanager")
    
    # Recover the secret
    response = client.get_secret_value(SecretId=secret_name)
    
    # Parse the secret JSON
    secret = json.loads(response["SecretString"])
    return {
        "host": secret["host"],
        "user": secret["username"],
        "password": secret["password"],
        "database": secret["dbname"]
    }