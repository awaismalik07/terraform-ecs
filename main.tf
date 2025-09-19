module "vpc" {
    source = "./modules/vpc"
    vpcCidr = var.vpc.vpcCidr
    region = var.region

    env = var.environment.env
    owner = var.environment.owner
}