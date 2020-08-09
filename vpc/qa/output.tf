output "vpc_id" {
  value = module.vpc-qa.vpc_id
}

output "private_subnets" {
  value = module.vpc-qa.private_subnets
}

output "private_cidrs" {
  value = module.vpc-qa.private_cirds
}

output "public_subnets" {
  value = module.vpc-qa.public_subnets
}

output "public_cirds" {
  value = module.vpc-qa.public_cidrs
}

output "db_subnets" {
  value = module.vpc-qa.db_subnets
}

output "db_cirds" {
  value = module.vpc-qa.db_cirds
}

output "private_rt" {
  value = module.vpc-qa.private_rt
}

output "public_rt" {
  value = module.vpc-qa.public_rt
}


output "bastion_sg" {
  value = module.vpc-qa.bastion_sg_id
}

output "vpc_cidr" {
  value = module.vpc-qa.vpc_cidr_block
}
