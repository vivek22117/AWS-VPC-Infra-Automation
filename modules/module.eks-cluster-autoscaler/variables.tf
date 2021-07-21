######################################################################
# Global variables for VPC, Subnet, Routes and Bastion Host          #
######################################################################
variable "default_region" {
  type        = string
  description = "AWS region to deploy resources"
}


#########################################################
# Default variables for backend and SSH key for Bastion #
#########################################################
variable "s3_bucket_prefix" {
  type        = string
  default     = "doubledigit-tfstate"
  description = "Prefix for s3 bucket"
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
  description = "Environment to be used"
}

variable "isMonitoring" {
  type        = bool
  description = "Monitoring is enabled or disabled for the resources creating"
}

variable "project" {
  type        = string
  description = "Monitoring is enabled or disabled for the resources creating"
}

variable "component" {
  type        = string
  description = "Component name for the resource"
}


#####=============Local variables===============#####
locals {
  common_tags = {
    Owner       = var.owner
    Team        = var.team
    Environment = var.environment
    Monitoring  = var.isMonitoring
    Project     = var.project
    Component   = var.component
  }
}

#####========================Cluster Autoscaler Config Variables====================#####
variable "enabled" {
  description = "A conditional indicator to enable cluster-autoscale"
  type        = bool
  default     = true
}

variable "helm" {
  description = "The helm release configuration"
  type        = map
  default = {
    name            = "cluster-autoscaler"
    chart           = "cluster-autoscaler"
    namespace       = "kube-system"
    service_account = "cluster-autoscaler"
    cleanup_on_fail = true
  }
}

variable "oidc_url" {
  description = "A URL of the OIDC Provider"
  type        = string
}

variable "oidc_arn" {
  description = "An ARN of the OIDC Provider"
  type        = string
}

variable "cluster_name" {
  description = "The kubernetes cluster name"
  type        = string
}
