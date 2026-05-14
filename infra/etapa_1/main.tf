# ==========================================
# 1. VARIABLES
# ==========================================
variable "aws_region" { default = "us-east-1" }
variable "ami_id"     { default = "ami-04b70fa74e45c3917" } # Ubuntu 22.04
variable "instance_type" { default = "t2.micro" }

# ==========================================
# 2. PROVEEDOR
# ==========================================
provider "aws" {
  region = var.aws_region
}

# ==========================================
# 3. RED (Compartida para las 3 instancias)
# ==========================================
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "vpc-innovatech" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# ==========================================
# 4. SEGURIDAD (Firewall)
# ==========================================
resource "aws_security_group" "sg_app" {
  name        = "sg_innovatech_multi"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Puertos para los backends
  ingress {
    from_port   = 8081
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==========================================
# 5. LAS 3 INSTANCIAS
# ==========================================

# --- INSTANCIA FRONTEND ---
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg_app.id]
  key_name               = "key_proyecto" # <--- Cambia esto si tu llave tiene otro nombre

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io docker-compose
              sudo usermod -aG docker ubuntu
              mkdir -p /home/ubuntu/app && chown ubuntu:ubuntu /home/ubuntu/app
              EOF
  tags = { Name = "Innovatech-Frontend" }
}

# --- INSTANCIA BACKEND VENTAS ---
resource "aws_instance" "back_ventas" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg_app.id]
  key_name               = "key_proyecto"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io docker-compose
              sudo usermod -aG docker ubuntu
              mkdir -p /home/ubuntu/app && chown ubuntu:ubuntu /home/ubuntu/app
              EOF
  tags = { Name = "Innovatech-Back-Ventas" }
}

# --- INSTANCIA BACKEND DESPACHOS ---
resource "aws_instance" "back_despachos" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg_app.id]
  key_name               = "key_proyecto"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io docker-compose
              sudo usermod -aG docker ubuntu
              mkdir -p /home/ubuntu/app && chown ubuntu:ubuntu /home/ubuntu/app
              EOF
  tags = { Name = "Innovatech-Back-Despachos" }
}

# ==========================================
# 6. OUTPUTS (Las 3 IPs que van a GitHub)
# ==========================================
output "IP_FRONTEND" { value = aws_instance.frontend.public_ip }
output "IP_VENTAS"   { value = aws_instance.back_ventas.public_ip }
output "IP_DESPACHOS" { value = aws_instance.back_despachos.public_ip }