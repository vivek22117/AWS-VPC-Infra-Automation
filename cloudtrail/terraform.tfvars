profile = "admin"

enable_log_file_validation    = true
include_global_service_events = true
is_multi_region_trail         = false

enable_logging        = true
log_retention         = 1
s3_bucket_name        = "ddsolutions-cloudtrail"
is_organization_trail = false

region                             = "us-east-1"
s3_bucket_days_to_expiration       = 70
enable_s3_lifecycle                = true
s3_bucket_days_to_transition       = 60
s3_bucket_transition_storage_class = "ONEZONE_IA"
s3_key_prefix                      = "doubledigit-cloudtrail"
metric_name_space                  = "CloudTrailMetrics"

team        = "DoubleDigitSolutions"
owner       = "Vivek"
environment = "dev"

event_selector = [
  {
    include_management_events = "true"
    read_write_type           = "All"
    data_resource = [
      {
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      },
      {
        type   = "AWS::Lambda::Function"
        values = ["arn:aws:lambda"]
      }
    ]
  }
]