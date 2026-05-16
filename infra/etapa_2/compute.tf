# 1. Declaración de la AMI para Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. ÚNICA INSTANCIA NECESARIA: Base de Datos Relacional Automatizada
resource "aws_instance" "database" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Database" }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  # SCRIPT DE AUTOMATIZACIÓN: Instala Docker y levanta MySQL automáticamente
  user_data = <<-EOF
              #!/bin/bash
              # 1. Actualizar el sistema operativo
              sudo yum update -y

              # 2. Instalar e iniciar Docker
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker

              # 3. Levantar el contenedor oficial de MySQL 8 en el puerto 3306
              # Se configura con la contraseña que esperan tus microservicios de Spring Boot
              docker run -d \
                --name mysql-db \
                -p 3306:3306 \
                -e MYSQL_ROOT_PASSWORD=ClaveSegura123 \
                --restart unless-stopped \
                mysql:8
              EOF
}