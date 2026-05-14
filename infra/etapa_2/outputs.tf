output "ip_publica_frontend" {
  value = aws_instance.frontend.public_ip
}

output "ip_publica_backend_ventas" {
  value = aws_instance.backend_ventas.public_ip
}

output "ip_publica_backend_despachos" {
  value = aws_instance.backend_despachos.public_ip
}

output "ecr_url_ventas" { value = aws_ecr_repository.back_ventas.repository_url }
output "ecr_url_despachos" { value = aws_ecr_repository.back_despachos.repository_url }
output "ecr_url_frontend" { value = aws_ecr_repository.frontend.repository_url }

output "ip_frontend" { value = aws_instance.frontend.public_ip }
output "ip_ventas" { value = aws_instance.backend_ventas.public_ip }
output "ip_despachos" { value = aws_instance.backend_despachos.public_ip }
output "ip_database" { value = aws_instance.database.public_ip }