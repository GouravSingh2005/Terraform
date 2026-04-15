variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "lambda_zip_path" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "redis_host" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "aws_region" {
  type = string
}