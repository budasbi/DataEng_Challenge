resource "aws_ssm_parameter" "db_username" {
  name        = "/data_challenge/db_username"
  description = "The database username"
  type        = "String"
  value       = var.DATABASE_USER
  
tags = {
  Name = var.default_tag }
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/data_challenge/db_name"
  description = "The database name"
  type        = "String"
  value       = var.DATABASE
  
tags = {
  Name = var.default_tag }
}

resource "aws_ssm_parameter" "db_pass" {
  name        = "/data_challenge/db_pass"
  description = "The database name"
  type        = "SecureString"
  value       = var.DATABASE_PASSWORD
  
tags = {
  Name = var.default_tag }
}