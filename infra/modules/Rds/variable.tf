variable "db_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}
variable "db_name" {
  description = "Name of the database"
  type        = string
}
variable "engine" {
  description = "Engine of the db"
  type        = string
}
variable "engine_version" {
  description = "version of the engine"
  type        = string
}
variable "instance_class" {
  description = "Instance class "
  type        = string
}
variable "username" {
  description = "Username of the db"
  type        = string
}
variable "db_password" {
  description = "Password of the db"
  type        = string
  sensitive   = true
}
variable "aws_db_sg" {
  description = "security group of the db"
  type        = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}