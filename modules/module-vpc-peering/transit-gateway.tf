###########################
# Transit Gateway Section #
###########################
resource "aws_ec2_transit_gateway" "ddsolutions_tgw" {
  description = "Transit gateway for VPC peering of dev, test, prod, and shared"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = local.common_tags
}

# Route Tables Routes
## Usually unnecessary to explicitly create a Route Table in Terraform
## since AWS automatically creates and assigns a 'Main Route Table'
## whenever a VPC is created. However, in a Transit Gateway scenario,
## Route Tables are explicitly created so an extra route to the
## Transit Gateway could be defined

resource "aws_route" "vpc_dev_rt_route" {
  depends_on = ["aws_ec2_transit_gateway.ddsolutions_tgw"]

  route_table_id         = data.terraform_remote_state.vpc_dev.outputs.vpc_main_rt
  destination_cidr_block = "10.0.0.8"
  transit_gateway_id     = aws_ec2_transit_gateway.ddsolutions_tgw.id
}

resource "aws_route" "vpc_test_rt_route" {
  depends_on = ["aws_ec2_transit_gateway.ddsolutions_tgw"]

  route_table_id         = data.terraform_remote_state.vpc_test.outputs.vpc_main_rt
  destination_cidr_block = "10.0.0.8"
  transit_gateway_id     = aws_ec2_transit_gateway.ddsolutions_tgw.id
}

resource "aws_route" "vpc_shared_rt_route" {
  depends_on = ["aws_ec2_transit_gateway.ddsolutions_tgw"]

  route_table_id         = data.terraform_remote_state.vpc_shared.outputs.vpc_main_rt
  destination_cidr_block = "10.0.0.8"
  transit_gateway_id     = aws_ec2_transit_gateway.ddsolutions_tgw.id
}

resource "aws_route" "vpc_prod_rt_route" {
  depends_on = ["aws_ec2_transit_gateway.ddsolutions_tgw"]

  route_table_id         = data.terraform_remote_state.vpc_prod.outputs.vpc_main_rt
  destination_cidr_block = "10.0.0.8"
  transit_gateway_id     = aws_ec2_transit_gateway.ddsolutions_tgw.id
}


###########################
# VPC attachment          #
###########################
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_vpc_dev" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  subnet_ids         = data.terraform_remote_state.vpc_dev.outputs.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id
  vpc_id             = data.terraform_remote_state.vpc_dev.outputs.vpc_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-att-${data.terraform_remote_state.vpc_dev.outputs.vpc_id}"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_vpc_prod" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  subnet_ids         = data.terraform_remote_state.vpc_prod.outputs.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id
  vpc_id             = data.terraform_remote_state.vpc_prod.outputs.vpc_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-att-${data.terraform_remote_state.vpc_prod.outputs.vpc_id}"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_vpc_test" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  subnet_ids         = data.terraform_remote_state.vpc_test.outputs.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id
  vpc_id             = data.terraform_remote_state.vpc_test.outputs.vpc_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-att-${data.terraform_remote_state.vpc_test.outputs.vpc_id}"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_vpc_shared" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  subnet_ids         = data.terraform_remote_state.vpc_shared.outputs.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id
  vpc_id             = data.terraform_remote_state.vpc_shared.outputs.vpc_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-att-${data.terraform_remote_state.vpc_shared.outputs.vpc_id}"
    }
  )
}

##################################
# Transit gateway route tables   #
##################################
resource "aws_ec2_transit_gateway_route_table" "tgw_dev_rt" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-dev-rt"
    }
  )
}

resource "aws_ec2_transit_gateway_route_table" "tgw_shared_rt" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-shared-rt"
    }
  )
}

resource "aws_ec2_transit_gateway_route_table" "tgw_prod_rt" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-prod-rt"
    }
  )
}

resource "aws_ec2_transit_gateway_route_table" "tgw_test_rt" {
  depends_on = [aws_ec2_transit_gateway.ddsolutions_tgw]

  transit_gateway_id = aws_ec2_transit_gateway.ddsolutions_tgw.id

  tags = merge(
    local.common_tags,
    {
      Name = "tgw-test-rt"
    }
  )
}

####################################################################################################
# Route Tables Associations
## This is the link between a VPC (already symbolized with its attachment to the Transit Gateway)
##  and the Route Table the VPC's packet will hit when they arrive into the Transit Gateway.
## The Route Tables Associations do not represent the actual routes the packets are routed to.
## These are defined in the Route Tables Propagations section below.
####################################################################################################
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_dev_vpc_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_dev_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_test_vpc_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_test.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_test_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_shared_vpc_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_shared_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_prod_vpc_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_rt.id
}

# Route Tables Propagations
# This section defines which VPCs will be routed from each Route Table
# created in the Transit Gateway

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_dev_to_dev_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_dev_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_dev_to_test_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_test.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_dev_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_dev_to_shared_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_dev_rt
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_test_to_test_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_test.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_test_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_test_to_shared_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_test_rt.depends_on
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_test_to_dev_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_test_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_shared_to_dev_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_shared_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_shared_to_test_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_test.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_shared_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_shared_to_prod_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_shared_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_prod_to_shared_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_vpc_shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_rt.id
}
