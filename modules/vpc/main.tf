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

#Public Route table for Public Subnet
resource "aws_route_table" "PublicRouteTable" {
    vpc_id          = aws_vpc.Vpc.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.InternetGateway.id
    }

    tags = {
        Name        = "${var.owner}-${var.env}-PublicRouteTable"
    }
}

#Private Route Table for Private Subnet
resource "aws_route_table" "PrivateRouteTable" {
    vpc_id          = aws_vpc.Vpc.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_nat_gateway.NATGateway.id
    }

    tags = {
        Name        = "${var.owner}-${var.env}-PrivateRouteTable"
    }
}

#Public and Private Route Table Association with respective subnets
resource "aws_route_table_association" "PublicRouteTableAssociation" {
    count           = 2
    route_table_id  = aws_route_table.PublicRouteTable.id
    subnet_id       = aws_subnet.PublicSubnets[count.index].id
}

resource "aws_route_table_association" "PrivateRouteTableAssociation" {
    count           = 2
    route_table_id  = aws_route_table.PrivateRouteTable.id
    subnet_id       = aws_subnet.PrivateSubnets[count.index].id
}

#Security groups
resource "aws_security_group" "AppSG" {
    vpc_id = aws_vpc.Vpc.id
    name = "${var.owner}-${var.env}-AppSG"
    description = "Security Group for Flask App"

    tags = {
      Name = "${var.owner}-${var.env}-AppSG"
    }
  
}

resource "aws_security_group_rule" "AppSGIngress" {
    security_group_id = aws_security_group.AppSG.id
    type = "ingress"
    from_port = 5000
    to_port = 5000
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  
}

resource "aws_security_group_rule" "AppSGEgress" {
    security_group_id = aws_security_group.AppSG.id
    type = "egress"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  
}

resource "aws_security_group" "StaticSG" {
    vpc_id = aws_vpc.Vpc.id
    name = "${var.owner}-${var.env}-StaticSG"
    description = "Security Group for Static"

    tags = {
      Name = "${var.owner}-${var.env}-StaticSG"
    }
  
}

resource "aws_security_group_rule" "StaticSGIngress" {
    security_group_id = aws_security_group.StaticSG.id
    type = "ingress"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  
}

resource "aws_security_group_rule" "StaticSGEgress" {
    security_group_id = aws_security_group.StaticSG.id
    type = "egress"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  
}

resource "aws_security_group" "ProxySG" {
    vpc_id = aws_vpc.Vpc.id
    name = "${var.owner}-${var.env}-ProxySG"
    description = "Security Group for Proxy"

    tags = {
      Name = "${var.owner}-${var.env}-ProxySG"
    }
  
}

resource "aws_security_group_rule" "ProxySGIngress" {
    security_group_id = aws_security_group.ProxySG.id
    type = "ingress"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  
}

resource "aws_security_group_rule" "ProxySGEgress" {
    security_group_id = aws_security_group.ProxySG.id
    type = "egress"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  
}

#Security Group for the load balancer
resource "aws_security_group" "ALBSG" {
    vpc_id = aws_vpc.Vpc.id
    description = "Security Group for ALB"
    tags = {
      Name = "${var.owner}-${var.env}-ALB-SG"
    }  
}

#To Allow Http reqs to the load balancer
resource "aws_security_group_rule" "ALBSGIngress" {
  security_group_id = aws_security_group.ALBSG.id
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
  
}

#To Allow load balancer to send all the outbound traffic to internet
resource "aws_security_group_rule" "ALBSGEgress" {
  security_group_id = aws_security_group.ALBSG.id
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

