###################################################
# Fetch remote state for S3 deployment bucket     #
###################################################
data "terraform_remote_state" "s3_buckets" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key    = "state/${var.environment}/s3-buckets/terraform.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    profile = "admin"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/vpc/terraform.tfstate"
    region  = var.default_region
  }
}


data "aws_caller_identity" "current" {}
