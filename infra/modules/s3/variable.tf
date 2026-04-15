variable "bucket" {
  description = "name of bucket"
  type        = string
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