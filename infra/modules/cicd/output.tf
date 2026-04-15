output "backend_repo_url" {
  description = "Backend ECR repository URL"
  value       = aws_ecr_repository.backend.repository_url
}

output "frontend_repo_url" {
  description = "Frontend ECR repository URL"
  value       = aws_ecr_repository.frontend.repository_url
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = aws_codebuild_project.app_ci.name
}