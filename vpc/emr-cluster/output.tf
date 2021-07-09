output "emr_cluster_id" {
  value = module.emr_cluster.emr_cluster_id
}

output "name" {
  value = module.emr_cluster.name
}

output "master_public_dns" {
  value = module.emr_cluster.master_public_dns
}