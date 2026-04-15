data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_s3_access" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${var.bucket_arn}/${var.input_prefix}*",
      "${var.bucket_arn}/${var.output_prefix}*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name   = "${var.function_name}-s3-access"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_s3_access.json
}

resource "aws_lambda_function" "image_resizer" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = var.runtime
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = var.timeout
  memory_size      = var.memory_size
  architectures    = ["x86_64"]

  environment {
    variables = {
      INPUT_PREFIX  = var.input_prefix
      OUTPUT_PREFIX = var.output_prefix
      RESIZE_WIDTH  = tostring(var.resize_width)
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy.lambda_s3_access,
  ]
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.input_prefix
  }

  depends_on = [aws_lambda_permission.allow_s3_trigger]
}
