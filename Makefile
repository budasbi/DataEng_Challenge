# Variables
TF_PROJECT_DIR := ./terraform
TF_PLAN_FILE := terraform.tfplan

init:
	cd $(TF_PROJECT_DIR) && terraform init
plan:
	cd $(TF_PROJECT_DIR) && terraform plan -var "rds_password=Glob4ntdbPassw0rd"
apply:
	make plan && cd $(TF_PROJECT_DIR) && terraform apply -var "rds_password=Glob4ntdbPassw0rd"
destroy:
	cd $(TF_PROJECT_DIR) && terraform destroy


