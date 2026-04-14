
# IAM ROLE OUTPUTS


output "ec2_role_name" {
  description = "Name of the EC2 IAM Role"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_name" {
  description = "Instance Profile Name"
  value       = aws_iam_instance_profile.ec2.name
}


# LOAD BALANCER OUTPUTS


output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = aws_lb.web_alb.dns_name
}

output "alb_arn" {
  description = "ARN of ALB"
  value       = aws_lb.web_alb.arn
}


# LAUNCH TEMPLATE OUTPUTS


output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.ec2_app_lt.id
}


# AUTO SCALING GROUP OUTPUTS


output "asg_name" {
  description = "Auto Scaling Group Name"
  value       = aws_autoscaling_group.web.name
}

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.web.arn
}


# SCALING POLICY OUTPUT


output "scaling_policy_name" {
  description = "Scaling Policy Name"
  value       = aws_autoscaling_policy.cpu_target.name
}