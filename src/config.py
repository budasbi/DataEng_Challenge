import os
from dotenv import load_dotenv
import logging
from parameter_store.parameter_store import get_parameter
load_dotenv()
PROJECT_ROOT = os.path.dirname(
    os.path.abspath(
        __file__
    )
)
PARENT_DIRECTORY = os.path.abspath(os.path.join(os.getcwd(), os.pardir))

required_paths = ['historical_data', 'backups','sql']
for path in required_paths:
    if not os.path.exists(os.path.join('/tmp',path)):
        os.makedirs(os.path.join('/tmp',path))

DATA_FILES = os.path.join('/tmp','historical_data')
BACKUPS_FILES = os.path.join('/tmp','backups')
SQL_FILES =  os.path.join(PARENT_DIRECTORY,'sql')

# DATABASE_HOST = os.environ['']



# DATABASE_NAME = get_parameter('/data_challenge/db_name',False)
# DATABASE_USER = get_parameter('/data_challenge/db_username',False)
# DATABASE_PASS = get_parameter('/data_challenge/db_pass',True)

DATABASE_NAME = os.environ.get('TF_VAR_DATABASE')
DATABASE_USER = os.environ['TF_VAR_DATABASE_USER']
DATABASE_PASS = os.environ['TF_VAR_DATABASE_PASSWORD']
DATABASE_HOST = 'datachallenge.cwl4757u5g17.us-east-1.rds.amazonaws.com'
BUCKET = 'data-challenge-bucket-oscar'