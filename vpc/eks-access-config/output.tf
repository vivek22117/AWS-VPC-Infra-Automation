output "eks_cluster_certificate_authority_data" {
  description = "The Kubernetes cluster certificate authority data"
  value       = module.eks_access_infra.eks_cluster_certificate_authority_data
}

output "eks_read_only_role_arn" {
  value = module.eks_access_infra.eks_read_only_role_arn
}

output "eks_full_access_role" {
  value = module.eks_access_infra.eks_full_access_role
}

output "eks_user_management_group" {
  value = module.eks_access_infra.eks_user_management_group
}
