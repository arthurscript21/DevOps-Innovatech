provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg_app.id]

  # Instalación automática de Docker al iniciar
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io docker-compose
              sudo systemctl start docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = { Name = "Servidor-Innovatech" }
}