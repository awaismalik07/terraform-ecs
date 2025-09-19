#Variables for VPC module
variable "vpc" {
  type = object({
    vpcCidr = string 
  })
}