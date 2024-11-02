import json
import pymysql
import fastavro
import io
import boto3
from datetime import datetime

# S3 configuration
S3_BUCKET = 'challengedataglobant'
s3_client = boto3.client('s3')

# MySQL configuration
RDS_HOST = 'dbchallengeglobant.c5a6q4eg4u7u.us-east-2.rds.amazonaws.com'
RDS_USER = 'admin'
RDS_PASSWORD = 'ChallengeGl0b4nt'
#RDS_DB = 'db-Challenge'


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

        date_str = datetime.now().strftime('%Y-%m-%d')
        body = json.loads(event_string)
        table_api = body.get('table', 'department') # By default is department table
        S3_KEY = f'backup/{table_api}s{date_str}.avro' 

        with conn.cursor() as cursor:
            # Get info
            cursor.execute(f"SELECT * FROM db.{table_api}s")
            rows = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]

            # Convert data into avro
            records = [dict(zip(columns, row)) for row in rows]
            avro_bytes = convert_to_avro(records, columns, cursor, table_api) 
            
            s3_client = boto3.client('s3')
            s3_client.put_object(Bucket=S3_BUCKET, Key=S3_KEY, Body=avro_bytes)
    
    finally:
        conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps('Backup sucessfully!')
    }
    
############################################################################################
def convert_to_avro(records, columns, cursor, table):
    
    column_types = {}
    table_avro = f"DESCRIBE db.{table}s"
    cursor.execute(table_avro)
    for row in cursor.fetchall():
        column_name = row[0]  # nombre de la columna
        column_type = row[1]  # tipo de columna
        column_types[column_name] = map_mysql_to_avro(column_type)
    
    # Crear el esquema AVRO
    schema = {
        'type': 'record',
        'name': 'Record',
        'fields': [{'name': col, 'type': column_types[col]} for col in columns]
    }

    buf = io.BytesIO()
    fastavro.writer(buf, schema, records)
    return buf.getvalue()

############################################################################################
def map_mysql_to_avro(mysql_type):
    if 'int' in mysql_type:
        return 'int'
    elif 'varchar' in mysql_type or 'text' in mysql_type:
        return 'string'
    else:
        return 'string'  # By default