######################################################
# NAT gateways  enable instances in a private subnet #
# to connect to the Internet or other AWS services,  #
# but prevent the internet from initiating           #
# a connection with those instances.                 #
#                                                    #
# Each NAT gateway requires an Elastic IP.           #
######################################################
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.vpc_igw]

  vpc   = true
  count = var.enable_nat_gateway == "true" ? 1 : 0

  tags = {
    Name = "eks-eip-${var.environment}-${aws_vpc.vpc.id}-${count.index}"
  }
}


#################################################
#       Create NatGateway and allocate EIP      #
#################################################
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [aws_internet_gateway.vpc_igw]

  count = var.enable_nat_gateway == "true" ? 1 : 0

  allocation_id = aws_eip.nat_eip.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags = {
    Name = "eks-ng-${var.environment}-${aws_vpc.vpc.id}-${count.index + 1}"
  }

}


######################################################
# Public subnets                                     #
# Each subnet in a different AZ                      #
######################################################
resource "aws_subnet" "public" {
  count = length(var.public_azs_with_cidr)

  cidr_block              = values(var.public_azs_with_cidr)[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = keys(var.public_azs_with_cidr)[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                                            = "eks-public-${var.environment}-${element(keys(var.public_azs_with_cidr), count.index)}"
    "kubernetes.io/cluster/${var.cluster_name}"     = "shared"
    "kubernetes.io/role/elb"                        = "1",
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true",
    "k8s.io/cluster-autoscaler/enabled"             = "true"
  })

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


######################################################
# Private subnets                                    #
# Each subnet in a different AZ                      #
######################################################
resource "aws_subnet" "private" {
  count = length(var.private_azs_with_cidr)

  cidr_block              = values(var.private_azs_with_cidr)[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = keys(var.private_azs_with_cidr)[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name                                            = "eks-private-${var.environment}-${element(keys(var.private_azs_with_cidr), count.index)}"
    "kubernetes.io/cluster/${var.cluster_name}"     = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true",
    "k8s.io/cluster-autoscaler/enabled"             = "true"
  })

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


######################################################
# Private DB subnets for RDS, Aurora                 #
# Each subnet in a different AZ                      #
######################################################
resource "aws_subnet" "db_subnet" {
  count = length(var.db_azs_with_cidr)

  cidr_block              = values(var.db_azs_with_cidr)[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = keys(var.db_azs_with_cidr)[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    "Name" = "eks-db-${var.environment}-${element(keys(var.db_azs_with_cidr), count.index)}"
  })

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_db_subnet_group" "database_subnet_gp" {

  name        = var.db_subnet_gp
  description = "Database subnet group for EKS VPC"
  subnet_ids  = aws_subnet.db_subnet.*.id

  tags = merge(local.common_tags, {
    "Name" = "eks-dg-subnet-gp-${var.environment}-${aws_vpc.vpc.id}"
  })
}



######################################################
# Create route table for private subnets             #
# Route non-local traffic through the NAT gateway    #
# to the Internet                                    #
######################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.private_azs_with_cidr)

  tags = merge(local.common_tags, {
    "Name"                                        = "eks-private-route-${var.environment}-${aws_vpc.vpc.id}-${count.index}"
    "alpha.eksctl.io/cluster-name"                = var.cluster_name
    "eksctl.cluster.k8s.io/v1alpha5/cluster-name" = var.cluster_name
  })
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway == "true" ? length(var.private_azs_with_cidr) : 0

  route_table_id         = aws_route_table.private.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.*.id[0]
}

resource "aws_route_table_association" "private_association" {
  count = length(var.private_azs_with_cidr)

  route_table_id = aws_route_table.private.*.id[count.index]
  subnet_id      = aws_subnet.private.*.id[count.index]
}


######################################################
# Route the public subnet traffic through            #
# the Internet Gateway                               #
######################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = merge(local.common_tags, {
    "Name"                                        = "eks-public-route-${var.environment}-${aws_vpc.vpc.id}"
    "alpha.eksctl.io/cluster-name"                = var.cluster_name
    "eksctl.cluster.k8s.io/v1alpha5/cluster-name" = var.cluster_name
  })
}

resource "aws_route_table_association" "public_association" {
  count = length(var.public_azs_with_cidr)

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.*.id[count.index]
}


######################################################
# Route the public subnet traffic through            #
# the NAT Gateway for DB Subnet                      #
######################################################
resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.db_azs_with_cidr)

  tags = merge(local.common_tags, {
    "Name"                                        = "eks-db-route-${var.environment}-${aws_vpc.vpc.id}-${count.index}"
    "alpha.eksctl.io/cluster-name"                = var.cluster_name
    "eksctl.cluster.k8s.io/v1alpha5/cluster-name" = var.cluster_name
  })
}

resource "aws_route" "private_ng_route" {
  count = var.enable_nat_gateway == "true" ? length(var.db_azs_with_cidr) : 0

  route_table_id         = element(aws_route_table.db_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gateway.*.id, 0)
}

resource "aws_route_table_association" "db_subnet_association" {
  count = length(var.db_azs_with_cidr)

  route_table_id = aws_route_table.db_rt.*.id[count.index]
  subnet_id      = aws_subnet.db_subnet.*.id[count.index]
}


