####################################################
#        QA VPC moudle configuration              #
####################################################
module "emr_clustser" {
  source = "../../modules/module.emr-cluster"

  bid_price = var.bid_price
  cluster_name = var.cluster_name

  component_name = var.component_name
  compression_enabled = var.compression_enabled
  core_instance_count = var.core_instance_count
  core_instance_type = var.core_instance_type

  deletion_time_limit = 0
  distinct_enabled = var.distinct_enabled
  driver_cores = var.driver_cores
  driver_java_opts = var.driver_java_opts
  driver_memory = var.driver_memory
  dynamic_partition_enabled = var.dynamic_partition_enabled
  ebs_volume_size = 0
  emr_release = var.emr_release
  enable_dynamic_alloc = var.enable_dynamic_alloc
  enable_dynamic_allocation = var.enable_dynamic_allocation
  enable_max_resource_alloc = var.enable_max_resource_alloc
  enable_s3_sse = var.enable_s3_sse
  enable_visibility = var.enable_visibility
  environment = var.environment
  exec_java_opts = var.exec_java_opts
  executor_cores = var.executor_cores
  executor_memory = var.executor_memory
  first_step_name = var.first_step_name
  is_key_enabled = var.is_key_enabled
  jar_location = var.jar_location
  key_rotation_enabled = var.key_rotation_enabled
  kms_description = var.kms_description
  master_ebs_volume_size = var.master_ebs_volume_size
  master_instance_type = var.master_instance_type
  master_volume_type = var.master_volume_type
  num_exec_instances = var.num_exec_instances
  num_executors = var.num_executors
  owner_team = var.owner_team
  profile = var.profile
  rsvp_emr_jar_key = var.rsvp_emr_jar_key
  rsvp_reader_class = var.rsvp_reader_class
  spark_mem_frac = var.spark_mem_frac
  spark_parallelism = var.spark_parallelism
  spark_shuffle_partitions = var.spark_shuffle_partitions
  spark_storage_level = var.spark_storage_level
  spark_storage_mem_frac = var.spark_storage_mem_frac
  ssh_key_name = var.ssh_key_name
  volume_type = var.volume_type
  yarn_driver_memory_overhead = var.yarn_driver_memory_overhead
  yarn_exec_memory_overhead = var.yarn_exec_memory_overhead
}