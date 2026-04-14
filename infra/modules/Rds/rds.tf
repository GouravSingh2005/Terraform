data "aws_ssm_parameter" "db_password" {
  name            = "/myapp/rds/password"
  with_decryption = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-wp"
  subnet_ids = var.db_subnet_ids

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-rds-subnet-group"
    Environment = var.environment
  })
}

resource "aws_db_instance" "rds_wp" {
  identifier = "${lower(var.project_name)}-${lower(var.environment)}-rds"
  allocated_storage = 10

  db_name         = var.db_name
  engine          = var.engine
  engine_version  = var.engine_version
  instance_class  = var.instance_class

  username = var.username
  password = data.aws_ssm_parameter.db_password.value

  vpc_security_group_ids = [var.aws_db_sg]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-rds"
    Environment = var.environment
  })
}