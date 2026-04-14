
# BASIC CONFIG

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}


# VPC CONFIG

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}


# SUBNETS CONFIG

variable "public_subnets" {
  description = "Map of public subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "Map of private app subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "db_subnets" {
  description = "Map of database subnets"
  type = map(object({
    cidr = string
    az   = string
    
  }))
}


# NAT GATEWAY CONFIG

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT or one per AZ"
  type        = bool
  default     = true
}


# TAGS

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
