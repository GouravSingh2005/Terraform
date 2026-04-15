provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  db_subnets      = var.db_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  common_tags = var.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  project_name       = var.project_name

  alb_sg_id = aws_security_group.web_alb.id
  ec2_sg_id = aws_security_group.ec2_app.id

  ami           = var.ami
  instance_type = var.instance_type

  environment = var.environment
  common_tags = var.common_tags

  rds_endpoint      = module.rds.rds_endpoint
  bucket_name       = module.s3.s3_bucket_name
  redis_host        = module.elastcache.elasticache_cluster_address
  aws_region        = var.aws_region
  backend_repo_url  = module.cicd.backend_repo_url
  frontend_repo_url = module.cicd.frontend_repo_url
}

module "rds" {
  source         = "./modules/Rds"
  project_name   = var.project_name
  db_name        = var.db_name
  engine         = var.engine
  username       = var.username
  db_password    = var.db_password
  instance_class = var.instance_class
  engine_version = var.engine_version

  db_subnet_ids = module.vpc.db_subnet_ids
  aws_db_sg     = aws_security_group.database_sg.id

  environment = var.environment
  common_tags = var.common_tags
}
module "s3" {
  source = "./modules/s3"

  bucket = var.bucket

  environment = var.environment
  common_tags = var.common_tags
}

module "lambda_image_resize" {
  source = "./modules/Lambda"

  function_name   = "image-resizer"
  source_zip_path = "${path.module}/modules/Lambda/function.zip"

  bucket_name = module.s3.s3_bucket_name
  bucket_arn  = module.s3.s3_bucket_arn
}

module "cicd" {
  source = "./modules/cicd"

  project_name  = var.project_name
  environment   = var.environment
  aws_region    = var.aws_region
  github_owner  = var.github_owner
  github_repo   = var.github_repo
  github_branch = var.github_branch
  github_token  = var.github_token
}

module "elastcache" {
  source = "./modules/elasticache"

  private_subnet_ids   = module.vpc.private_subnet_ids
  cache_engine_version = var.cache_engine_version
  cache_engine         = var.cache_engine
  node_type            = var.node_type
  family               = var.family
  port                 = var.port
  cluster_id           = var.cluster_id
  ec_sg_id             = aws_security_group.sg.id
  num_cache_nodes      = var.num_cache_nodes
  para_name            = var.para_name
}