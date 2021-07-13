output "name" {
  value       = module.eks_irsa.name
}

output "arn" {
  value       = module.eks_irsa.arn
}

output "kubectl_cli" {
  value = (var.enabled ? join(" ", [
    format("kubectl -n %s create sa %s", var.namespace, var.service_account),
    "&&",
    format("kubectl -n %s annotate sa %s %s",
    var.namespace,
    var.service_account,
    join("=", ["eks.amazonaws.com/role-arn", module.eks_irsa.kubectl_cli])
    ),
  ]) : null)
  description = "The kubernetes configuration file for creating IAM role with service account"
}