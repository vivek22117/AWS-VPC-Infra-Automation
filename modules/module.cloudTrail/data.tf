data "template_file" "cloudtrail_s3_policy_template" {
  depends_on = ["aws_s3_bucket.cloudtrail_s3_bucket"]

  template = file("${path.module}/scripts/s3-bucket-policy.json")

  vars = {
    bucket_arn     = aws_s3_bucket.cloudtrail_s3_bucket.arn
    s3_bucket_name = aws_s3_bucket.cloudtrail_s3_bucket.id
  }
}

data "template_file" "cloudtrail_log_policy_template" {
  depends_on = ["aws_cloudwatch_log_group.cloudtrail_logGroup"]

  template = file("${path.module}/scripts/cloud-trail-access.json")

  vars = {
    region        = var.region
    account_id    = data.aws_caller_identity.current.id
    log_group_arn = aws_cloudwatch_log_group.cloudtrail_logGroup.arn
  }
}

data "aws_iam_policy_document" "order_placed_queue_iam_policy" {
  policy_id = "SecuritySQSSendAccess"

  statement {
    sid = "SecuritySQSSendAccessStatement"
    effect = "Allow"
    actions = ["SQS:SendMessage"]
    resources = [aws_sqs_queue.security_alerts_sqs.arn]
    principals {
      identifiers = ["*"]
      type = "*"
    }
    condition {
      test = "ArnEquals"
      values = [aws_sns_topic.security_alerts_sns.arn]
      variable = "aws:SourceArn"
    }
  }
}

data "aws_caller_identity" "current" {}