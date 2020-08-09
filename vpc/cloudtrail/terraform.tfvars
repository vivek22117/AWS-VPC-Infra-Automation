profile        = "admin"
default_region = "us-east-1"

enable_log_file_validation    = true
is_multi_region_trail         = true
include_global_service_events = true
enable_logging                = true
is_organization_trail         = false

log_retention = 3

cloudtrail_bucket_name             = "doubledigit-cloudtrail"
s3_key_prefix                      = "audit"
s3_bucket_days_to_expiration       = 60
enable_s3_lifecycle                = true
s3_bucket_days_to_transition       = 30
s3_bucket_transition_storage_class = "ONEZONE_IA"
bucket_acl                         = "private"

event_selector = [{ include_management_events : true, read_write_type : "All", data_resource : [{ type : "AWS::S3::Object", values : ["arn:aws:s3:::"] }] },
{ include_management_events : true, read_write_type : "All", data_resource : [{ type : "AWS::Lambda::Function", values : ["arn:aws:lambda"] }] }]

metric_name_space = "doubledigit-cloudtrail"

team  = "DoubleDigitTeam"
owner = "Vivek"