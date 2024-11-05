import json
import pymysql
import fastavro
import io
import boto3
from datetime import datetime

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
        
        date_str = datetime.now().strftime('%Y-%m-%d_%H-%M') # Date
        event_string = json.dumps(event, indent=2)
        body = json.loads(event_string)
        table_api = body.get('table', 'departments') # By default is department table
        s3_key = f'backup/{table_api}{date_str}.avro' 

        with conn.cursor() as cursor:
            # Get info
            cursor.execute(f"SELECT * FROM db.{table_api}")
            rows = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]

            # Convert data into avro
            records = [dict(zip(columns, row)) for row in rows]
            avro_bytes = convert_to_avro(records, columns, cursor, table_api) 
            
            s3_client = boto3.client('s3')
            s3_client.put_object(Bucket=S3_BUCKET, Key=s3_key, Body=avro_bytes)

            # Check available tables
            cursor.execute(f"""SELECT table_name 
                            FROM information_schema.tables 
                            WHERE table_schema = 'db' and table_type = 'BASE TABLE';""")
            rows = cursor.fetchall()
            tables_available = [item[0] for item in rows]
            check_tables_available(tables_available, table_api)
            
            
    finally:
        conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps(f'Backup sucessfully! Table: {table_api} Path: s3://{S3_BUCKET}/{s3_key}/')
    }
    
############################################################################################
def convert_to_avro(records, columns, cursor, table):
    
    column_types = {}
    table_avro = f"DESCRIBE db.{table}"
    cursor.execute(table_avro)
    for row in cursor.fetchall():
        column_name = row[0]  # Column name
        column_type = row[1]  # Column type
        column_types[column_name] = map_mysql_to_avro(column_type)
    
    # AVRO schema
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

############################################################################################
def check_tables_available(tables_available, table):
    if table not in tables_available:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": f"La tabla '{table}' no existe."})
        }

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