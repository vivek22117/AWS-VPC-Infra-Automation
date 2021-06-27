########################################################
#    Key pair to be used for different applications    #
########################################################
resource "aws_key_pair" "bastion_key" {
  public_key = var.public_key
  key_name   = "bastion-eks-key"
}

resource "aws_key_pair" "eks_node_key" {
  public_key = var.public_key
  key_name   = "eks-node-ssh-key"
}
