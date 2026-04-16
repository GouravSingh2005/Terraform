
# IAM ROLE OUTPUTS


output "ec2_role_name" {
  description = "Name of the EC2 IAM Role"
  value       = module.ec2.ec2_role_name
}

output "ec2_instance_profile_name" {
  description = "Instance Profile Name"
  value       = module.ec2.ec2_instance_profile_name
}



# LOAD BALANCER OUTPUTS

output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = module.ec2.alb_dns_name
}

output "alb_arn" {
  description = "ARN of ALB"
  value       = module.ec2.alb_arn
}



# LAUNCH TEMPLATE OUTPUTS


output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.ec2.launch_template_id
}



# AUTO SCALING GROUP OUTPUTS


output "asg_name" {
  description = "Auto Scaling Group Name"
  value       = module.ec2.asg_name
}

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = module.ec2.asg_arn
}



# SCALING POLICY OUTPUT


output "scaling_policy_name" {
  description = "Scaling Policy Name"
  value       = module.ec2.scaling_policy_name
}



# ELASTICACHE OUTPUTS


output "elasticache_cluster_id" {
  description = "ElastiCache Cluster ID"
  value       = module.elastcache.elasticache_cluster_id
}

output "elasticache_cluster_address" {
  description = "Redis endpoint"
  value       = module.elastcache.elasticache_cluster_address
}

output "elasticache_cluster_port" {
  description = "Redis port"
  value       = module.elastcache.elasticache_cluster_port
}

output "elasticache_parameter_group_name" {
  description = "Parameter group name"
  value       = module.elastcache.elasticache_parameter_group_name
}



# RDS OUTPUTS

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = module.rds.rds_port
}

output "rds_db_name" {
  description = "Database name"
  value       = module.rds.rds_db_name
}

output "rds_username" {
  description = "Database username"
  value       = module.rds.rds_username
}



# S3 OUTPUTS


output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.s3_bucket_arn
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3.s3_bucket_id
}


# VPC OUTPUTS


output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "db_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.vpc.db_subnet_ids
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}
