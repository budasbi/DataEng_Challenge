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