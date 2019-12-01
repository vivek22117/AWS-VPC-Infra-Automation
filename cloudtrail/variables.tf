######################################################################
# Global variables for CloudTrail Configuration                      #
######################################################################
variable "profile" {
  type        = "string"
  description = "AWS Profile name for credentials"
}

variable "enable_log_file_validation" {
  type        = bool
  description = "Specifies whether log file integrity validation is enabled"
}

variable "is_multi_region_trail" {
  type        = bool
  description = "Specifies whether the trail is created in the current region or in all regions"
}

variable "include_global_service_events" {
  type        = bool
  description = "Specifies whether the trail is publishing events from global services such as IAM to the log files"
}

variable "enable_logging" {
  type        = bool
  description = "Enable logging for the trail"
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name for CloudTrail logs"
}

variable "s3_key_prefix" {
  type        = string
  default     = ""
  description = "S3 bucket prefix for aws cloud trail"
}

variable "event_selector" {
  type = list(object({
    include_management_events = string
    read_write_type           = string

    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))

  description = "Specifies an event selector for enabling data event logging"
}

variable "is_organization_trail" {
  type        = bool
  description = "The trail is an AWS Organizations trail"
}

######################################################
# Variables for S3 Configuration                     #
######################################################
variable "region" {
  type        = string
  description = "Name of the region where the Trail should be created."
}

variable "s3_bucket_days_to_expiration" {
  type        = number
  description = "How many days to store logs before they will be deleted. Only applies if `enable_s3_bucket_expiration` is true."
}

variable "enable_s3_lifecycle" {
  type        = bool
  description = "Specifies whether to enable S3 lifecycle"
}

variable "s3_bucket_days_to_transition" {
  type        = number
  description = "How many days to store logs before they will be transitioned to a new storage class. Only applies if `enable_s3_bucket_transition` is true."
}

variable "s3_bucket_transition_storage_class" {
  type        = string
  description = "Specifies the S3 storage class to which logs will transition for archival. Only applies if `enable_s3_bucket_transition` is true."
}

variable "metric_name_space" {
  type        = string
  description = "Name to the cloudwatch metric space"
}

######################################################
# Local variables defined                            #
######################################################
variable "team" {
  type        = "string"
  description = "Owner team for this applcation infrastructure"
}

variable "owner" {
  type        = "string"
  description = "Owner of the product"
}

variable "environment" {
  type        = "string"
  description = "Environmet to be used"
}
