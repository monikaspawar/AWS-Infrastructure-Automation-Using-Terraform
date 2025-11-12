variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ECS instances"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where ECS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS instances"
  type        = list(string)
}