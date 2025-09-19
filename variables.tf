#Variables for Environment
variable "Environment" {
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