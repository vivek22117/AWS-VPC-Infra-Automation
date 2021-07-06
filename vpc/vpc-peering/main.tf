####################################################
#        VPC Peering Resources Module              #
####################################################
module "vpc_peering" {
  source = "../../modules/module-vpc-peering"

  profile = var.profile
  default_region = var.default_region

  team = var.team
  owner = var.owner
  environment = var.environment

}