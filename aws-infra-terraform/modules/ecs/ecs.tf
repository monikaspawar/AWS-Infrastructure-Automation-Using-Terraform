data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

resource "aws_launch_template" "ecs" {
  name = "ecs-launch-template"
  image_id = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ecs.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ECS Instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  vpc_zone_identifier = var.private_subnet_ids

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 100
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs.id
        version = "$Latest"
      }
      override {
        instance_type = "t3.medium"
      }
      override {
        instance_type = "t3.small"
      }
      override {
        instance_type = "t2.medium"
      }
    }
  }
}

resource "aws_security_group" "ecs" {
  name_prefix = "ecs-sg"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}
