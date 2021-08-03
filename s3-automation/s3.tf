resource "aws_cloudformation_stack" "s3_stack" {
  count = length(compact(split(",",var.s3_bucket_with_replication_dst_region))) > 0 ? 1 : 0

  name          = var.s3_bucket_stack_name

  template_body = templatefile("${path.module}/script/s3-bucket-ctf.json.tpl", {
    s3_bucket_name = "${var.bucket_name}-${var.global_region}"
    role_arn = var.role_arn
    aws_region = var.s3_bucket_with_replication_dst_region[count.index]
  })

  tags = merge(local.common_tags, map("Name", "Notification-API-SNS"))
}
