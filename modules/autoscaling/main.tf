resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.MaxCapacity
  min_capacity       = var.MinCapacity
  resource_id        = "service/${var.ECSClusterName}/${var.ProxyServiceName}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_target_tracking" {
  name               = "${var.owner}-${var.env}-ProxyScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.AvgCputoMaintain   
    scale_in_cooldown  = var.ScaleInCooldown   
    scale_out_cooldown = var.ScaleOutCooldown  
  }
}