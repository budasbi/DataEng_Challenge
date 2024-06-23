# %%
from config import DATABASE_HOST, DATABASE_NAME, DATABASE_PASS, DATABASE_USER, BUCKET, BACKUPS_FILES
import boto3
import os
import pandas as pd
import psycopg2
import fastavro
from load_data_to_db.copy_to_db import copy_expert



def create_table_backup(table_name):
    
    conn = psycopg2.connect(
    dbname=DATABASE_NAME,
    user=DATABASE_USER,
    password=DATABASE_PASS,
    host=DATABASE_HOST,
    port='5432'
    )

    cur = conn.cursor()
    cur.execute(f"select * from {table_name}")
    records = cur.fetchall()
    cur.close()
    conn.close()
    
    if table_name == 'jobs':
        schema = {
                "type": "record",
                "name": "jobs",
                "fields": [
                    {"name": "id", "type": "int"},
                    {"name": "job", "type": "string"},
                ]
            }
        avro_records = [{"id": r[0], "job": r[1]} for r in records]
    elif table_name == 'departments':
        schema = {
                "type": "record",
                "name": "departments",
                "fields": [
                    {"name": "id", "type": "int"},
                    {"name": "department", "type": "string"},
                ]
            }
        avro_records = [{"id": r[0], "department": r[1]} for r in records]
    elif table_name == 'hired_employees':
        schema = {
                "type": "record",
                "name": "jobs",
                "fields": [
                    {"name": "id", "type": "int"},
                    {"name": "name", "type": "string"},
                    {"name": "datetime", "type": "string"},
                    {"name": "department_id", "type": "int"},
                    {"name": "job_id", "type": "int"}
                ]
            }
        avro_records = [{"id": r[0], "name": r[1], "datetime": r[2], "department_id": r[3], "job_id": r[4]} for r in records]
    else:
        pass
    
    backup_path_file = os.path.join(BACKUPS_FILES,f'{table_name}.avro')
    
    #Write file
    with open(backup_path_file, 'wb') as out:
        fastavro.writer(out, schema, avro_records)
        
    s3Client = boto3.client('s3')    
    #upload_file
    with open(backup_path_file, 'rb') as fileObj:
        response = s3Client.upload_fileobj(fileObj, BUCKET, f'backups/{table_name}.avro')
        print(response)
    


def get_backups(table_name):
    """Downloads jobs, departments, hired_employees backups files from s3
    """
    os.environ['AWS_DEFAULT_REGION']='us-east-1'
    s3_client = boto3.client('s3')
    s3_client.download_file('data-challenge-bucket-oscar',f'backups/{table_name}.avro',os.path.join(BACKUPS_FILES,f'{table_name}.avro'))
    
def restore_backup(table_name):
    get_backups(table_name)
    backup_path_file = os.path.join(BACKUPS_FILES,f'{table_name}.avro')
    with open(backup_path_file, 'rb') as file:
        reader = fastavro.reader(file)
        records = [record for record in reader]
    table_data = pd.DataFrame.from_records(records)
    copy_expert(df=table_data, table=table_name)
    
    


# %%
def backup_all_tables():
    table_list = ['jobs', 'departments','hired_employees']
    for table in table_list:
        create_table_backup(table)


# %%
def restore_all_tables():
    table_list = ['jobs', 'departments','hired_employees']
    for table in table_list:
        restore_backup(table)







