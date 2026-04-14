
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

variable "ami" {
    description = "Ami id for the ec2 instance"
    type = string
  
}
variable "instance_type" {
    description = "Value of instance_type"
  
}
variable "db_name" {
  description = "Name of the database"
  type = string
}
variable "engine" {
  description = "Engine of the db"
  type = string
}
variable "engine_version" {
  description = "version of the engine"
  type = string
}
variable "instance_class" {
  description = "Instance class "
  type = string
}
variable "username" {
  description = "Username of the db"
  type = string
}
variable "bucket" {
  description = "name of bucket"
  type = string
}
variable "cluster_id" {
    description = "Value of Cluster id"
    type=string
}
variable "cache_engine" {
  description = "value of engine"
  type = string
}
variable "cache_engine_version" {
    description = "value of engine_version"
    type = string
}
variable "port" {
    description = "Value of Port"
    type = number
  
}
variable "node_type" {
  description = "value of node type"
  type = string
}
variable "num_cache_nodes" {
    description = "value of num cache"
    type = number
  
}
variable "para_name" {
  description = "Name "
  type = string
}
variable "family" {
  description = "value of family"
  type = string
}
