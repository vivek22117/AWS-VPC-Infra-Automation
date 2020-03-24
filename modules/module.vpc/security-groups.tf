#################################################
#       Bastion Host Security Group             #
#################################################
resource "aws_security_group" "bastion_host_sg" {
  name = "bastion-sg-${aws_vpc.vpc.id}"

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

  tags = merge(local.common_tags, map("Name", "${var.environment}-bastion-sg"))
}


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