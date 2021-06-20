{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        },
,
        {
            "Sid": "ViewOwnUserInfo",
            "Effect": "Allow",
            "Action": [
                "iam:GetUserPolicy",
                "iam:ListGroupsForUser",
                "iam:ListAttachedUserPolicies",
                "iam:ListUserPolicies",
                "iam:GetUser"
            ],
            "Resource": ["arn:aws:iam::*:user/${aws:username}"]
        },
        {
            "Sid": "NavigateInConsole",
            "Effect": "Allow",
            "Action": [
                "iam:GetGroupPolicy",
                "iam:GetPolicyVersion",
                "iam:GetPolicy",
                "iam:ListAttachedGroupPolicies",
                "iam:ListGroupPolicies",
                "iam:ListPolicyVersions",
                "iam:ListPolicies",
                "iam:ListUsers"
            ],
            "Resource": "*"
        },
        {
          "Sid": "SessionManagerStartSession",
          "Effect": "Allow",
          "Action": "ssm:StartSession",
          "Resource": [
            "arn:aws:ec2:*:*:instance/*",
            "arn:aws:ssm:*::document/AWS-StartPortForwardingSession"
          ]
          "Condition": {
            "StringLike": {
              "ssm:resourceTag/ssm-session": "enabled"
            }
          }
        },
        {
          "Sid": "SessionManagerPortForward",
          "Effect": "Allow",
          "Action": "ssm:StartSession",
          "Resource": "arn:aws:ssm:*::document/AWS-StartPortForwardingSession"
        },
        {
          "Sid": "SessionManagerTerminateSession",
          "Effect": "Allow",
          "Action": [
            "ssm:TerminateSession",
            "ssm:ResumeSession"
          ],
          "Resource": "arn:aws:ssm:*:*:session/${aws:username}-*"
        }
    ]
}