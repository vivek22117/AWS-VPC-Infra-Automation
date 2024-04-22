####################################################
#        QA Elastic Search Cluster TF              #
####################################################
module "demo-logging-es" {
  source = "../../modules/module-elk-stack"

  environment    = var.environment
  default_region = var.default_region

  volume_type                            = var.volume_type
  indices_query_bool_max_clause_count    = var.indices_query_bool_max_clause_count
  rest_action_multi_allow_explicit_index = var.rest_action_multi_allow_explicit_index
  ingress_allow_security_groups          = var.ingress_allow_security_groups
  sg_name                                = var.sg_name
  es_domain_name                         = var.es_domain_name
  elasticsearch_version                  = var.elasticsearch_version
  encryption_enabled                     = var.encryption_enabled
  instance_type                          = var.instance_type
  instance_count                         = var.instance_count
  zone_awareness_enabled                 = var.zone_awareness_enabled
  volume_size                            = var.volume_size
  snapshot_start                         = var.snapshot_start


  team      = var.team
  component = var.component
  project   = var.project

}
