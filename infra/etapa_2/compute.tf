# 1. ESTE BLOQUE ES EL QUE FALTA (La declaración de la AMI)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. INSTANCIAS CON DISCO DE 20GB
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Frontend" }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_instance" "backend_ventas" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Backend-Ventas" }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_instance" "backend_despachos" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_innovatech.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-Backend-Despachos" }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

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
}