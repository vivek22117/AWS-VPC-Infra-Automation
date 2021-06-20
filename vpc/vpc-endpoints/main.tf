####################################################
#        VPC Other Resources Module                #
####################################################
module "vpc_other_resources" {
  source = "../../modules/module.vpc-resources"

//  Only used while local run
  profile        = var.profile


  default_region = var.default_region

  team        = var.team
  owner       = var.owner
  environment = var.environment
}