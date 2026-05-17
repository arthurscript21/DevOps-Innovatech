data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# -------------------------------------------------------------------------
# 1. INSTANCIA: BASE DE DATOS (MySQL)
# -------------------------------------------------------------------------
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

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              
              # Levantar MySQL Server automáticamente
              docker run -d \
                --name mysql-db \
                -p 3306:3306 \
                -e MYSQL_ROOT_PASSWORD=ClaveSegura123 \
                --restart unless-stopped \
                mysql:8
              EOF
}

# -------------------------------------------------------------------------
# 2. INSTANCIA: BACKEND VENTAS
# -------------------------------------------------------------------------
resource "aws_instance" "backend_ventas" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Backend-Ventas" }

  iam_instance_profile   = "LabInstanceProfile"

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              EOF
}

# -------------------------------------------------------------------------
# 3. INSTANCIA: BACKEND DESPACHOS
# -------------------------------------------------------------------------
resource "aws_instance" "backend_despachos" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Backend-Despachos" }

  iam_instance_profile   = "LabInstanceProfile"

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              EOF
}

# -------------------------------------------------------------------------
# 4. INSTANCIA: FRONTEND
# -------------------------------------------------------------------------
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Frontend" }

  iam_instance_profile   = "LabInstanceProfile"

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              EOF
}