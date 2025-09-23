module "vpc" {
    source  = "./modules/vpc"
    vpcCidr = var.vpc.vpcCidr
    region  = var.region

    env     = var.environment.env
    owner   = var.environment.owner
}

module "ecr" {
    source = "./modules/ecr"

    env     = var.environment.env
    owner   = var.environment.owner
}

module "iam" {
    source = "./modules/iam"
    
    env     = var.environment.env
    owner   = var.environment.owner
}

module "alb" {
    source = "./modules/alb"
    ALBSGId = module.vpc.ALBSGId
    PublicSubnetIds = module.vpc.PublicSubnetIds
    env     = var.environment.env
    owner   = var.environment.owner
}

module "ecs" {
    source  = "./modules/ecs"

    VpcId   = module.vpc.VpcId

    AppRepo = module.ecr.AppRepo
    StaticRepo = module.ecr.StaticRepo
    ProxyRepo = module.ecr.ProxyRepo
    PublicSubnetIds = module.vpc.PublicSubnetIds
    AppSGId = module.vpc.AppSGId
    StaticSGId = module.vpc.StaticSGId
    ProxySGId = module.vpc.ProxySGId
    ECSTaskExcecutionRoleArn = module.iam.ECSTaskExcecutionRoleArn

    env     = var.environment.env
    owner   = var.environment.owner
}