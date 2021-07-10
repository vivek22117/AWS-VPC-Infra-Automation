resource "random_string" "irsa_suffix" {
  count   = var.enabled ? 1 : 0
  length  = 12
  upper   = false
  lower   = true
  number  = true
  special = false
}

locals {
  suffix = var.enabled ? random_string.irsa_suffix.0.result : ""
  name   = var.name == null ? substr(join("-", ["irsa", local.suffix]), 0, 64) : substr(var.name, 0, 64)
  oidc_fully_qualified_subjects = format("system:serviceaccount:%s:%s", var.namespace, var.service_account)

  common_tags = {
    Owner       = var.owner
    Team        = var.team
    Environment = var.environment
    Monitoring  = var.isMonitoring
    Project     = var.project
    Component   = var.component
  }
}

# security/policy
resource "aws_iam_role" "irsa_role" {
  count = var.enabled ? 1 : 0

  name  = format("%s", local.name)
  path  = "/"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_arn
      }
      Condition = {
        StringEquals = {
          format("%s:sub", var.oidc_url) = local.oidc_fully_qualified_subjects
        }
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge(local.common_tags, map("Name", local.name))
}

resource "aws_iam_role_policy_attachment" "irsa_role_policy_att" {
  for_each   = var.enabled ? { for key, val in var.policy_arns : key => val } : {}

  policy_arn = each.value
  role       = aws_iam_role.irsa[0].name
}