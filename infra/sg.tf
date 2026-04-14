
# ALB SECURITY GROUP

resource "aws_security_group" "web_alb" {
  name        = "alb-sg"
  description = "Allow HTTP traffic from Internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 SECURITY GROUP

resource "aws_security_group" "ec2_app" {
  name        = "ec2-app-sg"
  description = "Allow HTTP traffic ONLY from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# DATABASE SECURITY GROUP

resource "aws_security_group" "database_sg" {
  name        = "db-sg"
  description = "Allow MySQL access only from EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Elastic Cache Security group
resource "aws_security_group" "sg" {
name = "redis-sg"
vpc_id = module.vpc.vpc_id 
ingress  {
  from_port = 6379
  to_port= 6379
  protocol = "tcp"
  security_groups = [aws_security_group.ec2_app.id]
}
egress  {
  from_port=0
  to_port=0
  protocol = "-1"
  cidr_blocks=["0.0.0.0/0"]
}
  
}