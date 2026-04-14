output "elasticache_cluster_id" {
  description = "ElastiCache Cluster ID"
  value       = aws_elasticache_cluster.ec.id
}

output "elasticache_cluster_address" {
  description = "Primary endpoint address of the cluster"
  value       = aws_elasticache_cluster.ec.cache_nodes[0].address
}

output "elasticache_cluster_port" {
  description = "Port on which Redis is running"
  value       = aws_elasticache_cluster.ec.cache_nodes[0].port
}

output "elasticache_parameter_group_name" {
  description = "Parameter group name"
  value       = aws_elasticache_parameter_group.pg.name
}