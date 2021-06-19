provider "aws" {
  region  = var.default_region
  profile = var.profile

  version = ">=2.35"
}

provider "template" {
  version = "2.1.2"
}

provider "archive" {
  version = "1.2.2"
}

###########################################################
# Terraform configuration block is used to define backend #
# Interpolation sytanx is not allowed in Backend          #
###########################################################
terraform {
  required_version = ">=0.13"

  backend "s3" {
    profile = "qa-admin"
    region  = "us-east-1"
    encrypt = true
  }
}