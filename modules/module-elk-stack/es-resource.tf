resource "aws_security_group" "es_sg" {
  name        = var.sg_name
  description = "Security Group to allow traffic to ElasticSearch"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.common_tags, map("Name", "ecs-sg"))
}

resource "aws_security_group_rule" "secure_cidrs" {
  type              = "ingress"
  from_port         = 1024
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  security_group_id = aws_security_group.es_sg.id
}

resource "aws_security_group_rule" "secure_sgs" {
  count = length(var.ingress_allow_security_groups) > 0 ? 1 : 0

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = element(var.ingress_allow_security_groups, count.index)
  security_group_id        = aws_security_group.es_sg.id
}

resource "aws_security_group_rule" "secure_vpc_cidr" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  security_group_id = aws_security_group.es_sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.es_sg.id
}

resource "aws_iam_service_linked_role" "es_default_link_role" {
  aws_service_name = "es.amazonaws.com"
  description      = "AWSServiceRoleForAmazonElasticsearchService Service-Linked Role"
}

resource "aws_elasticsearch_domain" "dd_log_es" {
  domain_name           = var.es_domain_name
  elasticsearch_version = var.elasticsearch_version

  encrypt_at_rest {
    enabled = var.encryption_enabled
  }

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain_name}/*"
    }
  ]
}
POLICY

  vpc_options {
    security_group_ids = [aws_security_group.es_sg.id]
    subnet_ids         = [
        data.terraform_remote_state.vpc.outputs.private_subnets[0],
        data.terraform_remote_state.vpc.outputs.private_subnets[1]
      ]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = var.rest_action_multi_allow_explicit_index
    "indices.query.bool.max_clause_count"    = var.indices_query_bool_max_clause_count
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  log_publishing_options {
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.dd_es_lg.arn
    enabled                  = "true"
  }

  log_publishing_options {
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.dd_es_app_lg.arn
    enabled                  = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshot_start
  }

  tags = merge(local.common_tags, map("Name", var.es_domain_name))

  depends_on = [
    aws_iam_service_linked_role.es_default_link_role,
  ]
}

resource "aws_cloudwatch_log_group" "dd_es_lg" {
  name = "dd-es-log-group"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "dd_es_app_lg" {
  name = "dd-es-app-log-group"
  retention_in_days = 7
}


resource "aws_cloudwatch_log_resource_policy" "dd_es_log_access" {
  policy_name = "DDESServiceLoggingPolicy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}