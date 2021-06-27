output "vpc_id" {
  value = module.eks-vpc.vpc_id
}

output "eip_ngw" {
  value = module.eks-vpc.eip_ngw
}

output "private_subnets" {
  value = module.eks-vpc.private_subnets
}

output "private_cidrs" {
  value = module.eks-vpc.private_cirds
}

output "public_subnets" {
  value = module.eks-vpc.public_subnets
}

output "public_cirds" {
  value = module.eks-vpc.public_cidrs
}

output "db_subnets" {
  value = module.eks-vpc.db_subnets
}

output "db_cirds" {
  value = module.eks-vpc.db_cirds
}

output "private_rt" {
  value = module.eks-vpc.private_rt
}

output "public_rt" {
  value = module.eks-vpc.public_rt
}


output "vpc_cidr_block" {
  value = module.eks-vpc.vpc_cidr_block
}
