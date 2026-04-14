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