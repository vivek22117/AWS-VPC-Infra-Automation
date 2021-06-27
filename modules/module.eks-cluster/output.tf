output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = aws_eks_cluster.doubledigit_eks.id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.doubledigit_eks.arn
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.doubledigit_eks.endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = aws_eks_cluster.doubledigit_eks.version
}

output "eks_cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = join("", aws_eks_cluster.doubledigit_eks.*.identity.0.oidc.0.issuer)
}

output "eks_cluster_identity_oidc_issuer_arn" {
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.doubledigit_eks.certificate_authority
}

output "eks_cluster_iam_role_arn" {
  value = aws_iam_role.eks_cluster_iam.arn
}

output "eks_cluster_worker_role_arn" {
  value = aws_iam_role.eks_nodes_role.arn
}

output "vpce_sg" {
  value = aws_security_group.vpce.id
}

output "ecs_task_sg" {
  value = aws_security_group.ecs_task.id
}

output "vpc_s3_endpoint" {
  value = aws_vpc_endpoint.s3_endpoint.id
}

output "vpc_logs_endpoint" {
  value = aws_vpc_endpoint.private_link_cw_logs.id
}