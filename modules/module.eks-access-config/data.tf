###########################################################
#             Remote state configuration to fetch         #
#                  vpc, artifactory bucket                #
###########################################################
data "terraform_remote_state" "eks-vpc" {
  backend = "s3"

  config = {
    profile = "admin"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/eks-vpc/terraform.tfstate"
    region  = var.default_region
  }
}

data "template_file" "ecs_read_only_template" {
  template = file("${path.module}/policy-doc/eks-full-access.json.tpl")
}

data "template_file" "ecs_full_access_template" {
  template = file("${path.module}/policy-doc/eks-read-access.json.tpl")
}