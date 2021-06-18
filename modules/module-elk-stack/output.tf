output "es_arn" {
  description = "Amazon Resource Name (ARN) of the domain"
  value       = aws_elasticsearch_domain.dd_log_es.arn
}

output "es_domain_id" {
  description = "Unique identifier for the domain."
  value       = aws_elasticsearch_domain.dd_log_es.domain_id
}

output "es_endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
  value       = aws_elasticsearch_domain.dd_log_es.endpoint
}

output "es_kibana_endpoint" {
  description = "Domain-specific endpoint for kibana without https scheme."
  value       = aws_elasticsearch_domain.dd_log_es.kibana_endpoint
}
