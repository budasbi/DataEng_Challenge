variable "rds_password" {
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