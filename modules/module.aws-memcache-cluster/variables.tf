#########################################################
# Default variables for backend and SSH key for Bastion #
#########################################################
variable "s3_bucket_prefix" {
  type        = string
  default     = "doubledigit-tfstate"
  description = "Prefix for s3 bucket"
}

variable "default_region" {
  type        = string
  description = "AWS region to deploy resources"
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

#####=============================Subnet Group Config Variables============================#####
variable "subnet_ids" {
  default     = []
  description = "List of VPC Subnet IDs for the cache subnet group."
  sensitive   = true
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "Description for the cache subnet group. Defaults to `Managed by Terraform`."
}

#####================================================Config Variables==========================#####
variable "enable" {
  type        = bool
  default     = true
  description = "Enable or disable of elasticache"
}

variable "cluster_id" {
  type = string
  description = "memcache cluster ID"
}

variable "engine" {
  default     = ""
  description = "The name of the cache engine to be used for the clusters in this replication group. e.g. redis, memcached"
}

variable "engine_version" {
  default     = ""
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "port" {
  default     = ""
  description = "the port number on which each of the cache nodes will accept connections. 11211"
  sensitive   = true
}

variable "node_type" {
  default     = "cache.t2.small"
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "security_group_ids" {
  default     = []
  description = "One or more VPC security groups associated with the cache cluster."
  sensitive   = true
}

variable "security_group_names" {
  default     = null
  description = "A list of cache security group names to associate with this replication group."
}

variable "snapshot_arns" {
  default     = null
  description = "A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3."
}

variable "snapshot_name" {
  default     = ""
  description = "The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
  sensitive   = true
}

variable "snapshot_window" {
  default     = null
  description = "(Redis only) The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period."
}

variable "snapshot_retention_limit" {
  default     = "0"
  description = "(Redis only) The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes."
}

variable "notification_topic_arn" {
  default     = ""
  description = "An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to."
  sensitive   = true
}

variable "apply_immediately" {
  default     = false
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important."
}

variable "maintenance_window" {
  default     = "sun:05:00-sun:06:00"
  description = "Maintenance window."
}


variable "cluster_enabled" {
  type        = bool
  default     = false
  description = "(Memcache only) Enabled or disabled cluster."
}

variable "num_cache_nodes" {
  default     = 2
  description = "(Required unless replication_group_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcache, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed."
}

variable "az_mode" {
  default     = "cross-az"
  description = "(Memcached only) Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num_cache_nodes must be greater than 1."
}

variable "parameter_group_name" {
  type        = string
  default     = "default.redis5.0"
  description = "The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used."
}
