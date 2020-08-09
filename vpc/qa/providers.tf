####################################################
# AWS provider configuration                       #
####################################################
provider "aws" {
  region  = var.default_region
  profile = var.profile

  version = ">=2.22"
}


###########################################################
# Terraform configuration block is used to define backend #
# Interpolation sytanx is not allowed in Backend          #
###########################################################
terraform {
  required_version = ">= 0.12"

  backend "s3" {
    profile = "admin"
    region  = "us-east-1"
    encrypt = "true"
  }
}
