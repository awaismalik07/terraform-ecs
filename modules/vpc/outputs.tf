output "VpcId" {
    value = aws_vpc.Vpc.id
}

output "PublicSubnetIds" {
    value = aws_subnet.PublicSubnets.*.id
}

output "PrivateSubnetIds" {
    value = aws_subnet.PrivateSubnets.*.id
}

output "AppSGId" {
  value = aws_security_group.AppSG.id
}

output "StaticSGId" {
  value = aws_security_group.StaticSG.id
}