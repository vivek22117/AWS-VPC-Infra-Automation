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

output "eks_cluster_identity_oidc_url" {
  value = module.eks-vpc.eks_cluster_identity_oidc_url
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

output "eks_cluster_austoscaling_policy_arn" {
  value = module.eks-vpc.eks_cluster_austoscaling_policy_arn
}


output "eks_vpc_config" {
  value = module.eks-vpc.eks_vpc_config
}

output "eks_cluster_sg_id" {
  value = module.eks-vpc.eks_cluster_sg_id
}
