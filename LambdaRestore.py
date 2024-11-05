import json
import pymysql
import fastavro
import csv
import boto3
import os
from datetime import datetime
from io import BytesIO, StringIO


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
        table_db = substring = backup_api.split("20")[0]
        print(table_db)
        stg_table = 'stg.stg_' + table_db
        
        # Download avro file from S3
        s3_client = boto3.client('s3')
        avro_obj = s3_client.get_object(Bucket=S3_BUCKET, Key=avro_file_key)
        avro_data = BytesIO(avro_obj['Body'].read())
        
        reader = fastavro.reader(avro_data)
  
        # Funtion avro to csv
        csv_data = avro_to_csv(reader)

        # Read CSV and load into MySQL
        with conn.cursor() as cursor:
            sql = f"TRUNCATE TABLE {stg_table}"
            print(sql)
            cursor.execute(sql)

            csv_reader = csv.reader(csv_data.getvalue().splitlines())
            first_row = next(csv_reader) # Without headers, it read the firts row to count the columns
            placeholders = ','.join(["'%s'"] * len(first_row))
            print(placeholders)
            insert_query = f"INSERT INTO {stg_table} VALUES({placeholders})"
            print('query:')
           

            for row in csv_reader:
                print(insert_query % tuple(row)) 
                query = insert_query % tuple(row)
                print(query)
                cursor.execute(query)
            
            # execute usp_restore
            cursor.callproc('db.usp_restore', (table_db,))
            conn.commit()

    finally:
        conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps(f'Backup table db.{table_db} sucessfully!')
    }
    
############################################################################################
def avro_to_csv(reader):
     # Crear un flujo de texto para almacenar los datos CSV
    csv_output = StringIO()
    writer = None
    
    # Leer el archivo Avro y escribir en CSV
    #reader = fastavro.reader(avro_data)
    for record in reader:
        # Escribir encabezados en el archivo CSV la primera vez
        if writer is None:
            writer = csv.DictWriter(csv_output, fieldnames=record.keys())
            #writer.writeheader()
        
        # Escribir cada registro en el CSV
        writer.writerow(record)
    
    # Regresar los datos CSV como un flujo
    csv_output.seek(0)
    return csv_output



    """
    #avro_byte = avro_data.encode('utf-8')
    avro_file = BytesIO(avro_byte)
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
    """

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