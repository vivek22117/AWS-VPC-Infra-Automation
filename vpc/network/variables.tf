######################################################
# Global variables for VPC and Bastion Host
######################################################
variable "profile" {
  type        = string
  description = "AWS Profile name for credentials"
}

variable "default_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "cidr_block" {
  type        = string
  description = "Cidr range for vpc"
}

variable "instance_tenancy" {
  type        = string
  description = "Type of instance tenancy required default/dedicated"
}

variable "enable_dns" {
  type        = string
  description = "To use private DNS within the VPC"
}

variable "support_dns" {
  type        = string
  description = "To use private DNS support within the VPC"
}

variable "private_azs_with_cidr" {
  type        = map(string)
  description = "Name of azs with cidr to be used for infrastructure"
}

variable "db_azs_with_cidr" {
  type        = map(string)
  description = "Name of azs with cidr to be used for Database infrastructure"
}

variable "public_azs_with_cidr" {
  type        = map(string)
  description = "Name of azs with cidr to be used for infrastructure"
}

variable "enable_nat_gateway" {
  type        = string
  description = "want to create nat-gateway or not"
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type for Bastion Host"
}

######################################################
# Local variables defined                            #
######################################################
variable "environment" {
  type        = string
  description = "Environment to be used valid values: 'dev', 'qa', 'prod'"
}

variable "team" {
  type        = string
  description = "Owner team for this applcation infrastructure"
}

variable "owner" {
  type        = string
  description = "Owner of the product"
}

variable "isMonitoring" {
  type        = bool
  description = "Monitoring is enabled or disabled for the resources creating"
}

variable "project" {
  type        = string
  description = "Monitoring is enabled or disabled for the resources creating"
}
#########################################################
# Default variables for backend and SSH key for Bastion #
#########################################################
variable "s3_bucket_prefix" {
  type        = string
  default     = "demo-tfstate"
  description = "Prefix for s3 bucket"
}

#####=============ASG Standards Tags===============#####
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default = {
    owner      = "vivek"
    team       = "Demo"
    tool       = "Terraform"
    monitoring = "true"
    Name       = "Bastion-Host"
    Project    = "Demo-Solutions"
  }
}
