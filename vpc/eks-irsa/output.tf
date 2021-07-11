output "name" {
  value       = aws_iam_role.irsa_role.*.name
  description = "The name of generated IAM role"
}

output "arn" {
  value       = aws_iam_role.irsa_role.*.arn
  description = "The ARN of generated IAM role"
}

output "kubecli" {
  value = (var.enabled ? join(" ", [
    format("kubectl -n %s create sa %s", var.namespace, var.service_account),
    "&&",
    format("kubectl -n %s annotate sa %s %s",
    var.namespace,
    var.service_account,
    join("=", ["eks.amazonaws.com/role-arn", aws_iam_role.irsa_role.0.arn])
    ),
  ]) : null)
  description = "The kubernetes configuration file for creating IAM role with service account"
}