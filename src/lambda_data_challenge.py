import boto3
import psycopg2
import json
from load_data_to_db.copy_to_db import load_all_tables_data

def get_database_variables_ssm(var, encrypt):
    pass

def connect_to_rds():
    pass

def create_backups_avro():
    pass

def restore_backups_avro():
    pass

def bulk_load_files_to_db():
    pass


def lambda_handler(event, context):
    path = event['resource']
    http_method = event['httpMethod']
    try:
        if http_method == 'PUT':
            if path == '/data_challenge/load_data':
                load_all_tables_data()
                response_message = 'Data Loaded! Check db'
            elif path == '/data_challenge/create_backup':
                response_message = 'Data Loaded! Check db'
            elif path == '/data_challenge/restore_backup':
                response_message = 'Data Loaded! Check db'
            else:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"error": "Resource not found"})
                }
                
            return { "statusCode": 200, "body": json.dumps({"message": response_message}) }
        
        elif http_method == 'POST':
            body = event["body"]
            if path == '/data_challenge/jobs':
                response_message = 'Data Loaded into jobs table!'
            elif path == '/data_challenge/departments':
                response_message = 'Data Loaded jobs departments!'
            elif path == '/data_challenge/hired_employees':
                response_message = 'Data Loaded jobs hired_employees!'
            else:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"error": "Resource not found"})
                }
                
            return { "statusCode": 201, "body": json.dumps({"message": response_message, "payload": body}) }
                
    except Exception as e:
        return {"statusCode": 500, 
                "body": json.dumps({"error": str(e)})}
            
