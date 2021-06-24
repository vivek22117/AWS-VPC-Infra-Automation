variable "schedule_expression" {
  type        = string
  description = "Expression for lambda scheduler"
}

variable "lambda_fun_arn" {
  type = string
  description = "Lambda ARN for integration"
}

variable "lambda_fun_name" {
  type = string
  description = "Lambda function name"
}

variable "aws_event_type" {
  type = string
  description = "Event type to trigger lambda"
}

variable "event_pattern" {
  type = string
  description = "JSON event pattern for CW event rule"
}

######################################################
# Local variables defined                            #
######################################################
variable "team" {
  type        = string
  description = "Owner team for this application infrastructure"
}

variable "owner" {
  type        = string
  description = "Owner of the product"
}

variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

#####=============Local variables===============#####
locals {
  common_tags = {
    owner       = var.owner
    team        = var.team
    environment = var.environment
    Project     = "DD-Solutions"
  }
}