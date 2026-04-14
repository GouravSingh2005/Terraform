# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name        = "${lower(var.environment)}-vpc"
    Environment = var.environment
  })
}

# PUBLIC SUBNETS
resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-public-subnet-${split("-", each.key)[1]}"
  })
}

# PRIVATE APP SUBNETS
resource "aws_subnet" "private_app" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-private-app-${split("-", each.key)[1]}"
  })
}

# DATABASE SUBNETS
resource "aws_subnet" "database" {
  for_each = var.db_subnets

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-private-db-${split("-", each.key)[1]}"
  })
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-igw"
  })
}

locals {
  nat_enabled = var.enable_nat_gateway
  nat_count   = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0
}

# ELASTIC IP
resource "aws_eip" "nat" {
  count = local.nat_count

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-eip-${count.index}"
  })
}

# NAT GATEWAY 
resource "aws_nat_gateway" "nat" {
  count = local.nat_count

  allocation_id = aws_eip.nat[count.index].id

  subnet_id = local.nat_enabled && var.single_nat_gateway ? values(aws_subnet.public_subnet)[0].id : values(aws_subnet.public_subnet)[count.index].id

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-nat-${count.index}"
  })
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-public-rt"
  })
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  dynamic "route" {
    for_each = local.nat_enabled ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }

  tags = merge(var.common_tags, {
    Name = "${lower(var.environment)}-private-rt"
  })
}

# PUBLIC ASSOCIATION
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# PRIVATE ASSOCIATION
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}