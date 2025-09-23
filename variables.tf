#AWS Region
variable "region" {
  type = string
}

#Variables for Environment
variable "environment" {
  type = object({
    env = string
    owner = string
  })
}

#Variables for VPC module
variable "vpc" {
  type = object({
    vpcCidr = string
    NoOfSubnets = number
    SubnetCidrBits = number 
  })
}

#Variables for ECS module
variable "ecs" {
  type = object({
    ECSTaskCpu = number
    ECSTaskMemory = number
    AppServiceDesiredCount = number
    StaticServiceDesiredCount = number
    ProxyServiceDesiredCount = number
  })
  
}

#Variables for autoscaling module
variable "autoscaling" {
  type = object({
    MinCapacity = number
    MaxCapacity = number
    AvgCputoMaintain = number
    ScaleInCooldown = number
    ScaleOutCooldown = number
  })
}

#Variables for ECR module
variable "ecr" {
  type = object({
    ImageTagMutibility = string
  })
  
}

#Variables for ALB module
variable "alb" {
  type = object({
    HealthCheckPath = string
    HealthyCodes = string
    HealthyThreshold = number
    UnhealthThreshold = number
    HealthCheckInterval = number
    Timeout = number 
  })
  
}