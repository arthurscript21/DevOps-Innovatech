output "ecr_repository_backend_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_repository_frontend_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}