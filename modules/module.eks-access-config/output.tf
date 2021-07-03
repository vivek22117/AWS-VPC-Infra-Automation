output "eks_cluster_certificate_authority_data" {
  description = "The Kubernetes cluster certificate authority data"
  value       = local.certificate_authority_data
}

output "eks_read_only_role_arn" {
  value = aws_iam_role.eks_read_role.arn
}

output "eks_full_access_role" {
  value = aws_iam_role.eks_full_access_role.arn
}

output "eks_user_management_group" {
  value = aws_iam_group.eks_access_group.name
}
