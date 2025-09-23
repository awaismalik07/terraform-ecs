output "ALBTgArn" {
    value = aws_lb_target_group.AlbTargetGroup.arn
}

output "ALBArn" {
    value = aws_lb.ApplicationLoadBalancer.arn
}
