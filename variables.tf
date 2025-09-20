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
  })
}