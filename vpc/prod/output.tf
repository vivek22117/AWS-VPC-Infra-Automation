output "vpc_id" {
  value = module.vpc-prod.vpc_id
}

output "private_subnets" {
  value = module.vpc-prod.private_subnets
}

output "private_cidrs" {
  value = module.vpc-prod.private_cirds
}

output "public_subnets" {
  value = module.vpc-prod.public_subnets
}

output "public_cirds" {
  value = module.vpc-prod.public_cidrs
}

output "bastion_sg" {
  value = module.vpc-prod.bastion_sg_id
}

output "vpc_cidr" {
  value = module.vpc-prod.vpc_cidr_block
}

