default_region = "us-east-1"

cidr_block         = "10.11.0.0/20"
instance_tenancy   = "default"
enable_dns         = "true"
support_dns        = "true"
enable_nat_gateway = true
db_subnet_gp       = "eks-dbsubnet-group"

private_azs_with_cidr = {
  us-east-1a = "10.11.0.0/24"
  us-east-1b = "10.11.2.0/24"
  us-east-1c = "10.11.4.0/24"
}

public_azs_with_cidr = {
  us-east-1a = "10.11.1.0/24"
  us-east-1b = "10.11.3.0/24"
  us-east-1c = "10.11.5.0/24"
}

db_azs_with_cidr = {
  us-east-1a = "10.11.6.0/24"
  us-east-1b = "10.11.7.0/24"
  us-east-1c = "10.11.8.0/24"
}


team                  = "DoubleDigitTeam"
owner                 = "Vivek"
isMonitoring          = true

cluster_version         = "1.17"
cluster_name            = "DD-EKS"
eks_cluster_name        = "DD-EKS"
endpoint_private_access = true
endpoint_public_access  = true
pvt_node_group_name     = "Private-DD-NodeGroup-11"
pub_node_group_name     = "Public-DD-NodeGroup-11"
ami_type                = "AL2_x86_64"
disk_size               = 30
instance_types          = ["t3.medium"]
pvt_desired_size        = 1
pvt_max_size            = 2
pvt_min_size            = 1
public_desired_size     = 1
public_max_size         = 2
public_min_size         = 1

log_retention     = 3
enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

//configmap_auth_template_file = ""
//configmap_auth_file = ""
//apply_config_map_aws_auth = true
//local_exec_interpreter = "/bin/bash"
//eks-iam-group = "eks-developers"
