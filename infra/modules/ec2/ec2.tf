# ================================
# IAM ROLE
# ================================

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-ec2-role"
    Environment = var.environment
  })
}

# SSM access
resource "aws_iam_role_policy_attachment" "ssm_managed_ec2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ECR pull access
resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 🔥 ADD THIS (for fetching secrets later)
resource "aws_iam_role_policy_attachment" "ssm_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-ec2-profile"
    Environment = var.environment
  })
}

# ================================
# LOAD BALANCER (ALB)
# ================================

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]

  subnets = var.public_subnet_ids

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  })
}

# ================================
# TARGET GROUP
# ================================

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-tg"
    Environment = var.environment
  })
}

# ================================
# LISTENER
# ================================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ================================
# LAUNCH TEMPLATE
# ================================

resource "aws_launch_template" "ec2_app_lt" {
  name_prefix   = "${var.project_name}-${var.environment}-app-"
  image_id      = var.ami
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  # 🔥 FIXED (dynamic values inject)
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    rds_endpoint = var.rds_endpoint
    redis_host   = var.redis_host
    bucket_name  = var.bucket_name
    region       = var.region
  }))

  network_interfaces {
    security_groups = [var.ec2_sg_id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name        = "${var.project_name}-${var.environment}-app"
      Environment = var.environment
    })
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-lt"
    Environment = var.environment
  })
}

# ================================
# AUTO SCALING GROUP
# ================================

resource "aws_autoscaling_group" "web" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.ec2_app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# ================================
# AUTO SCALING POLICY
# ================================

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${var.project_name}-${var.environment}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}