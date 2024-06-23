import os
from dotenv import load_dotenv
import logging
load_dotenv()
PROJECT_ROOT = os.path.dirname(
    os.path.abspath(
        __file__
    )
)
PARENT_DIRECTORY = os.path.abspath(os.path.join(os.getcwd(), os.pardir))
DATA_FILES = os.path.join(PARENT_DIRECTORY,'historical_data')
BACKUPS_FILES = os.path.join(PARENT_DIRECTORY,'backups')
SQL_FILES =  os.path.join(PARENT_DIRECTORY,'sql')

# DATABASE_HOST = os.environ['']
DATABASE_NAME = os.environ.get('TF_VAR_DATABASE')
DATABASE_USER = os.environ['TF_VAR_DATABASE_USER']
DATABASE_PASS = os.environ['TF_VAR_DATABASE_PASSWORD']
DATABASE_HOST = 'datachallenge.cwl4757u5g17.us-east-1.rds.amazonaws.com'
BUCKET = 'data-challenge-bucket-oscar'