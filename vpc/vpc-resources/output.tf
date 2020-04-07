output "vpce_sg" {
  value = module.vpc_other_resources.vpce_sg
}

output "ecs_task_sg" {
  value = module.vpc_other_resources.ecs_task_sg
}

output "vpc_s3_endpoint" {
  value = module.vpc_other_resources.vpc_s3_endpoint
}

output "vpc_logs_endpoint" {
  value = module.vpc_other_resources.vpc_logs_endpoint
}