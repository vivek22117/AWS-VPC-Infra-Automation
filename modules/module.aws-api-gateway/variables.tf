variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "default_region" {
  type    = string
  description = "AWS region to deploy resources"
}

#####========================Lambda Configuration======================#####
variable "rest_api_name" {
  type = string
  description = "API name"
}

variable "api_description" {
  type = string
  description = "API description"
}

variable "endpoint_type" {
  type = string
  description = "Type of API deployment, valid values, EDGE, REGIONAL or PRIVATE"
}

variable "api_authorization" {
  type = string
  description = "API Gateway authorization type, valid values NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS"
}

variable "api_gateway_reminder_path" {
  type        = string
  description = "URL path for reminder api gateway resource"
}

variable "email-lambda-bucket-key" {
  type    = string
  description = "S3 bucket key to hold lambda artifactory"
}

variable "verified_email" {
  type    = string
  description = "Verified email Id to send email!"
}

#####====================Default Variables==================#####
variable "s3_bucket_prefix" {
  type    = string
  default = "doubledigit-tfstate"
}

#####============================Local variables=====================#####
locals {
  common_tags = {
    owner       = "Vivek"
    team        = "DoubleDigitTeam"
    environment = var.environment
  }
}

