# Variables
SHELL := /bin/bash
TF_PROJECT_DIR := ./terraform
TF_PLAN_FILE := terraform.tfplan

init:
	cd $(TF_PROJECT_DIR) && terraform init
plan:
	cd $(TF_PROJECT_DIR) && terraform plan 
apply:
	cd $(TF_PROJECT_DIR) && terraform apply 
destroy:
	cd $(TF_PROJECT_DIR) && terraform destroy 
connect_db:
	psql "postgresql://postgres:$(TF_VAR_DATABASE_PASSWORD)@datachallenge.cwl4757u5g17.us-east-1.rds.amazonaws.com/$(TF_VAR_DATABASE)" -f ./sql/DDL_departments.sql -f ./sql/DDL_jobs.sql -f ./sql/DDL_hired_employees.sql  -f ./sql/DDL_logs.sql
load_files_to_s3:
	aws s3 cp ./historical_data/departments.xlsx s3://data-challenge-bucket-oscar/data/departments.xlsx && \
	aws s3 cp ./historical_data/hired_employees.xlsx s3://data-challenge-bucket-oscar/data/hired_employees.xlsx && \
	aws s3 cp ./historical_data/jobs.xlsx s3://data-challenge-bucket-oscar/data/jobs.xlsx
#Deployment
#1.  Load env variables
#2.  Rename lambda.tf since the ECR repository will not exist the first execution
#3.  Create infrastructure, VPC, RDS, Bucket, Subnets, Security Groups, Network resources,ECR repository, providers etc
#4.  Store outputs in a file TODO we could get this and use the variables in python code or connecting to the db
#5.  Load Files into S3

build:
	source ./load_env_variables.sh && \
	if [ -e $(TF_PROJECT_DIR)/lambda.tf ]; then mv $(TF_PROJECT_DIR)/lambda.tf $(TF_PROJECT_DIR)/lambda.tf.bak; else echo "lambda already renamed"; fi && \
	cd $(TF_PROJECT_DIR) && terraform apply && \
	terraform output > terraform_outputs.txt && \
	cd .. && \
	make load_files_to_s3