output "AppRepo" {
    value = aws_ecr_repository.AppECR.repository_url
}

output "StaticRepo" {
    value = aws_ecr_repository.StaticECR.repository_url
}

output "ProxyRepo" {
    value = aws_ecr_repository.ProxyECR.repository_url
}

