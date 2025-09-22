#Cluster
resource "aws_ecs_cluster" "ECSCluster" {
    name    = "${owner}-${env}-Cluster"
    
    tags = {
      name  = "${owner}-${env}-Cluster"
    }
}

#Service Discovery to be used by proxy
resource "aws_service_discovery_private_dns_namespace" "ServiceDiscoveryNamespace" {
    name = "${var.owner}.local"
    vpc = var.VpcId
}

resource "aws_service_discovery_service" "AppService" {
    name = "app"

    dns_config {
      namespace_id = aws_service_discovery_private_dns_namespace.ServiceDiscoveryNamespace.id
      
      dns_records {
        ttl = 15
        type = "A"
      }
    
    }   
  
}

resource "aws_service_discovery_service" "StaticService" {
    name = "static"

    dns_config {
      namespace_id = aws_service_discovery_private_dns_namespace.ServiceDiscoveryNamespace.id
      
      dns_records {
        ttl = 15
        type = "A"
      }
    
    }   
  
}