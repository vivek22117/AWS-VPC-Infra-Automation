###################################################
# Fetch remote state for S3 deployment bucket     #
###################################################
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key    = "state/${var.environment}/vpc/terraform.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key    = "state/${var.environment}/bastion/terraform.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "backend-server-prod" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key    = "state/prod/ria-asg-app/terraform.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "backend-server-dev" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key    = "state/${var.environment}/ria-asg-app/terraform.tfstate"
    region = var.default_region
  }
}

############==============Read Json cloudformation template for SNS===========########
data "template_file" "cft_sns_stack" {
  template = file("${path.module}/script/sns-cft.json.tpl")

  vars = {
    display_name   = var.display_name
    sns_topic_name = var.sns_topic_name
    subscriptions = join(
      ",",
      formatlist(
        "{ \"Endpoint\": \"%s\", \"Protocol\": \"%s\"  }",
        var.sns_subscription_email_address_list,
        var.protocol,
      )
    )
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}