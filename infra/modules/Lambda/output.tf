output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.image_resizer.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.image_resizer.arn
}