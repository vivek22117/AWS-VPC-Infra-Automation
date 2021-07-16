default_region = "us-east-1"

team         = "DoubleDigitTeam"
owner        = "Vivek"
isMonitoring  = true
project     = "DoubleDigit-Solutions"
component = "Managed-EKS-ContainerInsights"

enabled = true
oidc_url = ""
oidc_arn = ""
helm = {
  repository      = "https://aws.github.io/eks-charts"
  cleanup_on_fail = true
}

cluster_name = ""

