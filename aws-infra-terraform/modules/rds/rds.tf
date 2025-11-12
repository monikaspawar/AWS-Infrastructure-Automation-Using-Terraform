resource "random_id" "rds_suffix" {
  byte_length = 4
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${random_id.rds_suffix.hex}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "RDS DB subnet group"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "rds-instance-${random_id.rds_suffix.hex}"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  multi_az               = false
  publicly_accessible    = false
  backup_retention_period = 7
  storage_encrypted      = true
  skip_final_snapshot    = true
  tags = {
    Name = "RDS Instance"
  }

  depends_on = [aws_security_group.rds]
}

resource "aws_security_group" "rds" {
  name_prefix = "rds-sg"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "rds_ingress" {
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]  # Limit access to private subnets
  security_group_id = aws_security_group.rds.id
}
