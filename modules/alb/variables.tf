variable "ALBSGId" {
  type = string
}

variable "owner" {
    type = string
}

variable "env" {
    type = string
}

variable "PublicSubnetIds" {
    type = list(string)
}

variable "VpcId" {
  type = string
}
