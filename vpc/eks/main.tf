####################################################
#        Dev EKS-VPC module configuration          #
####################################################
module "eks-vpc" {
  source = "../../modules/module.eks-cluster"

//  Used only while running in local
  profile        = var.profile


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

  ec2_ssh_key = var.ec2_ssh_key
  launch_template = var.launch_template

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  eks_cluster_name        = var.eks_cluster_name
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access
  pvt_node_group_name     = var.pvt_node_group_name
  pub_node_group_name     = var.pub_node_group_name
  ami_type                = var.ami_type
  disk_size               = var.disk_size
  instance_types          = var.instance_types
  pvt_desired_size        = var.pvt_desired_size
  pvt_max_size            = var.pvt_max_size
  pvt_min_size            = var.pvt_min_size
  public_desired_size     = var.public_desired_size
  public_max_size         = var.public_max_size
  public_min_size         = var.public_min_size
  log_retention           = var.log_retention
  enabled_log_types       = var.enabled_log_types

  eks-iam-group = var.eks-iam-group
  configmap_auth_template_file = var.configmap_auth_template_file
  configmap_auth_file = var.configmap_auth_file
  apply_config_map_aws_auth = var.apply_config_map_aws_auth
  local_exec_interpreter = var.local_exec_interpreter

  map_additional_iam_roles = var.map_additional_iam_roles
  map_additional_iam_users = var.map_additional_iam_users

}
