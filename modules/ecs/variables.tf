variable "VpcId" {
  type = string
}

variable "AppRepo" {
    type = string
}

variable "StaticRepo" {
    type = string
}

variable "ProxyRepo" {
    type = string
}

variable "PublicSubnetIds" {
    type = list(string)
}

variable "AppSGId" {
    type = string
}

variable "StaticSGId" {
    type = string
}

variable "ProxySGId" {
    type = string
}
variable "ALBTgArn" {
    type = string
}
variable "owner" {
    type = string
}

variable "env" {
    type = string
}

variable "ECSTaskExcecutionRoleArn" {
  type = string
}

variable "ALBArn" {
  type = string
}