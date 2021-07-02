####################################################
#        Dev EKS-VPC module configuration          #
####################################################
module "eks-vpc" {
  source = "../../modules/module.eks-access-config"

  environment    = var.environment
  default_region = var.default_region


  eks_bastion_name_prefix = var.eks_bastion_name_prefix
  bastion_instance_type   = var.bastion_instance_type
  default_cooldown        = var.default_cooldown


}
