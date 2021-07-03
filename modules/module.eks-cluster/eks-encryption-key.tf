locals {
  account_id     = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "kms_key_policy_doc" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow access for Key Administrators"
    effect    = "Allow"
    actions   = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
      ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.eks_nodes_role.arn,
        aws_iam_role.eks_cluster_iam.arn
      ]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.eks_nodes_role.arn,
        aws_iam_role.eks_cluster_iam.arn
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.eks_nodes_role.arn,
        aws_iam_role.eks_cluster_iam.arn
      ]
    }
  }
}

resource "aws_kms_key" "eks_cluster_key" {
  description         = "KMS key for Secrets Encryption for EKS"
  enable_key_rotation = false
  deletion_window_in_days = 30

  policy = data.aws_iam_policy_document.kms_key_policy_doc.json

  tags = local.common_tags
}

resource "aws_kms_alias" "eks_cluster_key_alias" {
  target_key_id = aws_kms_key.eks_cluster_key.key_id
  name          = "alias/eks_encryption_key"
}