#VPC
resource "aws_vpc" "Vpc" {
    cidr_block  = var.vpcCidr

    tags = {
        Name    = "${var.owner}-${var.env}-Vpc"
    }   
}

#Get All Availability Zones
data "aws_availability_zone" "AZs" {
    state       = "available"
    filter {
      name      = "opt-in-status"
      values    = ["opt-in-not-required"]
    }
}

#Creates two public subnets in first two AZs
resource "aws_subnet" "PublicSubnets" {
    count                   = 2
    vpc_id                  = aws_vpc.Vpc.id
    availability_zone       = data.aws_availability_zone.AZs.names[count.index]
    cidr_block              = cidrsubnet(aws_vpc.Vpc.cidr_block, 8, count.index)
    map_public_ip_on_launch = true
    tags = {
      Name                  = "${var.owner}-${var.env}-PublicSubnet-${data.aws_availability_zone.AZs.names[count.index]}"
    }
}

#Creates two private subnets in first two AZs
resource "aws_subnet" "PublicSubnets" {
    count                   = 2
    vpc_id                  = aws_vpc.Vpc.id
    availability_zone       = data.aws_availability_zone.AZs.names[count.index]
    cidr_block              = cidrsubnet(aws_vpc.Vpc.cidr_block, 8, count.index + 2)
    tags = {
      Name                  = "${var.owner}-${var.env}-PrivateSubnet-${data.aws_availability_zone.AZs.names[count.index]}"
    }
}


