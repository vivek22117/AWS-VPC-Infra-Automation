default_region = "us-east-1"

team         = "DoubleDigitTeam"
owner        = "Vivek"
isMonitoring  = true
project     = "Demo-Solutions"
component = "Managed-EKS-ContainerInsights"

enabled = true
oidc_url = ""
oidc_arn = ""

helm = {
  name            = "cluster-autoscaler"
  chart           = "cluster-autoscaler"
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  cleanup_on_fail = true
}

cluster_name = ""

