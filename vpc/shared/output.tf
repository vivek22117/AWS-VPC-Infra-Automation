output "vpc_id" {
  value = module.vpc-shared.vpc_id
}

output "private_subnets" {
  value = module.vpc-shared.private_subnets
}

output "private_cidrs" {
  value = module.vpc-shared.private_cirds
}

output "public_subnets" {
  value = module.vpc-shared.public_subnets
}

output "public_cirds" {
  value = module.vpc-shared.public_cidrs
}

output "bastion_sg" {
  value = module.vpc-shared.bastion_sg_id
}

output "vpc_cidr" {
  value = module.vpc-shared.vpc_cidr_block
}

