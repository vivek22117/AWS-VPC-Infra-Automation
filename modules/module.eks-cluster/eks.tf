#####=============Local variables===============#####
locals {
  common_tags = var.common_tags
  eks_subnets = length(var.subnets) > 0 ? var.subnets : flatten([data.terraform_remote_state.eks_vpc.outputs.private_subnets,
    data.terraform_remote_state.eks_vpc.outputs.public_subnets])
}

resource "aws_cloudwatch_log_group" "dd_eks_lg" {
  count             = length(var.enabled_log_types) > 0 ? 1 : 0

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention
  kms_key_id        = var.cluster_log_kms_key_id
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

  kubernetes_network_config = {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  timeouts {
    create = var.eks_cluster_create_timeout
    delete = var.eks_cluster_delete_timeout
  }

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes_sg.id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    subnet_ids = local.eks_subnets
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  dynamic "encryption_config" {
    for_each = length(var.cluster_encryption_resources) > 0 ? [true]: []

    content {
      provider {
        key_arn = aws_kms_key.eks_cluster_key.arn
      }
      resources = var.cluster_encryption_resources
    }
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_security_group.eks_cluster,
    aws_security_group_rule.eks_cluster_inbound_bastion,
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
    aws_iam_role_policy_attachment.aws_eks_service_policy,
    aws_cloudwatch_log_group.dd_eks_lg
  ]
}


data "tls_certificate" "eks_oidc_thumbprint" {
  url = aws_eks_cluster.doubledigit_eks.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  depends_on = [aws_eks_cluster.doubledigit_eks]

  url = aws_eks_cluster.doubledigit_eks.identity.0.oidc.0.issuer

  client_id_list = ["sts.amazonaws.com"]


  thumbprint_list = [data.tls_certificate.eks_oidc_thumbprint.certificates.0.sha1_fingerprint]

  tags = merge(local.common_tags, map("Name", "${var.environment}-eks-irsa"))
}
