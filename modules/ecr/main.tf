resource "aws_ecr_repository" "ECR" {
    name = "awais-test-app"
    image_tag_mutability = "IMMUTABLE"
    
    image_scanning_configuration {
      scan_on_push = true

    }
}

