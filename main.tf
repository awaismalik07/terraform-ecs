module "vpc" {
    source = "./modules/vpc"
    vpcCidr = var.vpc.vpcCidr
}