####################################################
#        EKS Container Insights configuration      #
####################################################
module "eks_container_insights" {
  source = "../../modules/module.eks-container-insights"

  component      = var.component
  environment    = var.environment
  default_region = var.default_region
  isMonitoring   = var.isMonitoring
  project        = var.project
  owner          = var.owner
  team           = var.team

  enabled         = var.enabled
  oidc_arn        = var.oidc_arn
  oidc_url        = var.oidc_url

  helm = var.helm
  cluster_name = var.cluster_name
}
