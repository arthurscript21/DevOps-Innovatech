output "IP_PUBLICA_FRONTEND" {
  value = aws_instance.frontend.public_ip
}

output "IP_PUBLICA_BACKEND_VENTAS" {
  value = aws_instance.backend_ventas.public_ip
}

output "IP_PUBLICA_BACKEND_DESPACHOS" {
  value = aws_instance.backend_despachos.public_ip
}

output "IP_PRIVADA_DATABASE" {
  value = aws_instance.database.private_ip
}