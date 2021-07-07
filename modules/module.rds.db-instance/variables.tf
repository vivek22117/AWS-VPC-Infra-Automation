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


#########################################################
#                 DB Resource Variables                 #
#########################################################
variable "sub_group_name" {
  type        = string
  description = "Subnet Group name for RDS DB"
}

variable "db_sg_name" {
  type        = string
  description = "Database security group name"
}

variable "instance_type" {
  type        = string
  description = "Instance type for database instance"
}

variable "storage_type" {
  type        = string
  description = "Type of underlying storage for database, gp2, io1"
}

variable "database_identifier" {
  type        = string
  description = "Identifier for RDS instance"
}

variable "database_name" {
  type        = string
  description = "Name of database inside storage engine"
}

variable "database_port" {
  type        = number
  description = "Port on which database will accept connections"
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to keep database backups"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  type        = string
  description = "30 minute time window to reserve for backups"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM ET
  type        = string
  description = "60 minute time window to reserve for maintenance"
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Minor engine upgrades are applied automatically to the DB instance during the maintenance window"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Flag to enable or disable a snapshot if the database instance is terminated"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Flag to enable or disable copying instance tags to the final snapshot"
}

variable "multi_availability_zone" {
  type        = bool
  description = "Flag to enable hot standby in another availability zone"
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB instance is encrypted"
}

variable "monitoring_interval" {
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
}

variable "deletion_protection" {
  type        = string
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false"
}

variable "cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of logs to publish to CloudWatch Logs"
}

variable "alarm_cpu_threshold" {
  type        = number
  description = "CPU alarm threshold as a percentage"
}

variable "alarm_disk_queue_threshold" {
  type        = number
  description = "Disk queue alarm threshold"
}

variable "alarm_free_disk_threshold" {
  # 5GB
  type        = number
  description = "Free disk alarm threshold in bytes"
}

variable "alarm_free_memory_threshold" {
  # 128MB
  type        = number
  description = "Free memory alarm threshold in bytes"
}

variable "sns_stack_name" {
  type        = string
  description = "Unique Cloudformation stack name that wraps the SNS topic."
}

variable "protocol" {
  type        = list(string)
  description = "SNS protocols to use"
}

variable "display_name" {
  type        = string
  description = "Name shown in confirmation emails"
}

variable "sns_topic_name" {
  type        = string
  description = "SNS topic name"
}

variable "sns_subscription_email_address_list" {
  type        = list(string)
  description = "List of email addresses"
}

######################################################
# Local variables defined                            #
######################################################
variable "team" {
  type        = string
  description = "Owner team for this application infrastructure"
}

variable "component" {
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

#####=============Local variables===============#####
locals {
  common_tags = {
    component   = var.component
    team        = var.team
    environment = var.environment
    monitoring  = var.isMonitoring
    Project     = var.project
  }
}