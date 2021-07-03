resource "aws_kms_key" "eks_cluster_key" {
  description         = "KMS key for Secrets Encryption for EKS"
  enable_key_rotation = false

  tags = local.common_tags

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
            ${aws_iam_role.eks_cluster_iam.arn},
            ${aws_iam_role.eks_nodes_role.arn}
        ]
      },
      "Action": [
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
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
            "Principal": {
          "AWS": [
            ${aws_iam_role.eks_cluster_iam.arn},
            ${aws_iam_role.eks_nodes_role.arn}
        ]
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
            "Principal": {
          "AWS": [
            ${aws_iam_role.eks_cluster_iam.arn},
            ${aws_iam_role.eks_nodes_role.arn}
        ]
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "eks_cluster_key_alias" {
  target_key_id = aws_kms_key.eks_cluster_key.key_id
  name          = "alias/eks_encryption_key"
}