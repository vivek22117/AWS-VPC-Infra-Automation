#################################################
#       Bastion Host Security Group             #
#################################################
resource "aws_security_group" "bastion_host_sg" {
  name = "eks-bastion-sg-${aws_vpc.vpc.id}"

  description = "Allow SSH from owner IP"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, map("Name", "eks-${var.environment}-bastion-sg"))
}


#################################################
#       EKS Cluster Security Group              #
#################################################
resource "aws_security_group" "eks_cluster" {
  name        = "eks-sg-${var.environment}"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(local.common_tags, map("Name", "${var.environment}-eks-sg"))
}

resource "aws_security_group_rule" "eks_cluster_inbound" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}

resource "aws_security_group_rule" "eks_cluster_inbound_bastion" {
  type                     = "ingress"
  description              = "Allow Bastion Host to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.bastion_host_sg.id
}

resource "aws_security_group_rule" "eks_cluster_outbound" {
  type              = "egress"
  description       = "Allow cluster API Server to communicate with the worker nodes"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
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
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, map("Name", "${var.environment}-eks-nodes-sg"))
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

resource "aws_security_group_rule" "all_ports_eks_sg" {
  type                     = "ingress"
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

#################################################
#       VPC Endpoints Security Group            #
#################################################
resource "aws_security_group" "vpce" {
  name   = "vpce-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  tags = merge(local.common_tags, map("Name", "${var.environment}-vpce-sg"))
}

resource "aws_security_group" "ecs_task" {
  depends_on = [aws_vpc_endpoint.s3_endpoint]

  name   = "ecs"
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [aws_vpc_endpoint.s3_endpoint.prefix_list_id]
  }
  tags = merge(local.common_tags, map("Name", "${var.environment}-ecs-task-sg"))
}


