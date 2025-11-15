# AWS Infrastructure Project Documentation

## Project Overview

This document provides comprehensive documentation for the AWS infrastructure deployment using Terraform. The infrastructure consists of a scalable, secure, and highly available architecture deployed in the US-West-1 region.

## Architecture Components

### 1. Virtual Private Cloud (VPC)
- **CIDR Block**: 10.0.0.0/16
- **Region**: us-west-1
- **Multi-AZ deployment** for high availability

### 2. Networking
- **Private Subnets**: 
  - 10.0.1.0/24 (AZ-1)
  - 10.0.2.0/24 (AZ-2)
- **Public Subnets**:
  - 10.0.3.0/24 (AZ-1)
  - 10.0.4.0/24 (AZ-2)
- **Internet Gateway**: For public internet access
- **NAT Gateway**: For private subnet internet access
- **Elastic IP**: Associated with NAT Gateway

### 3. Compute Layer (ECS)
- **ECS Cluster**: my-ecs-cluster
- **Launch Template**: ecs-launch-template
- **Instance Types**: Mixed instances policy with:
  - Primary: t3.medium
  - Alternatives: t3.small, t2.medium
- **Auto Scaling Group**: 
  - Min: 2 instances
  - Max: 5 instances
  - Desired: 2 instances
  - On-demand instances: 100%
- **AMI**: Amazon ECS-optimized AMI (amzn2-ami-ecs-hvm-*-x86_64-ebs)
- **Deployment**: Private subnets only
- **Network**: No public IP assignment

### 4. Database Layer (RDS)
- **Engine**: PostgreSQL
- **Instance Class**: db.t3.micro
- **Storage**: 20GB encrypted
- **Multi-AZ**: Disabled (cost optimization)
- **Backup Retention**: 7 days
- **Access**: Private subnets only (port 5432)
- **Database Name**: mydb
- **Username**: dbadmin
- **Identifier**: Random suffix for uniqueness
- **DB Subnet Group**: Spans private subnets
- **Public Access**: Disabled
- **Final Snapshot**: Skipped for development

### 5. Load Balancer (ALB)
- **Name**: app-lb
- **Type**: Application Load Balancer
- **Deployment**: Public subnets
- **Internal**: False (internet-facing)
- **Cross-zone load balancing**: Enabled
- **Target Group**: ecs-target-group (IP-based)
- **Listener**: HTTP on port 80
- **Default Action**: Fixed response (200 OK)
- **Deletion Protection**: Disabled

## Security Configuration

### Network Security
- **Private subnets**: No direct internet access
- **Public subnets**: Internet gateway access only
- **Security groups**: Least privilege access

### Security Groups
1. **ECS Security Group** (ecs-sg):
   - Inbound: Port 80 (HTTP) from anywhere (0.0.0.0/0)
   - Outbound: Not explicitly configured (default deny)

2. **RDS Security Group** (rds-sg):
   - Inbound: Port 5432 (PostgreSQL) from VPC CIDR (10.0.0.0/16) only
   - Outbound: Not explicitly configured (default deny)

3. **ALB Security Group** (alb-sg):
   - Inbound: Port 80 (HTTP) from anywhere (0.0.0.0/0)
   - Outbound: All traffic allowed (0.0.0.0/0)

### Data Security
- **RDS Encryption**: Enabled at rest
- **Network isolation**: Database in private subnets
- **Access control**: Security group restrictions

## Infrastructure as Code

### Terraform Structure
```
aws-infra-terraform/
├── main.tf                 # Main configuration
├── variables.tf            # Variable definitions
├── outputs.tf             # Output values
├── security_groups.tf     # Security configurations
└── modules/
    ├── vpc/               # VPC module
    ├── ecs/               # ECS module
    ├── rds/               # RDS module
    └── alb/               # Load balancer module
```

### Key Features
- **Modular design**: Reusable components (vpc, ecs, rds, alb)
- **Random naming**: RDS resources use random suffixes
- **Parameterized**: Configurable through variables
- **State management**: Terraform state tracking
- **Mixed instance policy**: Cost optimization with multiple instance types
- **Launch templates**: Modern EC2 instance management
- **Security group separation**: Dedicated security groups per service

## Deployment Instructions

### Prerequisites
1. AWS CLI configured with appropriate credentials
2. Terraform installed (version 1.0+)
3. Appropriate IAM permissions for resource creation

### Deployment Steps
1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan deployment**:
   ```bash
   terraform plan
   ```

3. **Apply configuration**:
   ```bash
   terraform apply
   ```

4. **Verify deployment**:
   ```bash
   terraform show
   ```

### Health Check
A health check script (`health-check.sh`) is included for monitoring deployment status.

## Cost Optimization

### Current Configuration
- **RDS**: db.t3.micro (lowest cost tier)
- **ECS**: Mixed instances (t3.medium, t3.small, t2.medium) for cost optimization
- **Single NAT Gateway**: Shared across AZs
- **No Multi-AZ RDS**: Reduced costs for development
- **100% On-demand instances**: No spot instances for stability
- **Skip final snapshot**: Faster teardown for development

### Recommendations
- Monitor CloudWatch metrics for right-sizing
- Consider Reserved Instances for production
- Implement auto-scaling policies
- Regular cost reviews using AWS Cost Explorer

## Monitoring and Maintenance

### Recommended Monitoring
- **CloudWatch**: Instance and application metrics
- **VPC Flow Logs**: Network traffic analysis
- **RDS Performance Insights**: Database monitoring
- **ALB Access Logs**: Load balancer analytics

### Backup Strategy
- **RDS**: Automated backups (7-day retention)
- **ECS**: Container image versioning
- **Terraform State**: Remote state storage recommended

## Security Best Practices Implemented

1. **Network Segmentation**: Public/private subnet separation
2. **Least Privilege**: Minimal security group rules
3. **Encryption**: RDS storage encryption
4. **No Public Database**: RDS in private subnets only
5. **Infrastructure as Code**: Version-controlled deployments

## Troubleshooting

### Common Issues
1. **Subnet availability**: Ensure AZs have sufficient capacity
2. **Security group rules**: Verify port access between services
3. **NAT Gateway**: Check routing for private subnet internet access
4. **RDS connectivity**: Verify security group and subnet group configuration

### Useful Commands
```bash
# Check Terraform state
terraform state list

# Validate configuration
terraform validate

# Format code
terraform fmt

# Destroy infrastructure
terraform destroy
```


---

