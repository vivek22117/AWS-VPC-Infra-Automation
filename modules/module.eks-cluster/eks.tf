resource "aws_cloudwatch_log_group" "dd_eks_lg" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention
  tags              = merge(local.common_tags, map("Name", "${var.environment}-eks-lg"))
}

###########################################
#              EKS Cluster                #
###########################################
resource "aws_eks_cluster" "doubledigit_eks" {
  name                      = var.eks_cluster_name
  role_arn                  = aws_iam_role.eks_cluster_iam.arn
  enabled_cluster_log_types = var.enabled_log_types
  version                   = var.cluster_version

  tags = local.common_tags

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes_sg.id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    subnet_ids = flatten(
      [data.terraform_remote_state.eks_vpc.outputs.private_subnets,
    data.terraform_remote_state.eks_vpc.outputs.public_subnets])
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
    aws_iam_role_policy_attachment.aws_eks_service_policy,
    aws_cloudwatch_log_group.dd_eks_lg
  ]
}


data "tls_certificate" "eks_oidc_thumbprint" {
  url = aws_eks_cluster.doubledigit_eks.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  depends_on = [aws_eks_cluster.doubledigit_eks]

  url = aws_eks_cluster.doubledigit_eks.identity.0.oidc.0.issuer

  client_id_list = ["sts.amazonaws.com"]


  thumbprint_list = [data.tls_certificate.eks_oidc_thumbprint.certificates.0.sha1_fingerprint]
}
