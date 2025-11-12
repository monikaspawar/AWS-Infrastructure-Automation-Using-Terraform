# AWS Infrastructure with Terraform

A scalable, secure AWS infrastructure deployment using Terraform with modular design for ECS, RDS, and ALB components.

## Quick Start

```bash
cd aws-infra-terraform
terraform init
terraform plan
terraform apply
```

## Architecture

- **VPC**: 10.0.0.0/16 with public/private subnets across 2 AZs
- **ECS**: Auto-scaling cluster with mixed instance types (t3.medium/small, t2.medium)
- **RDS**: PostgreSQL db.t3.micro with encryption
- **ALB**: Internet-facing load balancer with HTTP listener

## Prerequisites

- AWS CLI configured
- Terraform 1.0+
- IAM permissions for VPC, ECS, RDS, ALB resources

## Project Structure

```
aws-infra-terraform/
├── main.tf              # Main configuration
├── variables.tf         # Variables
├── outputs.tf          # Outputs
├── security_groups.tf  # Security rules
└── modules/
    ├── vpc/            # VPC resources
    ├── ecs/            # ECS cluster
    ├── rds/            # PostgreSQL database
    └── alb/            # Load balancer
```

## Configuration

Key variables in `variables.tf`:
- `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/16)
- `instance_type`: ECS instance type (default: t3.medium)
- `rds_password`: Database password (sensitive)

## Security

- Private subnets for ECS and RDS
- Security groups with minimal access
- RDS encryption enabled
- No public database access

## Cost Optimization

- Mixed instance policy for ECS
- Single NAT Gateway
- db.t3.micro for RDS
- Development-optimized settings

## Cleanup

```bash
terraform destroy
```

For detailed documentation, see [AWS_Infrastructure_Documentation.md](AWS_Infrastructure_Documentation.md).