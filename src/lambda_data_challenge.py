import boto3
import psycopg2
import json
from load_data_to_db.copy_to_db import load_all_tables_data
from backup_manager.backup_manager import backup_all_tables, restore_all_tables
import logging
logger = logging.getLogger('log')
logger.setLevel(level=logging.INFO)


def lambda_handler(event, context):
    print(event)
    print(event['resource'])
    print(event['httpMethod'])
    path = event['resource']
    http_method = event['httpMethod']
    try:
        if http_method == 'PUT':
            if path == '/load_data':
                logger.info('Executing load_all_tables_data')
                load_all_tables_data()
                response_message = 'Data Loaded! Check db'
            elif path == '/create_backup':
                logger.info('Executing backup_all_tables')
                backup_all_tables()
                response_message = 'Backup Done'
            elif path == '/restore_backup':
                logger.info('Executing restore_all_tables')
                restore_all_tables()
                response_message = 'Backup Restored'
            else:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"error": "Resource not found"})
                }
                
            return { "statusCode": 200, "body": json.dumps({"message": response_message}) }
        
        elif http_method == 'POST':
            body = event["body"]
            if path == '/jobs':
                response_message = 'Data Loaded into jobs table!'
            elif path == '/departments':
                response_message = 'Data Loaded jobs departments!'
            elif path == '/hired_employees':
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
            