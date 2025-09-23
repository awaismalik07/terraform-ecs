variable "region" {
  type = string
}

variable "vpcCidr" {
    type = string  
}

variable "NoOfSubnets" {
    type = number
}

variable "SubnetCidrBits" {
    type = number
}

variable "env" {
    type = string
}

variable "owner" {
    type = string
}