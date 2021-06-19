default_region = "us-east-1"
project = "qa-admin"

sg_name = "dd-es-sg"
es_domain_name = "dd-logging-es"
elasticsearch_version = "7.7"
encryption_enabled = "true"
instance_type = "t3.small.elasticsearch"
instance_count = "2"
zone_awareness_enabled = true
volume_size = "10"
snapshot_start = 23
volume_type = "gp2"
indices_query_bool_max_clause_count = 1024
rest_action_multi_allow_explicit_index = "true"
ingress_allow_security_groups = []

team      = "DoubleDigit-Team"
project   = "DoubleDigit-Blogging"
component = "DoubleDigit-Logging"