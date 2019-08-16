output "vpc_id" {
  value = module.vpc-dev.vpc_id
}

output "private_subnets" {
  value = module.vpc-dev.private_subnets
}

output "private_cidrs" {
  value = module.vpc-dev.private_cirds
}

output "public_subnets" {
  value = module.vpc-dev.public_subnets
}

output "public_cirds" {
  value = module.vpc-dev.public_cidrs
}

output "bastion_sg" {
  value = module.vpc-dev.bastion_sg_id
}

output "vpc_cidr" {
  value = module.vpc-dev.vpc_cidr_block
}
