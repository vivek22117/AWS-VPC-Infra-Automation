#################################################
#       EKS Cluster Security Group              #
#################################################
resource "aws_security_group" "eks_cluster" {
  name        = "eks-sg-${var.environment}"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.terraform_remote_state.eks_vpc.outputs.vpc_id

  tags = merge(local.common_tags, map("Name", "EKS-SG-${var.environment}"))
}

resource "aws_security_group_rule" "eks_cluster_node_inbound" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}

resource "aws_security_group_rule" "eks_cluster_itself" {
  type                     = "ingress"
  description              = "Allow cluster to cluster traffic"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_cluster.id
}


resource "aws_security_group_rule" "eks_cluster_inbound_bastion" {
  type                     = "ingress"
  description              = "Allow Bastion Host to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = data.terraform_remote_state.eks_vpc.outputs.eks_bastion_sg_id
}

resource "aws_security_group_rule" "eks_cluster_vpc_inbound" {
  type              = "ingress"
  description       = "Allow cluster API Server to communicate with the worker nodes"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = [data.terraform_remote_state.eks_vpc.outputs.vpc_cidr_block]
}

resource "aws_security_group_rule" "eks_cluster_outbound_internet" {
  type              = "egress"
  description       = "Allow cluster egress access to internet"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#################################################
#       EKS Cluster Nodes Security Group        #
#################################################
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg-${var.environment}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = data.terraform_remote_state.eks_vpc.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, map("Name", "EKS-NODE-SG-${var.environment}"))
}

resource "aws_security_group_rule" "all_ports_within" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}

resource "aws_security_group_rule" "eks_node_node_ssh" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with each other via SSH"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}

resource "aws_security_group_rule" "eks_node_allow_ssh" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  cidr_blocks       = [data.terraform_remote_state.eks_vpc.outputs.cidr_block]
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group_rule" "all_ports_eks_sg" {
  type                     = "ingress"
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster.id
}


