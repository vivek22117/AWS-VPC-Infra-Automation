####################################################
#        EKS Access Infra module configuration     #
####################################################
module "eks_irsa" {
  source = "../../modules/module.eks-irsa"


  component = ""
  default_region = ""
  enabled = false
  environment = ""
  isMonitoring = false
  namespace = ""
  oidc_arn = ""
  oidc_url = ""
  owner = ""
  project = ""
  service_account = ""
  team = ""
}
