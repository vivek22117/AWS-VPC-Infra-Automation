###########################################################
#             Remote state configuration to fetch         #
#                  vpc, artifactory bucket                #
###########################################################
data "terraform_remote_state" "eks_vpc" {
  backend = "s3"

  config = {
    profile = "admin"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/eks-vpc/terraform.tfstate"
    region  = var.default_region
  }
}

data "terraform_remote_state" "s3_buckets" {
  backend = "s3"

  config = {
    profile = var.profile
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/s3-buckets/terraform.tfstate"
    region  = var.default_region
  }
}

data "template_file" "eks_read_only_template" {
  template = file("${path.module}/policy-doc/eks-full-access.json.tpl")
}

data "template_file" "eks_full_access_template" {
  template = file("${path.module}/policy-doc/eks-read-access.json.tpl")
}

data "aws_caller_identity" "current" {}