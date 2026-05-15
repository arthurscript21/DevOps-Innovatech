resource "aws_ecr_repository" "innovatech-back-ventas" {
  name                 = "innovatech-back-ventas"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "innovatech-back-despachos" {
  name                 = "innovatech-back-despachos"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "frontend" {
  name                 = "innovatech-frontend"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}