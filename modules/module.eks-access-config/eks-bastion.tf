########################################################
#    Key pair to be used for different applications    #
########################################################
resource "aws_key_pair" "bastion_key" {
  public_key = var.public_key
  key_name   = "bastion-eks-key"
}


##################################################################
#   Bastion host launch template and act as Jump Instance        #
##################################################################
resource "aws_launch_template" "eks_bastion_lt" {
  name_prefix = "${var.eks_bastion_name_prefix}${var.environment}"

  image_id               = data.aws_ami.eks_bastion.id
  key_name               = aws_key_pair.bastion_key.key_name
  instance_type          = var.bastion_instance_type
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.bastion_host_profile.name
  }

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = false
    security_groups             = [aws_security_group.bastion_host_sg.id]
    delete_on_termination       = true
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
  name_prefix         = "eks-bastion-asg-${var.environment}"

  vpc_zone_identifier = data.terraform_remote_state.eks_vpc.outputs.public_subnets
  termination_policies      = var.termination_policies
  max_size                  = var.eks_bastion_asg_max_size
  min_size                  = var.eks_bastion_asg_min_size
  desired_capacity          = var.eks_bastion_asg_desired_capacity

  default_cooldown = var.default_cooldown

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 25
      spot_instance_pools                      = 2
      spot_allocation_strategy                 = var.spot_allocation_st
      spot_max_price                           = var.spot_price
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_bastion_lt.id
        version            = "$Latest"
      }
    }
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
