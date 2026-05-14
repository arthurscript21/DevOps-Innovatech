output "ecr_repository_backend_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_repository_frontend_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ventas_ip" {
  value = aws_instance.backend_ventas.public_ip
}

output "backend_despachos_ip" {
  value = aws_instance.backend_despachos.public_ip
}