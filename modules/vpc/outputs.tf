output "VpcId" {
    value = aws_vpc.Vpc.id
}

output "PublicSubnetIds" {
    value = aws_subnet.PublicSubnets.*.id
}

output "PrivateSubnetIds" {
    value = aws_subnet.PrivateSubnets.*.id
}