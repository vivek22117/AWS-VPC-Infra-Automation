output "cloudtrail_id" {
  value       = module.vpc-cloudtrail.cloudtrail_id
  description = "The name of the Cloud-trail"
}

output "cloudtrail_region" {
  value       = module.vpc-cloudtrail.cloudtrail_region
  description = "The region in which the cloud-trail was deployed"
}

output "cloudtrail_arn" {
  value       = module.vpc-cloudtrail.cloudtrail_arn
  description = "The ARN of the cloud-trail"
}