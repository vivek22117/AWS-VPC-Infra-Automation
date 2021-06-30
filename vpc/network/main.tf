####################################################
#        QA VPC moudle configuration              #
####################################################
module "vpc-test" {
  source = "../../modules/module.vpc"

  //  Not used via pipeline
  profile = var.profile

  environment    = var.environment
  default_region = var.default_region

  cidr_block            = var.cidr_block
  private_azs_with_cidr = var.private_azs_with_cidr
  public_azs_with_cidr  = var.public_azs_with_cidr
  db_azs_with_cidr      = var.db_azs_with_cidr
  instance_tenancy      = var.instance_tenancy
  enable_dns            = var.enable_dns
  support_dns           = var.support_dns
  enable_nat_gateway    = var.enable_nat_gateway

  artifactory_bucket_prefix = var.artifactory_bucket_prefix
  logging_bucket_prefix     = var.logging_bucket_prefix
  dataLake_bucket_prefix    = var.dataLake_bucket_prefix

  team         = var.team
  owner        = var.owner
  isMonitoring = var.isMonitoring
  project      = var.project

  bastion_instance_type = var.bastion_instance_type
}
