##################################################################
#   Bastion host launch template and act as Jump Instance        #
##################################################################
resource "aws_launch_template" "eks_bastion_lt" {
  name_prefix = "${var.eks_bastion_name_prefix}${var.environment}"

  image_id                             = data.aws_ami.eks_bastion.id
  key_name                             = data.terraform_remote_state.s3_buckets.outputs.eks_bastion_key_name
  instance_type                        = var.bastion_instance_type
  instance_initiated_shutdown_behavior = "terminate"

  user_data = base64encode(data.template_file.eks_bastion_user_data.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.bastion_host_profile.name
  }

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    security_groups = [data.terraform_remote_state.eks_vpc.outputs.eks_bastion_sg_id]
    delete_on_termination = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.common_tags, map("Project", "DoubleDigit-Solutions"))
  }
}


#################################################
#         Bastion host ASG                      #
#################################################
resource "aws_autoscaling_group" "bastion_asg" {
  depends_on = [
    data.template_file.configmap_auth,
    aws_s3_bucket_object.artifactory_bucket_object
  ]

  name_prefix = "eks-bastion-asg-${var.environment}"

  vpc_zone_identifier  = data.terraform_remote_state.eks_vpc.outputs.public_subnets
  termination_policies = var.termination_policies
  max_size             = var.eks_bastion_asg_max_size
  min_size             = var.eks_bastion_asg_min_size
  desired_capacity     = var.eks_bastion_asg_desired_capacity

  default_cooldown = var.default_cooldown

  launch_template {
    id      = aws_launch_template.eks_bastion_lt.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
