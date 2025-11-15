module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ecs" {
  source = "./modules/ecs"
  ecs_cluster_name = "my-ecs-cluster"
  instance_type = "t3.medium"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source = "./modules/rds"
  rds_db_name = "mydb"
  rds_username = "dbadmin"
  rds_password = "admin12345"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
