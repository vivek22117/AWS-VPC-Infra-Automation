####################################################
#        QA VPC moudle configuration              #
####################################################
module "emr_clustser" {
  source = "../../modules/module.emr-cluster"

  bid_price = var.bid_price
  cluster_name = var.cluster_name

  component_name = var.component_name
  compression_enabled = ""
  core_instance_count = ""
  core_instance_type = ""
  deletion_time_limit = 0
  distinct_enabled = ""
  driver_cores = ""
  driver_java_opts = ""
  driver_memory = ""
  dynamic_partition_enabled = ""
  ebs_volume_size = 0
  emr_release = ""
  enable_dynamic_alloc = ""
  enable_dynamic_allocation = ""
  enable_max_resource_alloc = ""
  enable_s3_sse = ""
  enable_visibility = false
  environment = ""
  exec_java_opts = ""
  executor_cores = ""
  executor_memory = ""
  first_step_name = ""
  is_key_enabled = false
  jar_location = ""
  key_rotation_enabled = false
  kms_description = ""
  master_ebs_volume_size = 0
  master_instance_type = ""
  master_volume_type = ""
  num_exec_instances = ""
  num_executors = ""
  owner_team = ""
  profile = ""
  rsvp_emr_jar_key = ""
  rsvp_reader_class = ""
  spark_mem_frac = ""
  spark_parallelism = ""
  spark_shuffle_partitions = ""
  spark_storage_level = ""
  spark_storage_mem_frac = ""
  ssh_key_name = ""
  volume_type = ""
  yarn_driver_memory_overhead = ""
  yarn_exec_memory_overhead = ""
}