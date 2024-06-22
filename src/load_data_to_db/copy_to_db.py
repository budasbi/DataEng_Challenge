# %%
import os
import dotenv
dotenv.load_dotenv()
import pandas as pd
from config import DATA_FILES, DATABASE_HOST, DATABASE_NAME, DATABASE_PASS, DATABASE_USER
import psycopg2
import io
import traceback
from sqlalchemy import create_engine

# %%
# DATABASE_HOST = os.environ['']
DATABASE_NAME = os.environ.get('TF_VAR_DATABASE')
DATABASE_USER = os.environ['TF_VAR_DATABASE_USER']
DATABASE_PASS = os.environ['TF_VAR_DATABASE_PASSWORD']
DATABASE_HOST = 'datachallenge.cwl4757u5g17.us-east-1.rds.amazonaws.com'

# %%
engine = create_engine(f'postgresql+psycopg2://{DATABASE_USER}:{DATABASE_PASS}@{DATABASE_HOST}/{DATABASE_NAME}')

# %%
def copy_expert(df:pd.DataFrame, table:str,fields:str=''):
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
    cur.execute(f'truncate table {table} cascade')
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

# %%
def load_to_logs(df_to_logs:pd.DataFrame, table_name:str):
    """It will store data from logs file into database

    Args:
        df_to_logs (pd.DataFrame): dataframe with rows that are incomplete
        table_name (str): table name where the payload should be written
    """
    df_to_logs['payload'] = df_to_logs.apply(lambda row: row.to_dict(), axis=1)
    df_to_logs['table_name'] = table_name
    df_to_logs = df_to_logs.loc[:,[ 'table_name', 'payload']]
    copy_expert(df_to_logs,'logs','(table_name, payload)')

# %%
def load_jobs_file():
    """Loads job.xlsx files into database, it creates two dataframes,  The first one are the rows which met the requirements, will be store in jobs tables, 
        the rows who don't will be stored in logs table
    """
    table_name = 'jobs'
    jobs_data = pd.read_excel(os.path.join(DATA_FILES, 'jobs.xlsx'))
    #Format Jobs
    job_columns = ['id', 'job']
    jobs_data.columns = job_columns
    jobs_data['id'] = jobs_data['id'].astype(int)
    jobs_data['job'] = jobs_data['job'].astype(str)
    ###Apply All fields required rule
    jobs_data_to_db = jobs_data.loc[(jobs_data['job'].notnull())&(jobs_data['id'].notnull()),:]
    jobs_data_to_logs = jobs_data.loc[(jobs_data['job'].isnull())|(jobs_data['id'].isnull()),:]
    copy_expert(df=jobs_data_to_db, table=table_name)
    load_to_logs(jobs_data_to_logs,table_name)

# %%
def load_departments_file():
    """Loads departments.xlsx files into database, it creates two dataframes,  The first one are the rows which met the requirements, will be store in departments tables, 
        the rows who don't will be stored in logs table
    """
    table_name = 'departments'
    departments_data = pd.read_excel(os.path.join(DATA_FILES, 'departments.xlsx'))
    #Format Departments
    departments_columns = ['id', 'department']
    departments_data.columns = departments_columns
    departments_data['id'] = departments_data['id'].astype(int)
    departments_data['department'] = departments_data['department'].astype(str)
    ###Apply All fields required rule
    departments_data_to_db = departments_data.loc[(departments_data['department'].notnull())&(departments_data['id'].notnull()),:]
    departments_data_to_logs = departments_data.loc[(departments_data['department'].isnull())|(departments_data['id'].isnull()),:]
    copy_expert(df=departments_data_to_db, table=table_name)
    load_to_logs(departments_data_to_logs,table_name)

# %%

def load_hired_employees():
    """Loads hired_employees.xlsx files into database, it creates two dataframes,  The first one are the rows which met the requirements, will be store in hired_employees tables, 
        the rows who don't will be stored in logs table
    """
    table_name = 'hired_employees'
    hired_employees_data = pd.read_excel(os.path.join(DATA_FILES, 'hired_employees.xlsx'))
    loaded_departments = pd.read_sql("select distinct id as dep_id_db from departments",con=engine)
    loaded_jobs = pd.read_sql("select distinct id as job_id_db from jobs",con=engine)

    #Format Hired_employees
    hired_employees_columns = ['id', 'name', 'datetime', 'department_id', 'job_id']
    hired_employees_data.columns = hired_employees_columns
    ##Replace broken relations
    hired_employees_data['id'] = hired_employees_data['id'].fillna(-99)
    hired_employees_data['department_id'] = hired_employees_data['department_id'].fillna(-99)
    hired_employees_data['job_id'] = hired_employees_data['job_id'].fillna(-99)
    hired_employees_data['id'] = hired_employees_data['id'].astype(int)
    hired_employees_data['name'] = hired_employees_data['name'].astype(str)
    hired_employees_data['datetime'] = hired_employees_data['datetime'].astype(str)
    hired_employees_data['department_id'] = hired_employees_data['department_id'].astype(int)
    hired_employees_data['job_id'] = hired_employees_data['job_id'].astype(int)

    hired_employees_data = pd.merge(hired_employees_data, loaded_jobs, how='left', left_on='job_id', right_on='job_id_db')
    hired_employees_data = pd.merge(hired_employees_data, loaded_departments, how='left', left_on='department_id', right_on='dep_id_db')
    hired_employees_data['dep_id_db'] = hired_employees_data['dep_id_db'].fillna(-99)
    hired_employees_data['job_id_db'] = hired_employees_data['job_id_db'].fillna(-99)
    ###Apply All fields required rule
    hired_employees_data_to_logs = hired_employees_data.loc[(hired_employees_data['id']==-99)|(hired_employees_data['name']=='')|(hired_employees_data['datetime']=='')|(hired_employees_data['job_id']==-99)|(hired_employees_data['department_id']==-99)|(hired_employees_data['job_id_db']==-99)|(hired_employees_data['dep_id_db']==-99), :]
    hired_employees_data_to_db = hired_employees_data.loc[(hired_employees_data['id']!=-99)&(hired_employees_data['name']!='')&(hired_employees_data['datetime']!='')&(hired_employees_data['job_id']!=-99)&(hired_employees_data['department_id']!=-99)&(hired_employees_data['job_id_db']!=-99)&(hired_employees_data['dep_id_db']!=-99), :]
    del hired_employees_data_to_db['dep_id_db']
    del hired_employees_data_to_db['job_id_db']
    copy_expert(df=hired_employees_data_to_db, table=table_name)
    load_to_logs(hired_employees_data_to_logs,table_name)
    
    

# %%
def load_all_tables_data():
    """Loads data by sequence: 1. Jobs, 2. Departments, 3: hired_employees
    """
    load_jobs_file()
    load_departments_file()
    load_hired_employees()

# %%
load_all_tables_data()


