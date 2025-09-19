resource "aws_vpc" "vpc" {
    cidr_block = var.vpcCidr

    tags = {
        Name = "${var.owner}-${var.env}-Vpc"
    }   
}