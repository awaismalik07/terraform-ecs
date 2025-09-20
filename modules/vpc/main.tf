#VPC
resource "aws_vpc" "Vpc" {
    cidr_block  = var.vpcCidr

    tags = {
        Name    = "${var.owner}-${var.env}-Vpc"
    }   
}

#Get All Availability Zones
data "aws_availability_zones" "AZs" {
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
    availability_zone       = data.aws_availability_zones.AZs.names[count.index]
    cidr_block              = cidrsubnet(aws_vpc.Vpc.cidr_block, 8, count.index)
    map_public_ip_on_launch = true

    tags = {
      Name                  = "${var.owner}-${var.env}-PublicSubnet-${data.aws_availability_zones.AZs.names[count.index]}"
    }
}

#Creates two private subnets in first two AZs
resource "aws_subnet" "PrivateSubnets" {
    count                   = 2
    vpc_id                  = aws_vpc.Vpc.id
    availability_zone       = data.aws_availability_zones.AZs.names[count.index]
    cidr_block              = cidrsubnet(aws_vpc.Vpc.cidr_block, 8, count.index + 2)
    
    tags = {
      Name                  = "${var.owner}-${var.env}-PrivateSubnet-${data.aws_availability_zones.AZs.names[count.index]}"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "InternetGateway" {
    vpc_id      = aws_vpc.Vpc.id

    tags = {
        Name    = "${var.owner}-${var.env}-InternetGateway"
    }
  
}

#NAT Gateway and its elastic ip
resource "aws_eip" "ElasticIp" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NATGateway" {
    allocation_id   = aws_eip.ElasticIp.id
    subnet_id       = aws_subnet.PublicSubnets[0].id
    
    tags = {
      Name          = "${var.owner}-${var.env}-NATGateway"
    }       
}

