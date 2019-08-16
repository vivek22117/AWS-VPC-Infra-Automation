data "aws_ami" "bastion" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["dd-bastion"]
  }
}