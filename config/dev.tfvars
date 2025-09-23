region = "us-east-1"

environment = {
    env = "dev"
    owner = "awais"
}

vpc = {
    vpcCidr = "10.0.0.0/16"
    NoOfSubnets = 2                     #2 will create two public and two private subnets
    SubnetCidrBits = 8                  #No of bits to be added to subnet mask for subnets infront of base cidr
}

ecs = {
    ECSTaskCpu = 1024                   #1024 units equals 1 vcpu
    ECSTaskMemory = 2048
    AppServiceDesiredCount = 1
    StaticServiceDesiredCount = 1
    ProxyServiceDesiredCount = 2        #Make sure it is more than minimum no of tasks in autoscaling
}

autoscaling = {
    MinCapacity = 1
    MaxCapacity = 3
    AvgCputoMaintain = 50               #Percentage
    ScaleInCooldown = 60                #Seconds
    ScaleOutCooldown = 60               #Seconds
}

ecr = {
    ImageTagMutibility = "MUTABLE"      #Select Either MUTABLE or IMMUTABLE
}

alb = {
    HealthCheckPath = "/"               #Default Health Check Path
    HealthyCodes = "200-399"            #Response codes that should be considered healthy
    HealthyThreshold = 3                #No of successful requests to consider the target healty
    UnhealthThreshold = 5               #No of failed requests to consider the target unhealty
    HealthCheckInterval = 30            #Time in seconds between requests
    Timeout = 5                         #Time in seconds that no response is considered failure
}