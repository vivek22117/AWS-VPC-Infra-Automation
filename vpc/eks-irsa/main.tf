####################################################
#        EKS Access Infra module configuration     #
####################################################
module "eks_irsa" {
  source = "../../modules/module.eks-irsa"

  component      = var.component
  environment    = var.environment
  default_region = var.default_region
  isMonitoring   = var.isMonitoring
  project        = var.project
  owner          = var.owner
  team           = var.team

  enabled         = var.enabled
  namespace       = var.namespace
  oidc_arn        = var.oidc_arn
  oidc_url        = var.oidc_url
  service_account = var.service_account
}
