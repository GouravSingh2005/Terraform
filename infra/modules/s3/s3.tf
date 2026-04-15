resource "aws_s3_bucket" "my_bucket" {
  bucket = "${lower(var.environment)}-${var.bucket}"

  tags = merge(var.common_tags, {
    Name        = "${lower(var.environment)}-s3-bucket"
    Environment = var.environment
  })
}

# VERSIONING 
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# BUCKET POLICY
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.allow_read_only_access.json
}

# POLICY DOCUMENT
data "aws_iam_policy_document" "allow_read_only_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["683633011377"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.my_bucket.arn,
      "${aws_s3_bucket.my_bucket.arn}/*"
    ]
  }

  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.my_bucket.arn}/resized/*",
    ]
  }
}