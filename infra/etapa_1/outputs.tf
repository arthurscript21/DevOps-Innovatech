output "instancia_ip_publica" {
  description = "Dirección IP pública de la instancia creada"
  value       = aws_instance.app_server.public_ip
}