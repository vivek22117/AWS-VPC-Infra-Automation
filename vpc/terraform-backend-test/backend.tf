#####=====================Terraform tfstate backend S3===================#####
resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "${var.tf_s3_bucket_prefix}-${var.environment}-${var.default_region}"
  acl    = "private"

  force_destroy = false

  lifecycle {
    prevent_destroy = "true"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    id      = "state"
    prefix  = "state/"

    noncurrent_version_expiration {
      days = 1
    }
  }

  tags = merge(local.common_tags, map("name", "tf-state-bucket-${var.environment}"))
}

#####=========================DynamoDB Table for tfstate state lock=====================#####
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "${var.dyanamoDB_prefix}-${var.environment}-${var.default_region}"
  read_capacity  = 2
  write_capacity = 2

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags, map("name", "tf-state-db-${var.environment}"))
}


