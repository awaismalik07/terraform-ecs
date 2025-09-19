module "vpc" {
    source = "./modules/vpc"
    vpcCidr = var.vpc.vpcCidr
    env = var.environment.env
    owner = var.environment.owner
}