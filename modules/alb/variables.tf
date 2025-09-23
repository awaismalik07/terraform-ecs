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

variable "HealthCheckPath" {
  type = string
}

variable "HealthyCodes" {
  type = string
}

variable "HealthCheckInterval" {
  type = number
}

variable "HealthyThreshold" {
  type = number
}

variable "UnhealthThreshold" {
  type = number 
}

variable "Timeout" {
  type = number  
}