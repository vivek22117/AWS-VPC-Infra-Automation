output "artifactory_s3_arn" {
  value = module.s3_resources.artifactory_s3_arn
}

output "logging_s3_arn" {
  value = module.s3_resources.logging_s3_arn
}

output "datalake_s3_arn" {
  value = module.s3_resources.datalake_s3_arn
}

output "artifactory_s3_name" {
  value = module.s3_resources.artifactory_s3_name
}

output "logging_s3_name" {
  value = module.s3_resources.logging_s3_name
}

output "datalake_s3_name" {
  value = module.s3_resources.datalake_s3_name
}

output "eks_bastion_key_name" {
  value = module.s3_resources.eks_bastion_key_name
}

output "eks_node_key_name" {
  value = module.s3_resources.eks_node_key_name
}