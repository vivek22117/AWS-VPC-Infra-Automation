resource "random_string" "autoscaler_suffix" {
  count   = var.enabled ? 1 : 0
  length  = 5
  upper   = false
  lower   = true
  number  = false
  special = false
}


locals {
  suffix = var.enabled ? random_string.autoscaler_suffix.0.result : ""
  name   = join("-", compact([var.cluster_name, "cluster-autoscaler", local.suffix]))

  namespace      = lookup(var.helm, "namespace", "kube-system")
  service_account = lookup(var.helm, "service_account", "cluster-autoscaler")

  oidc_principal = var.oidc_arn == "" ?
  data.terraform_remote_state.eks_cluster.outputs.eks_cluster_identity_oidc_issuer_arn : var.oidc_arn

  oidc_url = var.oidc_url == "" ? data.terraform_remote_state.eks_cluster.outputs.eks_cluster_identity_oidc_url : var.oidc_url
}

module "cluster_autoscaler_irsa" {
  source         = "../module.eks-irsa"

  count          = var.enabled ? 1 : 0

  name           = join("-", ["irsa", local.name])
  namespace      = local.namespace
  service_account = local.service_account
  oidc_url       = local.oidc_url
  oidc_arn       = local.oidc_principal
  policy_arns    = [data.terraform_remote_state.eks_cluster.outputs.eks_cluster_austoscaling_policy_arn]

  enabled = var.enabled
  component = var.component
  default_region = var.default_region
  environment = var.environment
  isMonitoring = var.isMonitoring
  owner = var.owner
  project = var.project
  team = var.team
}


resource "helm_release" "cluster_autoscaler" {
  count            = var.enabled ? 1 : 0

  name             = lookup(var.helm, "name", "cluster-autoscaler")
  chart            = lookup(var.helm, "chart", "cluster-autoscaler")
  version          = lookup(var.helm, "version", null)
  repository       = lookup(var.helm, "repository", join("/", [path.module, "charts"]))
  namespace        = local.namespace
  create_namespace = true
  cleanup_on_fail  = lookup(var.helm, "cleanup_on_fail", true)

  dynamic "set" {
    for_each = {
      "autoDiscovery.clusterName"                                 = var.cluster_name
      "serviceAccount.name"                                       = local.service_account
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.cluster_autoscaler_irsa[0].arn[0]
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}