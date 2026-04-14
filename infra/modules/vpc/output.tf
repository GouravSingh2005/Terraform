
# VPC OUTPUT

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main_vpc.id
}


# PUBLIC SUBNET IDS

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}


# PRIVATE SUBNET IDS

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [for subnet in aws_subnet.private_app : subnet.id]
}


# DATABASE SUBNET IDS

output "db_subnet_ids" {
  description = "Database subnet IDs"
  value       = [for subnet in aws_subnet.database : subnet.id]
}


# INTERNET GATEWAY

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.gw.id
}


# NAT GATEWAY

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = aws_nat_gateway.nat[*].id
}