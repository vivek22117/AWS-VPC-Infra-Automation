###########################################################
#           CloudTrail Role & Policy                      #
###########################################################
resource "aws_iam_role" "cloudtrial_logs_access_role" {

  name               = "CloudTrailLogsAccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "cloudtrail_logs_role_policy" {
  name = "CloudTrailAccessRolePolicy"
  description = "Policy to access resources"
  path = "/"
  policy = data.template_file.cloudtrail_log_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "cloudtrail_log_role_att" {
  policy_arn = aws_iam_policy.cloudtrail_logs_role_policy.arn
  role = aws_iam_role.cloudtrial_logs_access_role.name
}

data "aws_iam_policy_document" "cloudtrail_log_access" {

  statement {
    sid = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_s3_bucket.arn]

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]

    resources = [var.s3_key_prefix != "" ? format("%s/%s/*", aws_s3_bucket.cloudtrail_s3_bucket.arn, var.s3_key_prefix) : format("%s/*", aws_s3_bucket.cloudtrail_s3_bucket.arn)]

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}