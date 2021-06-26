####################################################
#             Bastion host AMI for EKS             #
####################################################
data "aws_ami" "eks-bastion" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["eks-bastion"]
  }
}
