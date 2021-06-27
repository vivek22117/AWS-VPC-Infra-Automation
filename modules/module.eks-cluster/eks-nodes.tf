#################################################
#       EKS Cluster Nodes In Private Subnet     #
#################################################
resource "aws_eks_node_group" "eks_private_ng" {
  cluster_name = aws_eks_cluster.doubledigit_eks.name

  node_group_name = var.pvt_node_group_name
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = aws_subnet.private[*].id
  ami_type        = var.ami_type
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  capacity_type   = "ON_DEMAND"

  force_update_version = false

  scaling_config {
    desired_size = var.pvt_desired_size
    max_size     = var.pvt_max_size
    min_size     = var.pvt_min_size
  }

  dynamic "remote_access" {
    for_each = var.ec2_ssh_key != null && var.ec2_ssh_key != "" ? ["true"] : []
    content {
      ec2_ssh_key               = var.ec2_ssh_key
      source_security_group_ids = [aws_security_group.eks_nodes_sg.id]
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version", null)
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

  tags = merge(local.common_tags, map("Name", "${var.environment}-pvt-node-gp"))

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}


#################################################
#       EKS Cluster Nodes In Public Subnet      #
#################################################
resource "aws_eks_node_group" "eks_public_ng" {
  cluster_name = aws_eks_cluster.doubledigit_eks.name

  node_group_name = var.pub_node_group_name
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = aws_subnet.public[*].id
  ami_type        = var.ami_type
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  capacity_type   = "ON_DEMAND"

  force_update_version = false

  scaling_config {
    desired_size = var.public_desired_size
    max_size     = var.public_max_size
    min_size     = var.public_min_size
  }

  dynamic "remote_access" {
    for_each = var.ec2_ssh_key != null && var.ec2_ssh_key != "" ? ["true"] : []
    content {
      ec2_ssh_key               = var.ec2_ssh_key
      source_security_group_ids = [aws_security_group.eks_nodes_sg.id]
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version", null)
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

  tags = merge(local.common_tags, map("Name", "${var.environment}-pub-node-gp"))

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}