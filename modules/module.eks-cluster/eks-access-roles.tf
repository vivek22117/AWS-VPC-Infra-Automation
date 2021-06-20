####################################################
#             EKS read only Group & Policy         #
####################################################
resource "aws_iam_group" "eks_access_group" {
  name = var.eks-iam-group
  path = "/"
}

resource "aws_iam_policy" "eks_read_policy" {
  name        = "EKSReadOnlyPolicy"

  description = "EKS read only access"
  policy      = templatefile("${path.module}/policy-doc/eks-read-access.json", {})
}

resource "aws_iam_group_policy_attachment" "eks_read_access_att" {

  group      = aws_iam_group.eks_access_group.name
  policy_arn = aws_iam_policy.eks_read_policy.arn
}


####################################################
#          EKS read only Role/User & Policy        #
####################################################
resource "aws_iam_role" "eks_read_role" {
  name = "EKSReadOnlyRoleForEC2"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
               "Service": [
                  "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eck_read_policy_role_att" {
  policy_arn = aws_iam_policy.eks_read_policy.arn
  role       = aws_iam_role.eks_read_role.name
}

resource "aws_iam_instance_profile" "eks_read_access_profile" {
  name = "EKSReadAccessInstanceProfile"
  role = aws_iam_role.eks_read_role.name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role" "eks_user_role" {
  name = "EKSReadOnlyRoleForUser"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
               "AWS": [
                  "arn:aws:iam::308201090432:root"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_read_policy_user_att" {
  policy_arn = aws_iam_policy.eks_read_policy.arn
  role       = aws_iam_role.eks_user_role.name
}


####################################################
#           EKS full access User & Policy          #
####################################################
resource "aws_iam_policy" "eks_full_access_policy" {
  name        = "EKSFullAccessPolicy"

  description = "EKS full access"
  policy      = templatefile("${path.module}/policy-doc/eks-full-access.json", {})
}


resource "aws_iam_role" "eks_full_access_role" {
  name = "EKSFullAccessRoleForEC2"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
               "Service": [
                  "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy_role_att" {
  policy_arn = aws_iam_policy.eks_full_access_policy.arn
  role       = aws_iam_role.eks_full_access_role.name
}

resource "aws_iam_instance_profile" "eks_admin_access_profile" {
  name = "EKSAdminAccessInstanceProfile"
  role = aws_iam_role.eks_full_access_role.name

  lifecycle {
    create_before_destroy = true
  }
}

###############################################################
#             Bastion Host IAM Role                           #
###############################################################
resource "aws_iam_role" "bastion_host_role" {
  name = "BastionHostEC2RoleForEKS"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
               "Service": [
                  "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "bastion_host_policy" {
  name        = "BastionHostEC2PolicyForEKS"
  description = "Policy to access AWS Resources"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "NavigateInConsole",
            "Effect": "Allow",
            "Action": [
                "iam:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_policy_role_attach" {
  policy_arn = aws_iam_policy.bastion_host_policy.arn
  role       = aws_iam_role.bastion_host_role.name
}

resource "aws_iam_instance_profile" "bastion_host_profile" {
  name = "BastionHostInstanceProfileForEKS"
  role = aws_iam_role.bastion_host_role.name

  lifecycle {
    create_before_destroy = true
  }
}
