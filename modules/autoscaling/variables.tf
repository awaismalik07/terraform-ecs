variable "owner" {
    type = string
}

variable "env" {
    type = string
}

variable "ECSClusterName" {
    type = string
}

variable "ProxyServiceName" {
    type = string
}

variable "MinCapacity" {
  type = number
}

variable "MaxCapacity" {
  type = number
}

variable "AvgCputoMaintain" {
  type = number
}

variable "ScaleInCooldown" {
    type = number
}

variable "ScaleOutCooldown" {
    type = number
  
}