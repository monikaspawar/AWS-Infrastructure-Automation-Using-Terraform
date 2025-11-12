#!/bin/bash

echo "=== Infrastructure Health Check ==="

# Get VPC ID
VPC_ID=$(terraform output -raw vpc_id)
echo "VPC ID: $VPC_ID"

# Check ECS Cluster
echo "ECS Cluster Status:"
aws ecs describe-clusters --clusters my-ecs-cluster --region us-west-1 --query 'clusters[0].status'

# Check RDS Status
echo "RDS Status:"
aws rds describe-db-instances --region us-west-1 --query 'DBInstances[0].DBInstanceStatus'

# Check ALB
echo "ALB Status:"
aws elbv2 describe-load-balancers --names app-lb --region us-west-1 --query 'LoadBalancers[0].State.Code'

# Get ALB DNS
ALB_DNS=$(aws elbv2 describe-load-balancers --names app-lb --region us-west-1 --query 'LoadBalancers[0].DNSName' --output text)
echo "ALB DNS: $ALB_DNS"

# Test ALB
echo "Testing ALB endpoint:"
curl -s http://$ALB_DNS || echo "ALB not responding"

echo "=== Health Check Complete ==="