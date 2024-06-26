profile        = "qa-admin"
owner_team     = "Demo"
default_region = "us-east-1"

component_name = "dd-solutions"

log_retention_days = 3

instance_type                     = "t3a.small"
key_name                          = "demo-solutions"
max_price                         = "0.0075"
volume_size                       = "40"
default_target_group_port         = 80
app_asg_max_size                  = "4"
app_asg_min_size                  = "2"
app_asg_desired_capacity          = "2"
health_check_type                 = "ELB"
app_asg_health_check_grace_period = "240"
app_asg_wait_for_elb_capacity     = "1"
default_cooldown                  = 300
termination_policies              = ["OldestInstance", "Default"]
suspended_processes               = []
wait_for_capacity_timeout         = "7m"


