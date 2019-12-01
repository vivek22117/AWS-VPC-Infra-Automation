####################################################
#       VPC CloudTrail Configuration               #
####################################################
module "vpc-cloudtrail" {
  source = "../modules/module.cloudTrail"

  profile     = var.profile
  environment = var.environment

  enable_logging                = var.enable_logging
  enable_log_file_validation    = var.enable_log_file_validation
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  is_organization_trail         = var.is_organization_trail

  region            = var.region
  s3_bucket_name    = var.s3_bucket_name
  s3_key_prefix     = var.s3_key_prefix
  metric_name_space = var.metric_name_space


  s3_bucket_days_to_expiration       = var.s3_bucket_days_to_expiration
  enable_s3_lifecycle                = var.enable_s3_lifecycle
  s3_bucket_days_to_transition       = var.s3_bucket_days_to_transition
  s3_bucket_transition_storage_class = var.s3_bucket_transition_storage_class

  event_selector = var.event_selector

  team  = var.team
  owner = var.owner
}
