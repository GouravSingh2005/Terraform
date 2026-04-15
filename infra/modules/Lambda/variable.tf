variable "function_name" {
  description = "Name of the Lambda resize function"
  type        = string
  default     = "image-resizer"
}

variable "source_zip_path" {
  description = "Path to the packaged Lambda zip"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for uploads"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN for access policies"
  type        = string
}

variable "input_prefix" {
  description = "Prefix for original uploads"
  type        = string
  default     = "uploads/"
}

variable "output_prefix" {
  description = "Prefix for resized objects"
  type        = string
  default     = "resized/"
}

variable "resize_width" {
  description = "Target width for resized images"
  type        = number
  default     = 1200
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs20.x"
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 256
}