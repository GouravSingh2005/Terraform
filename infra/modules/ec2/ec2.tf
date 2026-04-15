# ================= IAM =================

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_managed_ec2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ================= ALB =================

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
}

# ================= TARGET GROUPS =================

# Frontend
resource "aws_lb_target_group" "frontend_tg" {
  name     = "tf-task-stg-fe-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

# Backend
resource "aws_lb_target_group" "backend_tg" {
  name     = "tf-task-stg-be-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

# ================= LISTENER =================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  # Default → frontend
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# 🔥 API ROUTE → backend
resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# ================= LAUNCH TEMPLATE =================

resource "aws_launch_template" "ec2_app_lt" {
  name_prefix   = "${var.project_name}-${var.environment}-app-"
  image_id      = var.ami
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  network_interfaces {
    security_groups             = [var.ec2_sg_id]
    associate_public_ip_address = false
  }

  user_data = base64encode(templatefile("${path.module}/userdata.script", {
    rds_endpoint      = var.rds_endpoint
    bucket_name       = var.bucket_name
    region            = var.aws_region
    redis_host        = var.redis_host
    backend_repo_url  = var.backend_repo_url
    frontend_repo_url = var.frontend_repo_url
  }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-app"
    }
  }
}

# ================= AUTO SCALING =================

resource "aws_autoscaling_group" "web" {
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.private_subnet_ids

  # 🔥 BOTH TARGET GROUPS
  target_group_arns = [
    aws_lb_target_group.frontend_tg.arn,
    aws_lb_target_group.backend_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.ec2_app_lt.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app"
    propagate_at_launch = true
  }
}

# ================= SCALING POLICY =================

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