resource "aws_ecs_cluster" "ECSCluster" {
    name    = "${owner}-${env}-Cluster"
    
    tags = {
      name  = "${owner}-${env}-Cluster"
    }
}