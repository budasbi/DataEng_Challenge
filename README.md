# DataEng_Challenge
Challenge for Data engineer Role




# Requirements
1. Python 3.10
2. Terraform
3. Docker
4. AWS Credentials


# How to set up
## Load Env Variables
1. source load:env_variables.sh 

## Infrastructure
Check infrastructure diagram with draw.io \
From the project path, run:
1.  make init to initialize the terraform project
2.  Add your changes and then run "make plan" to create the terraform plan
3.  Accept and apply the plan running "make apply"
Notice that the terraform code is creating a lambda function and an ECR Repository,
the lambda function is using an image, we need to create first the ECR repository, then push the image and then Create the lambda function
you can use "make initial_build" to acomplish that,in this step, we are removing api_gateway and lambda tf, apply the changes,build and push the image and get back api-gw and lambda.tf 
and apply the new changes

## Code 
### 1.  Set the environment
1. python -m venv .venv
2. source .venv/bin/activate
3. pip install -r requirements.txt

## API Resources
API endpoint: "https://ws61qfkfyk.execute-api.us-east-1.amazonaws.com/dev"
### PUT
####  /load_data' 
It will get the files from S3, truncate the tables and load the xlsx files into the database
####  /create_backup
It will bulk the data into an AVRO file and sends the file to S3
will back up jobs, departments and hired_employees tables
####  /restore_backup
It will get the AVRO file from S3 and then truncate tables, and upload again the tables.

### POST
####  /jobs
It will add new jobs into the database, if the payload is incomplete or already exist, it will store the payload into the logs table
####  /departments
It will add new departments into the database, if the payload is incomplete or already exist, it will store the payload into the logs table
####  /hired_employees
It will add new hired_employees into the database, if the payload is incomplete or already exist, it will store the payload into the logs table

## Deployment
## Locally
1. make build_docker will build and push the image to ECR
## CI
1. Github workflows will build and push the image automatically when a PR is merged into main branch


# DEPLOYMENT CONSIDERATIONS
Be aware that if you apply a new terraform plan you will need to deploy the API into a Stage, 
If you build a new image, you we need to update the image sha in the lambda function

