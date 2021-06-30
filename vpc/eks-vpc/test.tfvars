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


team         = "DoubleDigitTeam"
owner        = "Vivek"
isMonitoring = true

cluster_name = "DD-EKS"
