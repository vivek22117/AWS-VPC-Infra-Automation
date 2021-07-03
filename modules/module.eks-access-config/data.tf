###########################################################
#             Remote state configuration to fetch         #
#                  vpc, artifactory bucket                #
###########################################################
data "terraform_remote_state" "eks_vpc" {
  backend = "s3"

  config = {
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/eks-vpc/terraform.tfstate"
    region  = var.default_region
  }
}


data "terraform_remote_state" "eks_cluster" {
  backend = "s3"

  config = {
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/eks-cluster/terraform.tfstate"
    region  = var.default_region
  }
}

data "terraform_remote_state" "s3_buckets" {
  backend = "s3"

  config = {
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

data "template_file" "eks_bastion_user_data" {
  template = file("${path.module}/data-scripts/configure-eks.sh")

  vars = {
    eks_create_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-creator"
    cluster_name = data.terraform_remote_state.eks_cluster.outputs.eks_cluster_id
    default_region = var.default_region
    artifactory_bucket_name = data.terraform_remote_state.s3_buckets.outputs.artifactory_s3_name
  }
}

data "aws_caller_identity" "current" {}