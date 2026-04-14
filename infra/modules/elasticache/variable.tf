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
variable "ec_sg_id" {
  description = "EC security group ID"
  type        = string
}
variable "private_subnet_ids" {
  description = "Private subnet IDs for ElastiCache"
  type        = list(string)
}