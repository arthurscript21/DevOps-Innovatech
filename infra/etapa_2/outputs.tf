output "ip_privada_database" {
  description = "IP privada de la Base de Datos (usada internamente por ECS)"
  value       = aws_instance.database.private_ip
}

output "ip_publica_database" {
  description = "IP pública de la Base de Datos"
  value       = aws_instance.database.public_ip
}