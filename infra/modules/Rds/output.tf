output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.rds_wp.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.rds_wp.port
}

output "rds_db_name" {
  description = "Database name"
  value       = aws_db_instance.rds_wp.db_name
}

output "rds_username" {
  description = "Database username"
  value       = aws_db_instance.rds_wp.username
}