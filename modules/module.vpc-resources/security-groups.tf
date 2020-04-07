#################################################
#       VPC ENdpoints Security Group            #
#################################################
resource "aws_security_group" "vpce" {
  name   = "vpce-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.cidr_block]
  }

  tags = merge(local.common_tags, map("Name", "${var.environment}-vpce-sg"))
}

resource "aws_security_group" "ecs_task" {
  depends_on = [aws_vpc_endpoint.s3_endpoint]

  name   = "ecs"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.id
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.cidr_block]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [aws_vpc_endpoint.s3_endpoint.prefix_list_id]
  }
  tags = merge(local.common_tags, map("Name", "${var.environment}-ecs-task-sg"))
}