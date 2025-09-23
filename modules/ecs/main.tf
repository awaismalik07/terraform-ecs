#Service Discovery to be used by proxy
resource "aws_service_discovery_private_dns_namespace" "ServiceDiscoveryNamespace" {
    name = "${var.owner}.local"
    vpc = var.VpcId
}

resource "aws_service_discovery_service" "AppService" {
    name = "app"

    dns_config {
        namespace_id = aws_service_discovery_private_dns_namespace.ServiceDiscoveryNamespace.id
      
        dns_records {
        ttl = 60
        type = "A"
        }
    }   
  
}

resource "aws_service_discovery_service" "StaticService" {
    name = "static"

    dns_config {
        namespace_id = aws_service_discovery_private_dns_namespace.ServiceDiscoveryNamespace.id
      
        dns_records {
        ttl = 60
        type = "A"
        }
    }   
  
}

#Cluster
resource "aws_ecs_cluster" "ECSCluster" {
    name    = "${var.owner}-${var.env}-Cluster"
    
    tags = {
      Name  = "${var.owner}-${var.env}-Cluster"
    }
}

#Task definations
resource "aws_ecs_task_definition" "AppTask" {
    family = "${var.owner}-${var.env}-App"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    execution_role_arn = var.ECSTaskExcecutionRoleArn
    container_definitions = jsonencode([
        {
            name = "App"
            image = "${var.AppRepo}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 5000
                }
            ]
        },
        {
            name = "Redis"
            image = "redis:alpine"
            essential = true
            portMappings = [
                {
                    containerPort = 6379
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "StaticTask" {
    family = "${var.owner}-${var.env}-Static"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    execution_role_arn = var.ECSTaskExcecutionRoleArn
    container_definitions = jsonencode([
        {
            name = "Static"
            image = "${var.StaticRepo}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 80
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "ProxyTask" {
    family = "${var.owner}-${var.env}-Proxy"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    execution_role_arn = var.ECSTaskExcecutionRoleArn
    container_definitions = jsonencode([
        {
            name = "Proxy"
            image = "${var.ProxyRepo}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 80
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "AppService" {
    name = "${var.owner}-${var.env}-App-Service"
    cluster = aws_ecs_cluster.ECSCluster.id
    task_definition = aws_ecs_task_definition.AppTask.arn
    desired_count = 1
    launch_type = "FARGATE"

    service_registries {
        registry_arn = aws_service_discovery_service.AppService.arn
    }

    network_configuration {
        subnets = var.PublicSubnetIds
        security_groups = ["${var.AppSGId}"]
        assign_public_ip = true
    }
}

resource "aws_ecs_service" "StaticService" {
    name = "${var.owner}-${var.env}-Static-Service"
    cluster = aws_ecs_cluster.ECSCluster.id
    task_definition = aws_ecs_task_definition.StaticTask.arn
    desired_count = 1
    launch_type = "FARGATE"

    service_registries {
        registry_arn = aws_service_discovery_service.StaticService.arn
    }

    network_configuration {
        subnets = var.PublicSubnetIds
        security_groups = ["${var.StaticSGId}"]
        assign_public_ip = true
    }
}

resource "aws_ecs_service" "ProxyService" {
    name = "${var.owner}-${var.env}-Proxy-Service"
    cluster = aws_ecs_cluster.ECSCluster.id
    task_definition = aws_ecs_task_definition.ProxyTask.arn
    desired_count = 2
    launch_type = "FARGATE"

    network_configuration {
        subnets = var.PublicSubnetIds
        security_groups = ["${var.ProxySGId}"]
        assign_public_ip = true
    }

    load_balancer {
      container_name = "Proxy"
      container_port = 80
      target_group_arn = var.ALBTgArn
    }

    depends_on = [ 
        aws_ecs_service.AppService,
        aws_ecs_service.StaticService,
        var.ALBArn
     ]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ECSCluster.name}/${aws_ecs_service.ProxyService.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_target_tracking" {
  name               = "${var.owner}-${var.env}-Static-Service"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 10   # try to keep CPU around 50%
    scale_in_cooldown  = 60   # wait 60s before scaling in
    scale_out_cooldown = 60   # wait 60s before scaling out
  }
}