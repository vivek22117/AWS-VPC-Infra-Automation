####################################################
#        QA VPC module configuration              #
####################################################
module "emr_cluster" {
  source = "../../modules/module.emr-cluster"

  owner_team = var.owner_team
  profile = var.profile
  component_name = var.component_name
  default_region = var.default_region
  environment = var.environment

  rsvp_emr_jar_key = var.rsvp_emr_jar_key

  kms_deletion_time_limit = var.kms_deletion_time_limit
  key_rotation_enabled = var.key_rotation_enabled
  kms_description = var.kms_description
  is_key_enabled = var.is_key_enabled

  cluster_name = var.cluster_name
  emr_release = var.emr_release
  enable_visibility = var.enable_visibility
  ssh_key_name = var.ssh_key_name

  master_instance_type = var.master_instance_type
  bid_price = var.bid_price
  master_ebs_volume_size = var.master_ebs_volume_size
  master_volume_type = var.master_volume_type

  core_instance_count = var.core_instance_count
  core_instance_type = var.core_instance_type
  core_instance_bid_price = var.core_instance_bid_price
  ebs_volume_size = var.ebs_volume_size
  volume_type = var.volume_type

  ######### EMR Configuration Parameters #############

  enable_dynamic_allocation = var.enable_dynamic_allocation
  num_exec_instances = var.num_exec_instances
  spark_mem_frac = var.spark_mem_frac
  spark_storage_mem_frac = var.spark_storage_mem_frac
  exec_java_opts = var.exec_java_opts
  driver_java_opts = var.driver_java_opts
  spark_storage_level = var.spark_storage_level
  compression_enabled = var.compression_enabled
  distinct_enabled = var.distinct_enabled
  dynamic_partition_enabled = var.dynamic_partition_enabled
  enable_max_resource_alloc = var.enable_max_resource_alloc

  enable_dynamic_alloc = var.enable_dynamic_alloc
  spark_shuffle_partitions = var.spark_shuffle_partitions
  yarn_exec_memory_overhead = var.yarn_exec_memory_overhead
  spark_parallelism = var.spark_parallelism
  yarn_driver_memory_overhead = var.yarn_driver_memory_overhead

  enable_s3_sse = var.enable_s3_sse

  ############ EMR Steps Configuration ###############
  driver_memory = var.driver_memory
  driver_cores = var.driver_cores
  num_executors = var.num_executors
  executor_memory = var.executor_memory
  executor_cores = var.executor_cores
  rsvp_reader_class = var.rsvp_reader_class
  jar_location = var.jar_location
  first_step_name = var.first_step_name


}