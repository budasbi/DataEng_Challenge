# %%
import os
import dotenv
dotenv.load_dotenv()
import pandas as pd
from config import DATA_FILES, DATABASE_HOST, DATABASE_NAME, DATABASE_PASS, DATABASE_USER
import psycopg2
import boto3
import io
import traceback
from sqlalchemy import create_engine
import logging
logger = logging.getLogger('log')
import botocore
from load_data_to_db.copy_to_db import load_to_logs

# %%


# %%
engine = create_engine(f'postgresql+psycopg2://{DATABASE_USER}:{DATABASE_PASS}@{DATABASE_HOST}/{DATABASE_NAME}')

# %%
def add_new_records_db(df:pd.DataFrame, table:str,fields:str=''):
    """will store dataframe's data into a database table 
    
    Args:
        df (pd.DataFrame): dataframe to persist
        table (str): destination table

    Returns:
        integer: 1 if a exception is raised
    """
    # save dataframe to an in memory buffer
    conn = psycopg2.connect(host=DATABASE_HOST, database=DATABASE_NAME, user=DATABASE_USER, password=DATABASE_PASS)
    df = df.reset_index(drop=True)
    cur = conn.cursor()
    buffer = io.StringIO()
    df.to_csv(buffer, index = False,header=False, sep='|')
    buffer.seek(0)
    cur.execute(f'SET search_path TO public')
    try:
        copy_sql = f"""
                COPY {table} {fields} FROM stdin WITH CSV HEADER
                DELIMITER as '|'
                """
        cur.copy_expert(sql=copy_sql, file=io.StringIO(df.to_csv(index=False, header=True, sep='|')))
        conn.commit()
        cur.close()
    except Exception:
        conn.rollback()
        cur.close()
        print(traceback.format_exc())
        return 1
    
    
def add_new_jobs(jobs_df):
    
    table_name = 'jobs'
    job_columns = ['id', 'job']
    jobs_df.columns = job_columns
    jobs_df['id'] = jobs_df['id'].astype(int)
    jobs_df['job'] = jobs_df['job'].astype(str)
    
    #Avoid Duplicates    
    loaded_jobs = pd.read_sql("select distinct id as job_id_db from jobs",con=engine)
    joined = pd.merge(jobs_df, loaded_jobs, how='left', left_on='id', right_on='job_id_db')
    joined['job_id_db'] = joined['job_id_db'].fillna(-99) #New Jobs
    
    jobs_data_to_db = joined.loc[(joined['job'].notnull())&(joined['id'].notnull()&(joined['job_id_db']==-99)),:]
    jobs_data_to_logs = joined.loc[(joined['job'].isnull())|(joined['id'].isnull()|(joined['job_id_db']!=-99)),:]
    del jobs_data_to_db['job_id_db']
    add_new_records_db(df=jobs_data_to_db, table=table_name)
    load_to_logs(jobs_data_to_logs,table_name)
    
    
def add_new_departments(departments_df):
    table_name = 'departments'
    departments_columns = ['id', 'department']
    departments_df.columns = departments_columns
    departments_df['id'] = departments_df['id'].astype(int)
    departments_df['department'] = departments_df['department'].astype(str)
    #Avoid Duplicates
    loaded_departments = pd.read_sql("select distinct id as dep_id_db from departments",con=engine)
    joined_dep = pd.merge(departments_df,loaded_departments, how='left', left_on='department_id', right_on='dep_id_db' )
    joined_dep['dep_id_db'] = joined_dep['dep_id_db'].fillna(-99)
    ###Apply All fields required rule
    departments_data_to_db = joined_dep.loc[(joined_dep['department'].notnull())&(joined_dep['id'].notnull()&(joined_dep['dep_id_db']==-99)),:]
    departments_data_to_logs = joined_dep.loc[(joined_dep['department'].isnull())|(joined_dep['id'].isnull()|(joined_dep['dep_id_db']!=-99)),:]
    del departments_data_to_db['dep_id_db']
    add_new_records_db(df=departments_data_to_db, table=table_name)
    load_to_logs(departments_data_to_logs,table_name)
    
def add_new_hired(hired_df):
    table_name = 'hired_employees'
    loaded_departments = pd.read_sql("select distinct id as dep_id_db from departments",con=engine)
    loaded_jobs = pd.read_sql("select distinct id as job_id_db from jobs",con=engine)

    #Format Hired_employees
    hired_employees_columns = ['id', 'name', 'datetime', 'department_id', 'job_id']
    hired_df.columns = hired_employees_columns
    ##Replace broken relations
    hired_df['id'] = hired_df['id'].fillna(-99)
    hired_df['department_id'] = hired_df['department_id'].fillna(-99)
    hired_df['job_id'] = hired_df['job_id'].fillna(-99)
    hired_df['id'] = hired_df['id'].astype(int)
    hired_df['name'] = hired_df['name'].astype(str)
    hired_df['datetime'] = hired_df['datetime'].astype(str)
    hired_df['department_id'] = hired_df['department_id'].astype(int)
    hired_df['job_id'] = hired_df['job_id'].astype(int)

    hired_df = pd.merge(hired_df, loaded_jobs, how='left', left_on='job_id', right_on='job_id_db')
    hired_df = pd.merge(hired_df, loaded_departments, how='left', left_on='department_id', right_on='dep_id_db')
    hired_df['dep_id_db'] = hired_df['dep_id_db'].fillna(-99)
    hired_df['job_id_db'] = hired_df['job_id_db'].fillna(-99)
    ###Apply All fields required rule
    #Avoid duplicates 
    loaded_hired = pd.read_sql("select distinct id as hd_id_db from hired_employees",con=engine)
    hired_employees_data_to_logs = pd.merge(hired_df, loaded_hired,how='left', left_on='id', right_on='hd_id_db' )
    hired_employees_data_to_logs['hd_id_db'] = hired_employees_data_to_logs['hd_id_db'].fillna(-99)
    hired_employees_data_to_db = hired_df.loc[(hired_df['id']!=-99)&(hired_df['name']!='')&(hired_df['datetime']!='')&(hired_df['job_id']!=-99)&(hired_df['department_id']!=-99)&(hired_df['job_id_db']!=-99)&(hired_df['dep_id_db']!=-99)&(hired_df['hd_id_db']==-99), :]
    hired_employees_data_to_logs = hired_df.loc[(hired_df['id']==-99)|(hired_df['name']=='')|(hired_df['datetime']=='')|(hired_df['job_id']==-99)|(hired_df['department_id']==-99)|(hired_df['job_id_db']==-99)|(hired_df['dep_id_db']==-99)|(hired_df['hd_id_db']!=-99), :]
    del hired_employees_data_to_db['dep_id_db']
    del hired_employees_data_to_db['job_id_db']
    del hired_employees_data_to_db['hd_id_db']
    add_new_records_db(df=hired_employees_data_to_db, table=table_name)
    load_to_logs(hired_employees_data_to_logs,table_name)