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

module "ecs" {
    source  = "./modules/ecs"
    
    VpcId   = module.vpc.VpcId
    env     = var.environment.env
    owner   = var.environment.owner
}