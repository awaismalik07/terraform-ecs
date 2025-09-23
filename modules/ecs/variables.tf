variable "VpcId" {
  type = string
}

variable "AppRepo" {
    type = string
}

variable "StaticRepo" {
    type = string
}

variable "ECSTaskCpu" {
  type = number
}

variable "ECSTaskMemory" {
  type = number
}

variable "ProxyRepo" {
    type = string
}

variable "PrivateSubnetIds" {
    type = list(string)
}

variable "AppServiceDesiredCount" {
  type = number
}
variable "StaticServiceDesiredCount" {
  type = number
}
variable "ProxyServiceDesiredCount" {
  type = number
  
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