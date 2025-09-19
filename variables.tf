#AWS Region
variable "region" {
  type = string
}

#Variables for Environment
variable "environment" {
  type = object({
    env = "test"
    owner = "awais"
  })
}

#Variables for VPC module
variable "vpc" {
  type = object({
    vpcCidr = string 
  })
}