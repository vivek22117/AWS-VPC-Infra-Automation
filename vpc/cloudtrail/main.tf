####################################################
#        Dev VPC module configuration              #
####################################################
module "vpc-cloudtrail" {
  source = "../../modules/module.cloudTrail"

  profile        = var.profile
  environment    = var.environment
  default_region = var.default_region

  enable_log_file_validation    = var.enable_log_file_validation
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  enable_logging                = var.enable_logging
  log_retention                 = var.log_retention
  is_organization_trail         = var.is_organization_trail

  s3_key_prefix                      = var.s3_key_prefix
  s3_bucket_days_to_expiration       = var.s3_bucket_days_to_expiration
  enable_s3_lifecycle                = var.enable_s3_lifecycle
  s3_bucket_days_to_transition       = var.s3_bucket_days_to_transition
  s3_bucket_transition_storage_class = var.s3_bucket_transition_storage_class
  bucket_acl                         = var.bucket_acl

  metric_name_space = var.metric_name_space

  event_selector = var.event_selector

  cloudtrail_bucket_name = var.cloudtrail_bucket_name

  owner = var.owner
  team  = var.team

}
