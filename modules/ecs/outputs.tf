output "ECSClusterName" {
    value = aws_ecs_cluster.ECSCluster.name
}

output "ProxyServiceName" {
    value = aws_ecs_service.ProxyService.name
}