variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = "ecs-cluster"
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
  default     = "mydb"
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
