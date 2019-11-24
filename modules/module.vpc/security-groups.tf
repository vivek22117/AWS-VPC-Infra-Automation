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

  tags = local.common_tags
}