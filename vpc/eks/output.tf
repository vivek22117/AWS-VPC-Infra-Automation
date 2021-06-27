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

output "bastion_sg_id" {
  value = module.eks-vpc.bastion_sg_id
}

output "vpc_cidr_block" {
  value = module.eks-vpc.vpc_cidr_block
}

output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks-vpc.eks_cluster_id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks-vpc.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  value = module.eks-vpc.eks_cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.eks-vpc.eks_cluster_version
}

output "eks_cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = module.eks-vpc.eks_cluster_identity_oidc_issuer
}

output "eks_cluster_identity_oidc_issuer_arn" {
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
  value       = module.eks-vpc.eks_cluster_identity_oidc_issuer_arn
}


output "eks_cluster_iam_role_arn" {
  value = module.eks-vpc.eks_cluster_iam_role_arn
}

output "eks_cluster_worker_role_arn" {
  value = module.eks-vpc.eks_cluster_worker_role_arn
}

output "eks_cluster_certificate_authority" {
  value = module.eks-vpc.eks_cluster_certificate_authority
}