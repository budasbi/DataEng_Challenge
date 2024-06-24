# Variables
SHELL := /bin/bash
TF_PROJECT_DIR := ./terraform
TF_PLAN_FILE := terraform.tfplan

init:
	cd $(TF_PROJECT_DIR) && terraform init
plan:
	source ./load_env_variables.sh && \
	cd $(TF_PROJECT_DIR) && terraform plan 
apply:
	source ./load_env_variables.sh && \
	cd $(TF_PROJECT_DIR) && terraform apply 
destroy:
	source ./load_env_variables.sh && \
	cd $(TF_PROJECT_DIR) && terraform destroy 
connect_db:
	psql "postgresql://postgres:$(TF_VAR_DATABASE_PASSWORD)@datachallenge.cwl4757u5g17.us-east-1.rds.amazonaws.com/$(TF_VAR_DATABASE)" -f ./sql/DDL_departments.sql -f ./sql/DDL_jobs.sql -f ./sql/DDL_hired_employees.sql  -f ./sql/DDL_logs.sql
load_files_to_s3:
	aws s3 cp ./historical_data/departments.xlsx s3://data-challenge-bucket-oscar/data/departments.xlsx && \
	aws s3 cp ./historical_data/hired_employees.xlsx s3://data-challenge-bucket-oscar/data/hired_employees.xlsx && \
	aws s3 cp ./historical_data/jobs.xlsx s3://data-challenge-bucket-oscar/data/jobs.xlsx
build_docker:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 975691492030.dkr.ecr.us-east-1.amazonaws.com && \
	docker build -t lambda_data_challenge_repo . && \
	docker tag lambda_data_challenge_repo:latest 975691492030.dkr.ecr.us-east-1.amazonaws.com/lambda_data_challenge_repo:latest && \
	docker push 975691492030.dkr.ecr.us-east-1.amazonaws.com/lambda_data_challenge_repo:latest
#Deployment
#1.  Load env variables
#2.  Rename lambda.tf since the ECR repository will not exist the first execution
#3.  Create infrastructure, VPC, RDS, Bucket, Subnets, Security Groups, Network resources,ECR repository, providers etc
#4.  Store outputs in a file TODO we could get this and use the variables in python code or connecting to the db
#5.  Load Files into S3

initial_build:
	source ./load_env_variables.sh && \
	if [ -e $(TF_PROJECT_DIR)/lambda.tf ]; then mv $(TF_PROJECT_DIR)/lambda.tf $(TF_PROJECT_DIR)/lambda.tf.bak; else echo "lambda already renamed"; fi && \
	if [ -e $(TF_PROJECT_DIR)/api_gateway.tf ]; then mv $(TF_PROJECT_DIR)/api_gateway.tf $(TF_PROJECT_DIR)/api_gateway.tf.bak; else echo "api_gateway already renamed"; fi && \
	make plan && \
	cd $(TF_PROJECT_DIR) && terraform apply -auto-approve && \
	terraform output > terraform_outputs.txt && \
	cd .. && \
	make build_docker
	if [ -e $(TF_PROJECT_DIR)/lambda.tf.bak ]; then mv $(TF_PROJECT_DIR)/lambda.tf.bak $(TF_PROJECT_DIR)/lambda.tf; else echo "lambda restored"; fi && \
	if [ -e $(TF_PROJECT_DIR)/api_gateway.tf.bak ]; then mv $(TF_PROJECT_DIR)/api_gateway.tf.bak $(TF_PROJECT_DIR)/api_gateway.tf; else echo "api_gateway restored"; fi && \
	make plan && \
	cd $(TF_PROJECT_DIR) && terraform apply -auto-approve && \
	make load_files_to_s3
	
