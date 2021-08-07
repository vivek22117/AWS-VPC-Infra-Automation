#################################################
#       Cache Cluster Security Group            #
#################################################
resource "aws_security_group" "memcache_cluster_sg" {
  count = var.enable ? 1 : 0

  name        = "memcache-sg-${var.environment}"
  description = "Cluster communication with EC2"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(local.common_tags, map("Name", "Memcache-SG-${var.environment}"))
}

resource "aws_security_group_rule" "memcache_cluster_inbound" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.memcache_cluster_sg.id
  cidr_blocks  = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
}

resource "aws_security_group_rule" "memcache_cluster_outgoing_traffic" {
  type                     = "egress"
  description              = "Allow outgoing traffic"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.memcache_cluster_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}



resource "aws_elasticache_subnet_group" "default" {
  count       = var.enable ? 1 : 0

  name        = "${var.cluster_id}-subnet-gp"
  subnet_ids  = var.subnet_ids
  description = var.description

  tags = merge(local.common_tags, map("Name", "${var.environment}-MemcacheCluster-Subnet-Grp"))
}

resource "aws_elasticache_cluster" "default" {
  count                        = var.enable && var.cluster_enabled ? 1 : 0

  engine                       = var.engine
  cluster_id                   = "${var.cluster_id}-${var.environment}"
  engine_version               = var.engine_version
  port                         = var.port
  num_cache_nodes              = var.num_cache_nodes
  az_mode                      = var.az_mode
  parameter_group_name         = var.parameter_group_name
  node_type                    = var.node_type
  subnet_group_name            = join("", aws_elasticache_subnet_group.default.*.name)
  security_group_ids           = aws_security_group.memcache_cluster_sg.id
  security_group_names         = var.security_group_names
  snapshot_arns                = var.snapshot_arns
  snapshot_name                = var.snapshot_name
  notification_topic_arn       = var.notification_topic_arn
  snapshot_window              = var.snapshot_window
  snapshot_retention_limit     = var.snapshot_retention_limit
  apply_immediately            = var.apply_immediately
  preferred_availability_zones = slice(var.availability_zones, 0, var.num_cache_nodes)
  maintenance_window           = var.maintenance_window

  tags = merge(local.common_tags, map("Name", "${var.environment}-MemcacheCluster"))
}
