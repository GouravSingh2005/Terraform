variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}

variable "ec2_sg_id" {
  description = "EC2 security group ID"
  type        = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint for userdata"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for userdata"
  type        = string
}

variable "redis_host" {
  description = "Redis endpoint for userdata"
  type        = string
}

variable "aws_region" {
  description = "AWS region for userdata"
  type        = string
}

variable "backend_repo_url" {
  description = "Backend ECR repository URL"
  type        = string
}

variable "frontend_repo_url" {
  description = "Frontend ECR repository URL"
  type        = string
}