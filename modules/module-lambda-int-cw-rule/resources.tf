resource "aws_lambda_permission" "cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"

  action        = "lambda:InvokeFunction"
  function_name = var.lambda_fun_name
  principal     = var.aws_event_type
  source_arn    = aws_cloudwatch_event_rule.cw_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "cw_event_rule" {
  name                = "${var.lambda_fun_name}-event-rule"
  description         = var.schedule_expression != "" ? "Schedule trigger for lambda execution" : "Trigger lambda based on event"
  schedule_expression = var.schedule_expression
  event_pattern = var.event_pattern

  is_enabled = true

  tags = merge(local.common_tags, map("Name", "${var.environment}-${var.lambda_fun_name}-event-rule"))
}

resource "aws_cloudwatch_event_target" "target" {
  rule = aws_cloudwatch_event_rule.cw_event_rule.name
  arn  = var.lambda_fun_arn
}