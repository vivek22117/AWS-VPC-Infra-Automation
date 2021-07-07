resource "aws_cloudformation_stack" "sns_reminder_stack" {
  name          = var.sns_stack_name
  template_body = data.template_file.cft_sns_stack.rendered

  tags = merge(local.common_tags, map("Name", "Notification-SNS"))
}

