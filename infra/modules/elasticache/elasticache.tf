

resource "aws_elasticache_subnet_group" "ec_subnet" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.cluster_id}-subnet-group"
  }
}



# ELASTICACHE PARAMETER GROUP

resource "aws_elasticache_parameter_group" "pg" {
  name        = var.para_name
  family      = var.family
  description = "This is parameter group"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}



# ELASTICACHE CLUSTER (REDIS)

resource "aws_elasticache_cluster" "ec" {
  cluster_id           = var.cluster_id
  engine               = var.cache_engine
  engine_version       = var.cache_engine_version
  port                 = var.port

  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes

  parameter_group_name = aws_elasticache_parameter_group.pg.name
  security_group_ids   = [var.ec_sg_id]

  subnet_group_name    = aws_elasticache_subnet_group.ec_subnet.name  


  tags = {
    Name = "${var.cluster_id}"
  }
}
