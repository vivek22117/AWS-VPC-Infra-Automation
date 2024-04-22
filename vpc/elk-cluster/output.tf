output "es_arn" {
  description = "Amazon Resource Name (ARN) of the domain"
  value       = module.demo-logging-es.es_arn
}

output "es_domain_id" {
  description = "Unique identifier for the domain."
  value       = module.demo-logging-es.es_domain_id
}

output "es_endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
  value       = module.demo-logging-es.es_endpoint
}

output "es_kibana_endpoint" {
  description = "Domain-specific endpoint for kibana without https scheme."
  value       = module.demo-logging-es.es_kibana_endpoint
}
