variable "s3_bucket_stack_name" {
  type        = string
}

variable "bucket_name" {
  type        = string
}

variable "global_region" {
  type        = string
}

variable "role_arn" {
  type        = string
}

variable "common_tags" {
  type = map
}


variable "s3_bucket_with_replication_dst_region" {
  type        = list(string)
  default = ["us-east-1", "eu-central-1"]
}
