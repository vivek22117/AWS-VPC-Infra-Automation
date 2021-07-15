resource "random_string" "container_insights_suffix" {
  count   = var.enabled ? 1 : 0

  length  = 5
  upper   = false
  lower   = true
  number  = false
  special = false
}

data "aws_region" "current" {
  count = var.enabled ? 1 : 0
}


locals {
  suffix = var.petname && var.enabled ? random_string.container_insights_suffix.0.result : ""
  cluster_name = var.cluster_name == "" ? data.terraform_remote_state.eks_cluster.outputs.eks_cluster_id : var.cluster_name

  oidc_principal = var.oidc_arn == "" ?
  data.terraform_remote_state.eks_cluster.outputs.eks_cluster_identity_oidc_issuer_arn : var.oidc_arn

  oidc_url = var.oidc_url == "" ? data.terraform_remote_state.eks_cluster.outputs.eks_cluster_identity_oidc_url : var.oidc_url
}


module "irsa-metrics" {
  source         = "../module.eks-irsa"

  count          = var.enabled ? 1 : 0

  name           = join("-", compact(["irsa", local.cluster_name, "amazon-cloudwatch", local.suffix]))
  namespace      = "amazon-cloudwatch"
  service_account = "amazon-cloudwatch"
  oidc_url       = local.oidc_url
  oidc_arn       = local.oidc_principal
  policy_arns    = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]

  enabled = var.enabled
  component = var.component
  default_region = var.default_region
  environment = var.environment
  isMonitoring = var.isMonitoring
  owner = var.owner
  project = var.project
  team = var.team
}

resource "helm_release" "metrics" {
  count            = var.enabled ? 1 : 0

  name             = "aws-cloudwatch-metrics"
  chart            = "aws-cloudwatch-metrics"
  version          = lookup(var.helm, "version", null)
  repository       = lookup(var.helm, "repository", "https://aws.github.io/eks-charts")
  namespace        = "amazon-cloudwatch"
  create_namespace = true
  cleanup_on_fail  = lookup(var.helm, "cleanup_on_fail", true)

  dynamic "set" {
    for_each = {
      "clusterName"                                               = local.cluster_name
      "serviceAccount.name"                                       = "amazon-cloudwatch"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa-metrics[0].arn[0]
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}

module "irsa-logs" {
  source         = "../module.eks-irsa"

  count          = var.enabled ? 1 : 0

  name           = join("-", compact(["irsa", local.cluster_name, "aws-for-fluent-bit", local.suffix]))
  namespace      = "kube-system"
  service_account = "aws-for-fluent-bit"
  oidc_url       = local.oidc_url
  oidc_arn       = local.oidc_principal
  policy_arns    = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]

  enabled = var.enabled
  component = var.component
  default_region = var.default_region
  environment = var.environment
  isMonitoring = var.isMonitoring
  owner = var.owner
  project = var.project
  team = var.team
}

resource "helm_release" "logs" {
  count           = var.enabled ? 1 : 0

  name            = "aws-for-fluent-bit"
  chart           = "aws-for-fluent-bit"
  version         = lookup(var.helm, "version", null)
  repository      = lookup(var.helm, "repository", "https://aws.github.io/eks-charts")
  namespace       = "kube-system"
  cleanup_on_fail = lookup(var.helm, "cleanup_on_fail", true)

  dynamic "set" {
    for_each = {
      "cloudWatch.enabled"                                        = true
      "cloudWatch.region"                                         = data.aws_region.current.0.name
      "cloudWatch.logGroupName"                                   = format("/aws/containerinsights/%s/application", var.cluster_name)
      "firehose.enabled"                                          = false
      "kinesis.enabled"                                           = false
      "elasticsearch.enabled"                                     = false
      "serviceAccount.name"                                       = "aws-for-fluent-bit"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa-logs[0].arn[0]
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}