output "vpc_id" {
  value = module.vpc-test.vpc_id
}

output "private_subnets" {
  value = module.vpc-test.private_subnets
}

output "private_cidrs" {
  value = module.vpc-test.private_cirds
}

output "public_subnets" {
  value = module.vpc-test.public_subnets
}

output "public_cirds" {
  value = module.vpc-test.public_cidrs
}

output "db_subnets" {
  value = module.vpc-test.db_subnets
}

output "db_cirds" {
  value = module.vpc-test.db_cirds
}

output "private_rt" {
  value = module.vpc-test.private_rt
}

output "public_rt" {
  value = module.vpc-test.public_rt
}


output "bastion_sg" {
  value = module.vpc-test.bastion_sg_id
}

output "vpc_cidr" {
  value = module.vpc-test.vpc_cidr_block
}

output "artifactory_s3_arn" {
  value = module.vpc-test.artifactory_s3_arn
}

output "logging_s3_arn" {
  value = module.vpc-test.logging_s3_arn
}

output "datalake_s3_arn" {
  value = module.vpc-test.datalake_s3_arn
}

output "artifactory_s3_name" {
  value = module.vpc-test.artifactory_s3_name
}

output "logging_s3_name" {
  value = module.vpc-test.logging_s3_name
}

output "datalake_s3_name" {
  value = module.vpc-test.datalake_s3_name
}
