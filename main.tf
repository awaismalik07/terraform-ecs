module "vpc" {
    source  = "./modules/vpc"

    region  = var.region

    env     = var.environment.env
    owner   = var.environment.owner

    vpcCidr = var.vpc.vpcCidr
    NoOfSubnets = var.vpc.NoOfSubnets
    SubnetCidrBits = var.vpc.SubnetCidrBits
}

module "ecr" {
    source = "./modules/ecr"

    env     = var.environment.env
    owner   = var.environment.owner

    ImageTagMutibility = var.ecr.ImageTagMutibility
}

module "iam" {
    source = "./modules/iam"
    
    env     = var.environment.env
    owner   = var.environment.owner
}

module "alb" {
    source = "./modules/alb"

    env     = var.environment.env
    owner   = var.environment.owner

    VpcId   = module.vpc.VpcId
    ALBSGId = module.vpc.ALBSGId
    PublicSubnetIds = module.vpc.PublicSubnetIds

    HealthCheckPath = var.alb.HealthCheckPath
    HealthyCodes = var.alb.HealthyCodes
    HealthyThreshold = var.alb.HealthyThreshold
    UnhealthThreshold = var.alb.UnhealthThreshold
    HealthCheckInterval = var.alb.HealthCheckInterval
    Timeout = var.alb.Timeout
}

module "ecs" {
    source  = "./modules/ecs"

    env     = var.environment.env
    owner   = var.environment.owner

    VpcId   = module.vpc.VpcId
    PrivateSubnetIds = module.vpc.PrivateSubnetIds
    AppSGId = module.vpc.AppSGId
    StaticSGId = module.vpc.StaticSGId
    ProxySGId = module.vpc.ProxySGId

    AppRepo = module.ecr.AppRepo
    StaticRepo = module.ecr.StaticRepo
    ProxyRepo = module.ecr.ProxyRepo

    ECSTaskExcecutionRoleArn = module.iam.ECSTaskExcecutionRoleArn

    ALBTgArn = module.alb.ALBTgArn
    ALBArn = module.alb.ALBArn

    ECSTaskCpu = var.ecs.ECSTaskCpu
    ECSTaskMemory = var.ecs.ECSTaskMemory
    AppServiceDesiredCount = var.ecs.AppServiceDesiredCount
    StaticServiceDesiredCount = var.ecs.StaticServiceDesiredCount
    ProxyServiceDesiredCount = var.ecs.ProxyServiceDesiredCount
}

module "autoscaling" {
    source = "./modules/autoscaling"

    env     = var.environment.env
    owner   = var.environment.owner

    ECSClusterName = module.ecs.ECSClusterName
    ProxyServiceName = module.ecs.ProxyServiceName
    
    MaxCapacity = var.autoscaling.MaxCapacity
    MinCapacity = var.autoscaling.MinCapacity
    ScaleInCooldown = var.autoscaling.ScaleInCooldown
    ScaleOutCooldown = var.autoscaling.ScaleOutCooldown
    AvgCputoMaintain = var.autoscaling.AvgCputoMaintain
}