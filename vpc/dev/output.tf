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

output "db_subnets" {
  value = module.vpc-dev.db_subnets
}

output "db_cirds" {
  value = module.vpc-dev.db_cirds
}

output "private_rt" {
  value = module.vpc-dev.private_rt
}

output "public_rt" {
  value = module.vpc-dev.public_rt
}

output "vpce_sg" {
  value = module.vpc-dev.vpce_sg
}

output "ecs_task_sg" {
  value = module.vpc-dev.ecs_task_sg
}

output "bastion_sg" {
  value = module.vpc-dev.bastion_sg_id
}

output "vpc_cidr" {
  value = module.vpc-dev.vpc_cidr_block
}
