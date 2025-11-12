resource "aws_security_group" "ecs" {
  name_prefix = "ecs-sg"
  vpc_id      = module.vpc.vpc_id
}
