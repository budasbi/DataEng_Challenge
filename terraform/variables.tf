variable "DATABASE_PASSWORD" {
  type        = string
  description = "database password"
  sensitive   = true
}

variable "default_tag" {
  type        = string
  description = "default tag"
  default     = "data_challenge"
  sensitive   = false

}

variable "DATABASE" {
  type        = string
  description = "database name"
  sensitive   = false
}

variable "DATABASE_USER" {
  type        = string
  description = "database user"
  sensitive   = false
}


variable "region" {
  type        = string
  description = "region"
  sensitive   = false
  default     = "us-east-1"
}

variable "accountId" {
  type        = string
  description = "accountid"
  sensitive   = false
  default     = "975691492030"
}