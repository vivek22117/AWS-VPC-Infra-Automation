####################################################
#        Dev EKS-VPC module configuration          #
####################################################
module "eks-vpc" {
  source = "../../modules/module.eks-vpc"

  environment    = var.environment
  default_region = var.default_region

  db_subnet_gp          = var.db_subnet_gp
  cidr_block            = var.cidr_block
  private_azs_with_cidr = var.private_azs_with_cidr
  public_azs_with_cidr  = var.public_azs_with_cidr
  db_azs_with_cidr      = var.db_azs_with_cidr
  instance_tenancy      = var.instance_tenancy
  enable_dns            = var.enable_dns
  support_dns           = var.support_dns
  enable_nat_gateway    = var.enable_nat_gateway

  team         = var.team
  owner        = var.owner
  isMonitoring = var.isMonitoring


  cluster_name = var.cluster_name
}
