##########################################################
# Terraform configuration for AWS Aurora RDS             #
##########################################################
resource "aws_db_subnet_group" "dd_db_sub_group" {
  name        = var.sub_group_name
  description = "Group of DB subnets for DD-Backend"
  subnet_ids  = data.terraform_remote_state.vpc.outputs.db_subnets

  tags = merge(local.common_tags, map("Name", "dd-db-subnet-gp-${var.environment}"))
}


resource "random_id" "random_identifier_suffix" {
  byte_length = 4
}
##########################################################
#               RDS PostgresSQL DB                       #
##########################################################
resource "aws_db_instance" "dd_postgresql" {

  lifecycle {
    ignore_changes = [
      password,
      snapshot_identifier,
    ]
  }

  engine         = "postgres"
//  engine_version = var.engine_version

  identifier                      = format("${var.database_identifier}%s", var.environment)
//  snapshot_identifier             = var.snapshot_identifier
  instance_class                  = var.instance_type
  storage_type                    = var.storage_type
  name                            = var.database_name
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  apply_immediately               = var.apply_immediately
  maintenance_window              = var.maintenance_window
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  final_snapshot_identifier       = "dd-postgresql-db-dev-${random_id.random_identifier_suffix.hex}"
  skip_final_snapshot             = var.skip_final_snapshot
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  multi_az                        = var.multi_availability_zone
  port                            = var.database_port
  vpc_security_group_ids          = [aws_security_group.dd_db_sg.id]
  db_subnet_group_name            = aws_db_subnet_group.dd_db_sub_group.name
  storage_encrypted               = var.storage_encrypted
  monitoring_interval             = var.monitoring_interval
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  tags = merge(local.common_tags, map("Name", "${var.database_identifier}-${var.environment}"))
}

#################################################################
#                       CloudWatch resources                    #
#################################################################
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "alarm-${var.environment}-DatabaseServerCPUUtilization-${var.database_identifier}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.dd_postgresql.id
  }

  alarm_actions             = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  ok_actions                = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  insufficient_data_actions = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  alarm_name          = "alarm-${var.environment}-DatabaseServerDiskQueueDepth-${var.database_identifier}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_disk_queue_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.dd_postgresql.id
  }

  alarm_actions             = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  ok_actions                = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  insufficient_data_actions = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  alarm_name          = "alarm-${var.environment}-DatabaseServerFreeStorageSpace-${var.database_identifier}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_disk_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.dd_postgresql.id
  }

  alarm_actions             = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  ok_actions                = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  insufficient_data_actions = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  alarm_name          = "alarm-${var.environment}-DatabaseServerFreeableMemory-${var.database_identifier}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_memory_threshold

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.dd_postgresql.id
  }

  alarm_actions             = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  ok_actions                = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
  insufficient_data_actions = [aws_cloudformation_stack.sns_reminder_stack.outputs["SNSARN"]]
}
