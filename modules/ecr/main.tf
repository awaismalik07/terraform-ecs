resource "aws_ecr_repository" "AppECR" {
    name = "awais-test-app"
    image_tag_mutability = "IMMUTABLE"
    
    image_scanning_configuration {
      scan_on_push = true

    }
}

resource "aws_ecr_repository" "StaticECR" {
    name = "awais-test-static"
    image_tag_mutability = "IMMUTABLE"
    
    image_scanning_configuration {
      scan_on_push = true

    }
}

resource "aws_ecr_repository" "ProxyECR" {
    name = "awais-test-proxy"
    image_tag_mutability = "IMMUTABLE"
    
    image_scanning_configuration {
      scan_on_push = true

    }
}

data "aws_caller_identity" "current" {}

resource "null_resource" "docker_build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      # Authenticate once
      aws ecr get-login-password --region us-east-1 \
        | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com

      # Build + push app
      docker build -t ${aws_ecr_repository.AppECR.repository_url}:latest ${path.module}/../../application/app
      docker push ${aws_ecr_repository.AppECR.repository_url}:latest

      #Build + push static
      docker build -t ${aws_ecr_repository.StaticECR.repository_url}:latest ${path.module}/../../application/static
      docker push ${aws_ecr_repository.StaticECR.repository_url}:latest

      #Build + push proxy
      docker build -t ${aws_ecr_repository.ProxyECR.repository_url}:latest ${path.module}/../../application/proxy
      docker push ${aws_ecr_repository.ProxyECR.repository_url}:latest
    EOT
  }

  triggers = {
    # rerun when any Dockerfile changes
    app_hash    = filesha256("${path.module}/../../application/app/dockerfile")
    static_hash    = filesha256("${path.module}/../../application/static/dockerfile")
    proxy_hash    = filesha256("${path.module}/../../application/proxy/dockerfile")
  }

  depends_on = [
    aws_ecr_repository.AppECR,
    aws_ecr_repository.StaticECR,
    aws_ecr_repository.ProxyECR
  ]
}