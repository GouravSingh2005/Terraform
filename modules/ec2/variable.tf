variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "ami" {
    description = "Ami id for the ec2 instance"
    type = string
  
}