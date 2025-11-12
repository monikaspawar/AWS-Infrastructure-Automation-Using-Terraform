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
- **Instance Type**: t3.medium (with t3.small and t2.medium alternatives)
- **Auto Scaling Group**: 
  - Min: 2 instances
  - Max: 5 instances
  - Desired: 2 instances
- **AMI**: Amazon ECS-optimized AMI
- **Deployment**: Private subnets only

### 4. Database Layer (RDS)
- **Engine**: PostgreSQL
- **Instance Class**: db.t3.micro
- **Storage**: 20GB encrypted
- **Multi-AZ**: Disabled (cost optimization)
- **Backup Retention**: 7 days
- **Access**: Private subnets only (port 5432)

### 5. Load Balancer (ALB)
- **Type**: Application Load Balancer
- **Deployment**: Public subnets
- **Cross-zone load balancing**: Enabled
- **Target Group**: ECS services (IP-based)

## Security Configuration

### Network Security
- **Private subnets**: No direct internet access
- **Public subnets**: Internet gateway access only
- **Security groups**: Least privilege access

### Security Groups
1. **ECS Security Group**:
   - Inbound: Port 80 (HTTP) from anywhere
   - Outbound: All traffic allowed

2. **RDS Security Group**:
   - Inbound: Port 5432 (PostgreSQL) from VPC CIDR only
   - Outbound: Restricted

3. **ALB Security Group**:
   - Inbound: Port 80 (HTTP) from anywhere
   - Outbound: To ECS instances

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
- **Modular design**: Reusable components
- **Random naming**: Prevents resource conflicts
- **Parameterized**: Configurable through variables
- **State management**: Terraform state tracking

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
- **ECS**: t3.medium instances (burstable performance)
- **Single NAT Gateway**: Shared across AZs
- **No Multi-AZ RDS**: Reduced costs for development

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

## Future Enhancements

### Scalability Improvements
- **Multi-region deployment**: Disaster recovery
- **Auto Scaling**: Dynamic capacity management
- **Container orchestration**: ECS service definitions
- **Database clustering**: RDS Multi-AZ or Aurora

### Security Enhancements
- **WAF integration**: Web application firewall
- **VPC endpoints**: Private AWS service access
- **Secrets Manager**: Credential management
- **Network ACLs**: Additional network security

### Monitoring Improvements
- **Centralized logging**: CloudWatch Logs aggregation
- **Alerting**: CloudWatch alarms and SNS notifications
- **Performance monitoring**: Application-level metrics
- **Cost monitoring**: Budget alerts and optimization

---

**Document Version**: 1.0  
**Last Updated**: $(date)  
**Author**: Infrastructure Team  
**Review Date**: Quarterly