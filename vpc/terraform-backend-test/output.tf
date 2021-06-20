output "s3_bucket_arn" {
  value = aws_s3_bucket.tf_state_bucket.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.tf_state_bucket.id
}

output "dynamoDB_arn" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.arn
}

output "dynamoDB_name" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.name
}

