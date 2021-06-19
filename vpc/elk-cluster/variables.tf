#####===================Global Variables====================#####
variable "default_region" {
  type        = string
  description = "AWS region to provision"
}

#################################
#  Default Variables            #
#################################
variable "s3_bucket_prefix" {
  type        = string
  description = "S3 TF state bucket prefix"
  default     = "doubledigit-tfstate"
}

variable "volume_type" {
  description = "Default type of the EBS volumes."
  type        = string
}

variable "indices_query_bool_max_clause_count" {
  description = "Maximum number of clauses allowed in a Lucene boolean query."
  type        = string
}

variable "rest_action_multi_allow_explicit_index" {
  description = "Specifies whether explicit references to indices are allowed inside the body of HTTP requests."
  type        = string
}

variable "ingress_allow_security_groups" {
  default     = []
  description = "Specifies the ingress security groups allowed."
  type        = list(string)
}

#####======================Resource Variables====================#####
variable "sg_name" {
  type        = string
  description = "Name of the ES security group"
}

variable "es_domain_name" {
  type        = string
  description = "ES domain name"
}

variable "elasticsearch_version" {
  description = "Elastic Search Service cluster version number."
  type        = string
}

variable "encryption_enabled" {
  description = "Enable encryption in Elastic Search."
  type        = string
}

variable "instance_type" {
  description = "Elastic Search Service cluster Ec2 instance type."
  type        = string
}

variable "instance_count" {
  description = "Elastic Search Service cluster Ec2 instance number."
  type        = string
}

variable "zone_awareness_enabled" {
  description = "Indicates whether zone awareness is enabled."
  type        = bool
}

variable "volume_size" {
  description = "Default size of the EBS volumes."
  type        = string
}

variable "snapshot_start" {
  description = "Elastic Search Service maintenance/snapshot start time."
  type        = number
}

######################################################
# Local variables defined                            #
######################################################
variable "team" {
  type        = string
  description = "Owner team for this application infrastructure"
}

variable "environment" {
  type        = string
  description = "Environment to be used"
}

variable "component" {
  type        = string
  description = "Monitoring is enabled or disabled for the resources creating"
}

variable "project" {
  type        = string
  description = "Monitoring is enabled or disabled for the resources creating"
}

#####=============Local variables===============#####
locals {
  common_tags = {
    team        = var.team
    environment = var.environment
    component   = var.component
    Project     = var.project
  }
}