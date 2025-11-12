variable "rds_db_name" {
  description = "The name of the RDS database"
  type        = string
}

variable "rds_username" {
  description = "The username for the RDS database"
  type        = string
}

variable "rds_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The VPC ID where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}